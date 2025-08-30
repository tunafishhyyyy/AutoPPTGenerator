from pptx import Presentation

def generate_ppt_from_template(template_path, slides_content, output_path):
    """
    Generates a new PPTX file using the uploaded template and slide contents.
    Copies style, layout, and images from the template.
    """
    prs = Presentation(template_path)
    # Remove existing slides
    while len(prs.slides) > 0:
        rId = prs.slides._sldIdLst[0].rId
        prs.part.drop_rel(rId)
        del prs.slides._sldIdLst[0]
    # Add new slides
    for slide_data in slides_content:
        layout = prs.slide_layouts[0]  # Use first layout for simplicity
        slide = prs.slides.add_slide(layout)
        title = slide.shapes.title
        title.text = slide_data.get('title', '')
        # Add bullet points
        if 'bullets' in slide_data:
            body_shape = slide.shapes.placeholders[1] if len(slide.shapes.placeholders) > 1 else None
            if body_shape:
                tf = body_shape.text_frame
                tf.clear()
                for bullet in slide_data['bullets']:
                    p = tf.add_paragraph()
                    p.text = bullet
        # Speaker notes (optional)
        if 'notes' in slide_data:
            slide.notes_slide.notes_text_frame.text = slide_data['notes']
    prs.save(output_path)
