from openai import OpenAI
import json

def analyze_text_with_llm(text, guidance, api_key):
    """
    Uses the provided LLM API key to analyze and split text into slide sections.
    Returns a list of slide contents (title, bullet points, notes).
    """
    if not api_key:
        raise ValueError("API key required")
    
    client = OpenAI(api_key=api_key)
    
    prompt = f"""
    Analyze the following text and break it down into sections suitable for PowerPoint slides. {guidance if guidance else ''}
    Return a JSON array of slides, each with the following structure:
    {{"title": "Slide Title", "bullets": ["Point 1", "Point 2"], "notes": "Speaker notes"}}
    
    Text:\n{text}
    """
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt}]
        )
        
        content = response.choices[0].message.content
        slides = json.loads(content)
        
        # Ensure slides is a list
        if not isinstance(slides, list):
            slides = [slides]
            
        return slides
    except json.JSONDecodeError:
        # If JSON parsing fails, create a basic slide structure
        return [{"title": "Generated Content", "bullets": [text[:200] + "..."], "notes": "Auto-generated from provided text"}]
    except Exception as e:
        raise ValueError(f"Failed to process with LLM: {str(e)}")
