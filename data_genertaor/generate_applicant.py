from generate_application import generate_applications
from applicant_logs import applicant_logs
import json

def create_applicants():

    applicants = generate_applications(False, True)

    # print(json.dumps(applicants, indent=4))

    print("\n\033[1;30;42mTHE FOLLOWING APPLICANTS HAVE BEEN CREATED\033[0m")
    print("\033[1;30;42m==========================================\033[0m\n")

    for applicant in applicants:
        applicant_logs(applicant)

    return applicants
