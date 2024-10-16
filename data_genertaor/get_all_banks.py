import os
from dotenv import load_dotenv
import requests
import json
from generate_bearer_token import generate_bearer_token

load_dotenv()

def get_all_banks():
    get_all_banks_url = os.getenv('BASE_BANK_URL')
    headers = {'Authorization': generate_bearer_token()}
    # Adjust the size based on your API's pagination settings
    params = {"size": 100}
    banks = []
    page = 0
    while True:
        params["page"] = page
        response = requests.get(get_all_banks_url, headers=headers, params=params)
        response_json = response.json()  # Extract JSON content from response
        banks.extend(response_json["content"])
        # print(page)
        page += 1
        if response_json["last"]:
            break

    return banks

# get_all_banks()




get_all_banks()
