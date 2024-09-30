import psycopg2
from datetime import datetime
from litellm import completion
import os

HOST = os.getenv("DB_HOST", "localhost")
PORT = os.getenv("DB_PORT", "5432")
DATABASE = os.getenv("DB_NAME", "scavengr_dev")
USER = os.getenv("DB_USER", "postgres")
PASSWORD = os.getenv("DB_PASSWORD", "postgres")
LITELLM_KEY = os.getenv("LITELLM_API_KEY")
LITELLM_URL = os.getenv("LITELLM_BASE_URL")
INSTRUCTIONS = """
Instructions:
- You are an expert storyteller / writer
- Write like Samuel Beckett
- Combine the material into a coherent story
- It's ok to break apart the sentences and mix and match them.
"""


def get_responses(
    host: str, port: str, database: str, user: str, password: str
) -> list:
    """
    This function connect to PostgreSQL and fetch the user's inputs.
    return:List[str], where each string is the response from user
    """
    connection = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password,
    )
    cursor = connection.cursor()
    fetch_query = """
    SELECT content FROM public.location_responses;
    """
    cursor.execute(fetch_query)
    contents = cursor.fetchall()
    gathered_contents = []
    for content in contents:
        gathered_contents.append(content[0])
    cursor.close()
    connection.close()
    return gathered_contents


def gen_story(instructions: str, gathered_contents: str, key: str, url: str) -> str:
    """
    This function connects to ChatGPT and feed the user's inputs to generate a story.
    return: str that is the generated story, from ChatGPT-4
    """
    prompt = f"""
    {instructions}
    Material:
    {str(gathered_contents)}
    """
    print(prompt)
    response = completion(
        model="gpt-4o-mini",
        messages=[{"content": prompt, "role": "user"}],
        api_key=key,
        base_url=url,
    )
    return response["choices"][0]["message"]["content"]


if __name__ == "__main__":
    gathered_contents = get_responses(
        host=HOST, port=PORT, database=DATABASE, user=USER, password=PASSWORD
    )
    story_str = gen_story(
        instructions=INSTRUCTIONS,
        gathered_contents=gathered_contents,
        key=LITELLM_KEY,
        url=LITELLM_URL,
    )
    print(story_str)
