from faker import Faker
from dotenv import load_dotenv
import os

load_dotenv()

def create_user_request_bodies(user_type, membership_id=None, last_4_ssn=None):

    fake = Faker()

    password = os.getenv('USER_PASSWORD')

    # print(password)

    if user_type == 'member':
        post_member_user_body ={
            "username": fake.user_name(),
            "password": password,
            "role": "member",
            "membershipId": membership_id,
            "lastFourOfSSN": last_4_ssn
        }

        # print(post_user_body)
        return post_member_user_body
    else:
        # print("admin user")
        post_admin_user_body = {
            "username": fake.user_name(),
            "password": password,
            "role": "admin",
            "firstName": fake.first_name(),
            "lastName": fake.last_name(),
            "email": fake.email(),
            "phone": fake.numerify('%##-###-####')
        }

        return post_admin_user_body
