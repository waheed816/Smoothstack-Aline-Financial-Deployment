from faker import Faker
import json
import requests
import os
from dotenv import load_dotenv
from generate_bearer_token import generate_bearer_token
from application_body import create_application_body
from application_logs import application_logs
import random


def generate_applications(for_user=False, for_applicant=False):
    # Load environment variables from .env file
    load_dotenv()

    post_applications_url = os.getenv('POST_APPLICATIONS_URL')

    # Define headers with the Bearer token
    headers = {'Authorization': generate_bearer_token()}
    account_types = ["CHECKING", "SAVINGS", "CHECKING_AND_SAVINGS"]
    incomes=[]

    def generate_high_income():
        return random.randint(2000000, 3000000)

    def generate_low_income():
        return random.randint(0, 1499999)

    if for_user==False:
        #If generating applications not to create users, generate denied and approved applications
        # with sufficient and insufficient incomes
        incomes = ['high_income', 'low_income']
    else:
        #If generating applications to create users, generate approved applications only
        #with sufficient income so that a membership ID can be generated
        incomes = ['high_income']


    #initialize an array fto collect membership ids
    #incase application is being generated to create users
    user_data = {}

    applicants_data = []

    if for_user == False and for_applicant == False:
        print("\n\033[1;30;42mTHE FOLLOWING APPLICATIONS HAVE BEEN CREATED\033[0m")
        print("\033[1;30;42m============================================\033[0m\n\n")

    for account in account_types:
        #Create an application for every account type
        for income in incomes:
            #Create applications with income based on if user will be genrated or not
            if income == 'high_income':
                income = generate_high_income()
            else:
                income = generate_low_income()

            application = create_application_body(account, income)

            response = requests.post(post_applications_url, headers=headers, json=application)

            #If application's uique columns has non-unique data, generate another application
            while response.status_code in {409, 500}:
                application = create_application_body(account, income)
                response = requests.post(post_applications_url, headers=headers, json=application)

            #If application has been created, log data
            if response.status_code == 201:
                response_json = response.json()
                # formatted_response = json.dumps(response.json(), indent=4)
                # print(formatted_response)
                # print(response_json)

                if for_applicant == True:
                    applicants_data.append(response_json)

                if for_user == True and for_applicant == False:
                    #If application is being generated to created user,
                    #collect the membership ids of approved applications
                    membership_Id = response_json["createdMembers"][0]["membershipId"]
                    last_4_ssn = response_json["applicants"][0]["socialSecurity"][-4:]
                    member_name = response_json["applicants"][0]["firstName"] + " " + response_json["applicants"][0]["lastName"]
                    email = response_json["applicants"][0]["email"]
                    user_data[membership_Id] = [last_4_ssn, member_name, email]

                if for_user == False and for_applicant == False:
                    application_logs(response_json)
            else:
                print("\033[1;31mThere was an error in creating the application.\033[0m")
                print("\033[1;31mERROR:" + str(response.status_code) + "\033[0m", end=' ')
                print("\033[1;31m" + response.text + "\033[0m\n")

    if for_user == True and for_applicant == False:
        return user_data

    if for_applicant == True:
        return applicants_data

# generate_applications(True)
# generate_applications()
