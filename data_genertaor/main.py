from generate_user import generate_users
from generate_applicant import create_applicants
from generate_application import generate_applications
from generate_banks_and_branches import create_banks, create_branches
from generate_transactions import generate_transactions

def create_more_data_prompt():
    while True:
        # print("\033[1;30;43m================================================\033[0m\n")
        more_data = input("\033[1;33;40mWOULD YOU LIKE TO GENERATE MORE DATA? (y/n)\033[0m ")

        if more_data == 'n' or more_data == 'y':
            choice_map['8']()
            break
        else:
            print("\n\033[1;31m" + f'\033[40m"\033[1;33m{more_data}\033[1;31m" IS NOT A VALID ENTRY' + "\033[0m\n")

    return more_data

# Mapping of choices to functions
choice_map = {
    "1": lambda: generate_users('admin'),
    "2": lambda: generate_users('member'),
    "3": create_applicants,
    "4": generate_applications,
    "5": generate_transactions,
    "6": create_banks,
    "7": create_branches,
    "8": lambda: print("\n\033[1;40;33mYOU HAVE EXITED THE DATA GENERATOR.\033[0m\n")
}

while True:
    print("\n\033[1;30;43m================================================\033[0m\n")
    print("\033[1;32;40mENTER 1 to Create New ADMIN USERS\033[0m\n")
    print("\033[1;32;40mENTER 2 to Create New MEMBER USERS\033[0m\n")
    print("\033[1;32;40mENTER 3 to Create New APPLICANTS\033[0m\n")
    print("\033[1;32;40mENTER 4 to Create New APPLICATIONS\033[0m\n")
    print("\033[1;32;40mENTER 5 to Create New TRANSACTIONS\033[0m\n")
    print("\033[1;32;40mENTER 6 to Create New BANKS\033[0m\n")
    print("\033[1;32;40mENTER 7 to Create New BANK BRANCHES\033[0m\n")
    print("\033[1;32;40mENTER 8 to EXIT\033[0m\n")
    print("\033[1;30;43m================================================\033[0m\n")
    print("\033[1;34;40mBASED ON THE OPTIONS ABOVE, \033[0m")
    choice = input("\033[1;34;40mWHAT WOULD YOU LIKE TO DO? \033[0m ")

    if choice in choice_map:
        if choice == '8':
            choice_map[choice]()
            break
        choice_map[choice]()
        more_data = create_more_data_prompt()
        if more_data == 'n':
            break
    else:
        print("\033[1;31m" + f'\n\033[40m"\033[1;33m{choice}\033[1;31m" IS NOT A VALID ENTRY' + "\033[0m")
