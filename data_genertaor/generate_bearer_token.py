import requests
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Get URLs from environment variables
login_url = os.getenv('LOGIN_URL')

def generate_bearer_token():
    admin = {'username': 'admin1', 'password': 'P@ssword123'}
    response = requests.post(login_url, json=admin)
    bearer_token = response.headers['Authorization']
    return bearer_token
