from faker import Faker
import json
import requests
import random
import os
from dotenv import load_dotenv
from generate_user import generate_users
from get_created_user_info import get_user_info
from transactions_body import create_transaction_body
from transaction_logs import transactions_logs

from generate_bearer_token import generate_bearer_token

# Load environment variables from .env file
load_dotenv()


def generate_transactions():

    # all_member_users = get_user_info(False)

    # print(all_member_users)

    # all_member_users=[]

    # if len(all_member_users) < 3:
    #     # print("HERE")
    #     generate_users('member', True)
        # all_member_users = get_user_info(False)

    all_member_users = generate_users('member', True)

    # print("THERE>>>>", all_member_users)

    transaction_users = random.sample(all_member_users, 2)
    user_accounts = []

    # Define headers with the Bearer token
    headers = {'Authorization': generate_bearer_token()}
    get_member_accounts_url = os.getenv('GET_MEMBER_ACCOUNTS_URL')

    # print(transaction_users) ####

    for user in transaction_users:
        response = requests.get(f"{get_member_accounts_url}/{user['memberId']}/accounts", headers=headers)
        response_json=response.json()
        # print ("HERE>>>>>>>", response_json) ####
        user_accounts.append(response_json['content'][0])


    transaction_types = ['DEPOSIT', 'REFUND', 'PURCHASE', 'PAYMENT', 'WITHDRAWAL']

    transactions_url = os.getenv('BASE_TRANSACTIONS_URL')

    user_transactions = []

    for account in user_accounts:
        transactions = []
        for transaction_type in transaction_types:
            transaction_body = create_transaction_body(transaction_type, account['accountNumber'])

            response = requests.post(transactions_url, headers=headers, json=transaction_body)

            response_json = response.json()

            transaction = requests.get(f"{transactions_url}/{response_json['id']}", headers=headers)

            transaction_json = transaction.json()

            transactions.append(transaction_json)

        user_transactions.append(transactions)

    transactions_summary = [
        {
            'user_info': transaction_users[0],
            'account_info': user_accounts[0],
            'transactions': user_transactions[0]
        },
        {
            'user_info': transaction_users[1],
            'account_info': user_accounts[1],
            'transactions': user_transactions[1]
        }
    ]

    #TRANSFER TYPE TRANSACTION
    transfer_body = create_transaction_body('TRANSFER', user_accounts[0]['accountNumber'], user_accounts[1]['accountNumber'])

    response = requests.post(f"{transactions_url}/transfer", headers=headers, json=transfer_body)

    response_json = response.json()

    transfer_transactions = []

    for transaction in response_json:

        transfer_transaction = requests.get(f"{transactions_url}/{transaction['id']}", headers=headers)

        transfer_transaction_json = transfer_transaction.json()

        transfer_transactions.append(transfer_transaction_json)

    transactions_summary[0]['transactions'].append(transfer_transactions[0])
    transactions_summary[1]['transactions'].append(transfer_transactions[1])



    transactions_logs(transactions_summary)
