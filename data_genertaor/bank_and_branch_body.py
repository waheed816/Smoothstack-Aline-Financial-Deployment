from faker import Faker
import copy

def create_post_bank_body():

    fake = Faker()

    post_bank_body ={
        "routingNumber": str(fake.random_int(min=100000000, max=999999999)),
        "address": f"{fake.random_int(min=1, max=9999)} {fake.street_name()}",
        "city": fake.city(),
        "state": fake.state_abbr(),
        "zipcode": fake.zipcode()
    }

    # post_bank_json = json.dumps(post_bank_body)

    return post_bank_body

def create_post_branch_body(bankId, branch_number):

    fake = Faker()

    post_branch_body ={
        "name": None,
        "address": f"{fake.random_int(min=1, max=9999)} {fake.street_name()}",
        "city": fake.city(),
        "state": fake.state_abbr(),
        "zipcode": fake.zipcode(),
        "phone": fake.numerify('%##-###-####'),
        "bankID": bankId
    }

    branch_name = post_branch_body["city"]

    post_branch_body['name'] = f"{branch_name} Branch {branch_number}"

    # post_bank_json = json.dumps(post_bank_body)

    return post_branch_body
