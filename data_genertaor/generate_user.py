from faker import Faker
import os
from dotenv import load_dotenv
from generate_application import generate_applications
import json
import requests
from create_user_body import create_user_request_bodies
from get_created_user_info import get_user_info

load_dotenv()

def generate_users(user_type, for_transactions=False):

    post_user_url = os.getenv('POST_USER_URL')

    if user_type == 'member':
        user_data = generate_applications(True)
        members_created = []

        # print("USER DATA >>>", user_data)

        for membership_id, member_info in user_data.items():

            last_4_ssn = member_info[0]

            # print("MEMBER INFO >>>", member_info)

            post_user_body = create_user_request_bodies(user_type, membership_id, last_4_ssn)
            response = requests.post(post_user_url, json=post_user_body)

            iteration = 0
            while response.status_code in {400, 409, 500}:
                iteration += 1
                if iteration == 10:
                    print("\033[1;31mThere was an error in creating the user.\033[0m")
                    print("\033[1;31mERROR:" + str(response.status_code) + "\033[0m", end=' ')
                    print("\033[1;31m" + response.text + "\033[0m\n")
                    return
                post_user_body = create_user_request_bodies(user_type, membership_id, last_4_ssn)
                response = requests.post(post_user_url, json=post_user_body)

            if response.status_code in {201, 422}:
                members_created.append(membership_id)



        members_created = get_user_info(members_created)

        if for_transactions == True:
            return members_created
        
        password = os.getenv('USER_PASSWORD')

        print("\n\033[1;30;42mTHE FOLLOWING MEMBER USERS HAVE BEEN CREATED\033[0m")
        print("\033[1;30;42m============================================\033[0m\n\n")
        for member in members_created:
            print("\033[1;40;33mID:\033[0m\033[1;34m", member['id'], "\033[0m")
            print("\033[1;40;33mNAME:\033[0m\033[1;34m", member['firstName'] + " " + member['lastName'], "\033[0m")
            print("\033[1;40;33mUSERNAME:\033[0m\033[1;34m", member['username'], "\033[0m")
            print("\033[1;40;33mEMAIL:\033[0m\033[1;34m", member['email'], "\033[0m")
            print("\033[1;40;33mPASSWORD:\033[0m\033[1;34m", password, "\033[0m")
            print("\033[1;40;33mROLE:\033[0m\033[1;34m", member['role'], "\033[0m")
            print("\033[1;40;33mMEMBER ID:\033[0m\033[1;34m", member['memberId'], "\033[0m")
            print("\033[1;40;33mMEMBERSHIP ID:\033[0m\033[1;34m", member['membershipId'], "\033[0m")
            print("\n\033[1;32;40m=====================================\033[0m\n")

        return members_created
    else:
        admin_infos = []

        number_of_admins = 3

        for _ in range(number_of_admins):
            post_admin_user_body = create_user_request_bodies(user_type)

            response = requests.post(post_user_url, json=post_admin_user_body)
            iteration = 0
            while response.status_code in {400, 409, 500}:
                post_admin_user_body = create_user_request_bodies(user_type)
                response = requests.post(post_user_url, json=post_admin_user_body)

            if response.status_code == 201:
                response_json = response.json()

                admin_name = response_json['firstName'] + " " + response_json['lastName']

                admin_info = {
                    'id': response_json['id'],
                    'name': admin_name,
                    'username': response_json['username'],
                    'email': response_json['email'],
                    'password': post_admin_user_body['password'],
                    'role': response_json['role'],
                }

                admin_infos.append(admin_info)

        print("\n\033[1;30;42mTHE FOLLOWING ADMIN USERS HAVE BEEN CREATED\033[0m")
        print("\033[1;30;42m===========================================\033[0m\n")

        for admin_info in admin_infos:
            print("\033[1;40;33mUSER ID:\033[0m\033[1;34m", admin_info['id'], "\033[0m")
            print("\033[1;40;33mNAME:\033[0m\033[1;34m", admin_info['name'], "\033[0m")
            print("\033[1;40;33mUSERNAME:\033[0m\033[1;34m", admin_info['username'], "\033[0m")
            print("\033[1;40;33mEMAIL:\033[0m\033[1;34m", admin_info['email'], "\033[0m")
            print("\033[1;40;33mPASSWORD:\033[0m\033[1;34m", admin_info['password'], "\033[0m")
            print("\033[1;40;33mROLE:\033[0m\033[1;34m", admin_info['role'], "\033[0m")
            print("\n\033[1;30;42m=========================================\033[0m\n")

        return admin_infos



# generate_users('member')
