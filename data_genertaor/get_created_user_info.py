from faker import Faker
import json
import requests
import os
from dotenv import load_dotenv

from generate_bearer_token import generate_bearer_token

# Load environment variables from .env file
load_dotenv()


def get_user_info(find_users):

    # Get URLs from environment variables
    get_users_url = os.getenv('GET_USERS_URL')

    # Define headers with the Bearer token
    headers = {'Authorization': generate_bearer_token()}

    # Adjust the size based on your API's pagination settings
    params = {"size": 100}

    users = []
    page = 0

    while True:
        # print("HERE", len(users))
        params["page"] = page
        response = requests.get(get_users_url, headers=headers, params=params).json()
        users.extend(response["content"])

        page += 1
        if response["last"]:
            break

    if find_users == False:
        member_users = [user for user in users if user.get('role') == 'MEMBER']
        return(member_users)
    else:
    # print("THERE", len(users))
        users = reversed(users)

        # print(users)

        users_found = []
        # iteration = 1
        for user in users:
            # print(user)
            # print(iteration)
            # iteration +=1
            # print(user.get('membershipId'))

            if user.get('membershipId') in find_users:
                users_found.append(user)

            if len(users_found) == len(find_users):
                break

        # print(users_found)
        # print(len(users_found))
        return users_found

# membershipIDs = ['74685525', '80308340']
# print(get_user_info(membershipIDs))
