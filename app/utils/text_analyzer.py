from .llm_client import analyze_text_with_llm

def split_text_to_slides(text, guidance, api_key):
    """
    Uses LLM to split text into slide contents.
    Returns a list of dicts: [{title, bullets, notes}]
    """
    return analyze_text_with_llm(text, guidance, api_key)
