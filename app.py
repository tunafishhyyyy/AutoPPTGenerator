from flask import Flask, render_template, request, send_from_directory, redirect, url_for, flash
import os
import uuid
import datetime
from werkzeug.utils import secure_filename
from app.utils.llm_client import analyze_text_with_llm
from app.utils.ppt_processor import generate_ppt_from_template
from app.utils.text_analyzer import split_text_to_slides

UPLOAD_FOLDER = 'uploads'
GENERATED_FOLDER = 'generated'
ALLOWED_EXTENSIONS = {'pptx', 'potx'}


app = Flask(__name__, template_folder='app/templates', static_folder='app/static')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['GENERATED_FOLDER'] = GENERATED_FOLDER
app.secret_key = 'your_secret_key'  # Replace with a secure key

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(GENERATED_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def cleanup_old_files():
    """Remove files older than 1 hour from uploads and generated folders"""
    try:
        current_time = datetime.datetime.now()
        for folder in [UPLOAD_FOLDER, GENERATED_FOLDER]:
            if os.path.exists(folder):
                for filename in os.listdir(folder):
                    file_path = os.path.join(folder, filename)
                    if os.path.isfile(file_path):
                        file_time = datetime.datetime.fromtimestamp(os.path.getctime(file_path))
                        if (current_time - file_time).total_seconds() > 3600:  # 1 hour
                            os.remove(file_path)
    except Exception:
        pass  # Silently fail cleanup to not interrupt main functionality

@app.route('/', methods=['GET', 'POST'])
def index():
    # Clean up old files on each request
    cleanup_old_files()
    
    if request.method == 'POST':
        try:
            text = request.form.get('text')
            guidance = request.form.get('guidance')
            api_key = request.form.get('api_key')
            file = request.files.get('template')
            
            if not text or not api_key:
                flash('Please provide text and LLM API key.')
                return redirect(request.url)
                
            # Template is now optional
            template_path = None
            filename = "basic_presentation.pptx"
            
            if file and file.filename and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                template_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(template_path)
            # Analyze and split text
            try:
                slides_content = split_text_to_slides(text, guidance, api_key)
            except Exception as e:
                flash(f'LLM error: {str(e)}')
                return redirect(request.url)
            # Generate PPT with unique filename
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            unique_id = str(uuid.uuid4())[:8]
            if template_path:
                base_name = os.path.splitext(filename)[0]
                output_filename = f"{base_name}_{timestamp}_{unique_id}.pptx"
            else:
                output_filename = f"presentation_{timestamp}_{unique_id}.pptx"
            
            output_path = os.path.join(app.config['GENERATED_FOLDER'], output_filename)
            try:
                generate_ppt_from_template(template_path, slides_content, output_path)
            except Exception as e:
                flash(f'PPT generation error: {str(e)}')
                return redirect(request.url)
            return redirect(url_for('download', filename=output_filename))
        except Exception as e:
            flash(f'Unexpected error: {str(e)}')
            return redirect(request.url)
    return render_template('index.html')

@app.route('/download/<filename>')
def download(filename):
    try:
        file_path = os.path.join(app.config['GENERATED_FOLDER'], filename)
        if not os.path.exists(file_path):
            flash('File not found. Please generate a new presentation.')
            return redirect(url_for('index'))
        return send_from_directory(app.config['GENERATED_FOLDER'], filename, as_attachment=True)
    except Exception as e:
        flash(f'File download error: {str(e)}')
        return redirect(url_for('index'))

# Custom error handler for 500
@app.errorhandler(500)
def internal_error(error):
    flash('Internal server error. Please try again.')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, port=7777)
