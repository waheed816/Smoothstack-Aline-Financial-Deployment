from faker import Faker
import random
import copy
import string
import json


def create_application_body(account_type, income):

    fake = Faker()

    application = {
            "applicationType": account_type,
            "noNewApplicants": False,
            "applicantIds": [],
            "applicants": [
                {
                "firstName": fake.first_name(),
                "middleName": fake.last_name(),
                "lastName": fake.last_name(),
                "dateOfBirth": fake.date_of_birth().isoformat(),
                "gender": fake.random_element(elements=('MALE', 'FEMALE', "OTHER", "UNSPECIFIED")),
                "email": fake.email(),
                "phone": fake.numerify('%##-###-####'),
                "socialSecurity": fake.ssn(),
                "driversLicense": 'DL' + ''.join(random.choices(string.digits, k=8)),
                "income": income,
                "address": fake.street_address(),
                "city": fake.city(),
                "state": fake.state_abbr(),
                "zipcode": fake.zipcode(),
                "mailingAddress": None,
                "mailingCity": None,
                "mailingState": None,
                "mailingZipcode": None
                }
            ]
        }

    #Make sure first name is consistent with gender
    if copy.copy(application['applicants'][0]['gender']) == 'MALE':
        application['applicants'][0]['firstName'] = fake.first_name_male()
    elif copy.copy(application['applicants'][0]['gender']) == 'FEMALE':
        application['applicants'][0]['firstName'] = fake.first_name_female()
    else:
        application['applicants'][0]['firstName'] = fake.last_name()

    #Make mailing address the same as residential address
    application['applicants'][0]['mailingAddress'] = copy.copy(application['applicants'][0]['address'])
    application['applicants'][0]['mailingCity'] = copy.copy(application['applicants'][0]['city'])
    application['applicants'][0]['mailingState'] = copy.copy(application['applicants'][0]['state'])
    application['applicants'][0]['mailingZipcode'] = copy.copy(application['applicants'][0]['zipcode'])

    #Make sure applicant's age is between 18-124
    birth_year = random.randint(1900, 2005)
    date_of_birth = copy.copy(application['applicants'][0]['dateOfBirth']).split("-")
    date_of_birth[0] = str(birth_year)
    valid_dob = "-".join(date_of_birth)
    application['applicants'][0]['dateOfBirth'] = valid_dob

    # formatted = json.dumps(application, indent=4)
    # print(formatted)


    return application
