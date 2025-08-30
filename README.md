# AutoPPTGenerator
**Text, Your Style – Auto-Generate a Presentation**

Create a publicly accessible web app that lets anyone turn bulk text, markdown, or prose into a fully formatted PowerPoint presentation that matches their chosen template's look and feel.

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Virtual environment (recommended)

### Installation & Setup

1. **Clone the repository:**
```bash
git clone https://github.com/tunafishhyyyy/AutoPPTGenerator.git
cd AutoPPTGenerator
```

2. **Set up virtual environment:**
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

3. **Install dependencies:**
```bash
pip install -r requirements.txt
```

4. **Run the application:**

**Using the start script (recommended):**
```bash
# Linux/Mac
./start.sh start    # Start the application
./start.sh status   # Check if running
./start.sh logs     # View real-time logs
./start.sh stop     # Stop the application
./start.sh restart  # Restart the application

# Windows
start.bat start     # Start the application
start.bat status    # Check if running
start.bat stop      # Stop the application
```

**Manual methods:**

**Development mode (foreground):**
```bash
python app.py
```

**Background mode:**
```bash
# Using nohup (keeps running after terminal closes)
nohup python app.py > app.log 2>&1 &

# Using screen (allows reconnecting to session)
screen -S autoppt
python app.py
# Press Ctrl+A, then D to detach

# Using systemd (for production servers)
# Create service file: /etc/systemd/system/autoppt.service
sudo systemctl start autoppt
sudo systemctl enable autoppt
```

5. **Access the application:**
   - **Local access:** `http://localhost:7777`
   - **Remote access:** `http://84.247.184.189:7777`
   - Replace with your server's IP address if different

### Quick Start Commands
```bash
# Quick start (Linux/Mac)
./start.sh start

# Check status
./start.sh status

# View logs
./start.sh logs

# Stop application
./start.sh stop
```

### Stopping Background Process
```bash
# Using start script (recommended)
./start.sh stop

# Manual methods
# Find and kill the process
ps aux | grep "python app.py"
kill <process_id>

# Or use pkill
pkill -f "python app.py"
```

## 📋 Features

### Core Functionality
- ✅ Paste large blocks of text or markdown
- ✅ Optional guidance for presentation style
- ✅ Support for OpenAI API (user-provided keys)
- ✅ **Optional** PowerPoint template upload (.pptx/.potx)
- ✅ Intelligent text-to-slides mapping
- ✅ Style preservation from templates
- ✅ Automatic slide generation with speaker notes

### Enhanced Features
- 🎨 Modern, responsive UI design
- 🛡️ Comprehensive error handling
- 🔒 Secure API key handling (not stored)
- 📱 Mobile-friendly interface
- ⚡ Fast processing with real-time feedback

## 🔧 Technical Architecture

### How It Works

**Text Analysis & Slide Mapping:**
The application uses advanced LLM processing to intelligently parse input text and map it to presentation slides. The system:
- Analyzes text structure and content themes
- Applies user guidance for tone and style
- Automatically determines optimal slide count
- Generates coherent slide titles and bullet points
- Creates relevant speaker notes for each slide

**Template Style Application:**
When a PowerPoint template is provided, the app:
- Preserves original slide layouts and designs
- Maintains color schemes and font styles
- Reuses existing images and visual elements
- Applies consistent formatting across generated slides
- Falls back to a clean, professional design when no template is provided

## 📁 Project Structure
```
AutoPPTGenerator/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── app/
│   ├── templates/
│   │   └── index.html    # Main UI template
│   ├── static/
│   │   └── css/
│   │       └── style.css # Modern UI styling
│   └── utils/
│       ├── llm_client.py    # OpenAI API integration
│       ├── ppt_processor.py # PowerPoint generation
│       └── text_analyzer.py # Text processing logic
├── uploads/              # Temporary template storage
└── generated/           # Output presentations
```

## 🔐 Security & Privacy
- API keys are never stored or logged
- Uploaded templates are temporarily stored and can be manually cleaned
- Generated presentations are stored locally (consider cleanup policies)
- No user data persistence

## 🛠️ Troubleshooting

### Common Issues
- **Port already in use**: The app tries port 9999. If busy, modify `port=9999` in `app.py`
- **OpenAI API errors**: Ensure valid API key and sufficient credits
- **Template upload issues**: Only .pptx and .potx files are supported
- **Memory issues**: Large texts or complex templates may require more RAM

### Logs
When running in background mode, check logs:
```bash
tail -f app.log  # For nohup method
screen -r autoppt  # For screen method
```

## 📄 License
MIT License - see LICENSE file for details

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

*Built with Flask, OpenAI API, and python-pptx*
```

## ObjectiveoPPTGenerator
Text, Your Style – Auto-Generate a Presentation
Create a publicly accessible web app that lets anyone turn bulk text, markdown, or prose into a fully formatted PowerPoint presentation that matches their chosen template’s look and feel.

Objective
Your app should allow users to:
Paste a large chunk of text (can be markdown or long-form prose)
Optionally enter a one-line guidance for the tone, structure, or use case (e.g.: “turn into an investor pitch deck”)
Provide their LLM API key of choice (e.g. OpenAI, Anthropic, Gemini)
Upload a PowerPoint template or presentation (.pptx or .potx)
The app then:
Analyzes and breaks down the input text into slide content and structure
Infers and applies the style, colors, fonts, and images from the uploaded PowerPoint file to the generated slides
Reuses images found in the uploaded template/presentation where appropriate
Generates and outputs a new .pptx file for user download—without generating new images using AI

Requirements
Users must be able to:
Paste or type a large block of text
Enter their own LLM API key (never stored or logged)
Upload a PowerPoint template or presentation file (.pptx/.potx)
Download the newly generated presentation
App must:
Map and split the input text intelligently into slide contents (not just “fixed 3 slides”)
Copy the uploaded template’s style and layout as much as possible (including images, layouts, colors, fonts)
Choose a reasonable number of slides, based on the text and optional guidance
Support any LLM provider, using API calls with user-supplied key
Be published in a public GitHub repository (with MIT License and full README)

Optional Enhancements (Not Required – For Extra Credit)
Auto-generate speaker notes for each slide (via LLM)
Support various tones/stylistic modes (e.g. professional, investor pitch, visual-heavy, technical)
Provide slide previews before download
Offer common-use-case guidance templates (“Sales deck”, “Research summary”, etc.)
Add robust error handling, file size/upload limits, and API retry logic

Deliverables
Public GitHub repository containing:
Full front-end (and back-end, if needed) code
MIT License
README with setup and usage instructions
Working hosted link (demo app)
Short write-up (200–300 words) explaining:
How the input text is parsed and mapped to slides
How your app applies the visual style and assets of the template




Evaluation Criteria (3 Marks)
Criteria
Marks
Output functionality
1.5
Code quality & clarity
1.0
UI/UX polish & extras
0.5


Notes
You may use any programming stack (Python)
You may apply reasonable technical limits (e.g., file size)
Only reuse images from the template file; do not create/generate images via AI
Inferring precise layout details is NOT required—do the best you can
Do not store or log any sensitive user input, especially API keys
