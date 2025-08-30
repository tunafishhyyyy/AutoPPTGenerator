import openai

def analyze_text_with_llm(text, guidance, api_key):
    """
    Uses the provided LLM API key to analyze and split text into slide sections.
    Returns a list of slide contents (title, bullet points, notes).
    """
    if not api_key:
        raise ValueError("API key required")
    prompt = f"""
    Analyze the following text and break it down into sections suitable for PowerPoint slides. {guidance if guidance else ''}
    Return a JSON list of slides, each with a title, bullet points, and optional speaker notes.
    Text:\n{text}
    """
    openai.api_key = api_key
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": prompt}]
    )
    # Extract and parse response
    import json
    slides = []
    try:
        slides = json.loads(response['choices'][0]['message']['content'])
    except Exception:
        slides = []
    return slides
