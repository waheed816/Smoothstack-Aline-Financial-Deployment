import os
from dotenv import load_dotenv
import requests
from faker import Faker
from generate_bearer_token import generate_bearer_token
from bank_and_branch_body import create_post_bank_body, create_post_branch_body
from get_all_banks import get_all_banks
from get_all_branches import get_all_branches
import json
import random

load_dotenv()

def create_banks(bank_or_branch='bank'):

    number_of_banks = 3

    post_bank_url=os.getenv('BASE_BANK_URL')

    headers = {'Authorization': generate_bearer_token()}

    created_banks = []

    for _ in range(number_of_banks):

        post_bank_body=create_post_bank_body()

        response = requests.post(post_bank_url, headers=headers, json=post_bank_body)

        while response.status_code != 201:
            post_bank_body=create_post_bank_body()
            headers = {'Authorization': generate_bearer_token()}
            response = requests.post(post_bank_url, headers=headers, json=post_bank_body)

        response_json = response.json()

        created_banks.append(response_json)

    if bank_or_branch == 'for_branch':
        return created_banks
    else:
        print("\n\033[1;30;42mTHE FOLLOWING BANKS HAVE BEEN CREATED\033[0m")
        print("\033[1;30;42m=====================================\033[0m\n")

        for bank in created_banks:
            print("\033[1;40;33mID:\033[0m\033[1;34m", bank['id'], "\033[0m")
            print("\033[1;40;33mROUTING NUMBER:\033[0m\033[1;34m", bank['routingNumber'], "\033[0m")
            print("\033[1;40;33mADDRESS:\033[0m\033[1;34m", bank['address'], "\033[0m")
            print("\033[1;40;33mCITY:\033[0m\033[1;34m", bank['city'], "\033[0m")
            print("\033[1;40;33mSTATE:\033[0m\033[1;34m", bank['state'], "\033[0m")
            print("\033[1;40;33mZIPCODE:\033[0m\033[1;34m", bank['zipcode'], "\033[0m")

            print("\n\033[1;30;42m===================================\033[0m\n")

        return create_banks


def create_branches():

    all_banks = get_all_banks()
    # all_banks = []

    #if there aren't 3 banks in database, then create 3 new banks
    if len(all_banks) < 3:
        all_banks=create_banks('for_branch')

    random_banks = random.sample(all_banks, 3)

    all_branches = get_all_branches()

    number_of_branches = len(all_branches)

    branch_name_number = number_of_branches + 1

    branches_url = os.getenv('BASE_BRANCH_URL')
    headers = {'Authorization': generate_bearer_token()}

    # print(branches_url)

    created_branches = []

    for bank in random_banks:


        post_branch_body = create_post_branch_body(bank['id'], branch_name_number)

        response = requests.post(branches_url, headers=headers, json=post_branch_body)

        while response.status_code != 201:
            post_branch_body=create_post_branch_body(bank['id'], branch_name_number)
            headers = {'Authorization': generate_bearer_token()}
            response = requests.post(branches_url, headers=headers, json=post_branch_body)

        response_json = response.json()

        created_branches.append(response_json)

        branch_name_number += 1

    print("\n\033[1;30;42mTHE FOLLOWING BRANCH LOCATIONS HAVE BEEN CREATED\033[0m")
    print("\033[1;30;42m================================================\033[0m\n")

    for branch in created_branches:
        print("\033[1;40;33mID:\033[0m\033[1;34m", branch['id'], "\033[0m")
        print("\033[1;40;33mNAME:\033[0m\033[1;34m", branch['name'], "\033[0m")
        print("\033[1;40;33mADDRESS:\033[0m\033[1;34m", branch['address'], "\033[0m")
        print("\033[1;40;33mCITY:\033[0m\033[1;34m", branch['city'], "\033[0m")
        print("\033[1;40;33mSTATE:\033[0m\033[1;34m", branch['state'], "\033[0m")
        print("\033[1;40;33mZIPCODE:\033[0m\033[1;34m", branch['zipcode'], "\033[0m")
        print("\033[1;30;42mPARENT BANK INFO:\033[0m")
        # print("\033[1;37;44m\033[1;37mPARENT BANK INFO:\033[0m")
        print("   \033[1;40;33mID:\033[0m\033[1;34m", branch['bank']['id'], "\033[0m")
        print("   \033[1;40;33mROUTING NUMBER:\033[0m\033[1;34m", branch['bank']['routingNumber'], "\033[0m")
        print("   \033[1;40;33mADDRESS:\033[0m\033[1;34m", branch['bank']['address'], "\033[0m")
        print("   \033[1;40;33mCITY:\033[0m\033[1;34m", branch['bank']['city'], "\033[0m")
        print("   \033[1;40;33mSTATE:\033[0m\033[1;34m", branch['bank']['state'], "\033[0m")
        print("   \033[1;40;33mZIPCODE:\033[0m\033[1;34m", branch['bank']['zipcode'], "\033[0m")

        print("\n\033[1;30;42m================================================\033[0m\n")



# create_branches()
# create_banks()
