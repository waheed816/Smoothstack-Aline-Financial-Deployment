def application_logs(response_json):
    print("\033[1;32;40mAPPLICATION SUMMARY:\033[0m")
    print("   \033[1;40;33mAPPLICATION ID:\033[0m\033[1;34m", response_json["id"], "\033[0m")
    print("   \033[1;40;33mAPPLICATION TYPE:\033[0m\033[1;34m", response_json["applicationType"], "\033[0m")
    if response_json["status"] == 'DENIED':
        print("   \033[1;40;33mAPPLICATION STATUS:\033[0m\033[1;31m", response_json["status"], "\033[0m")
    else:
        print("   \033[1;40;33mAPPLICATION STATUS:\033[0m\033[1;32m", response_json["status"], "\033[0m")


    if response_json["status"] == 'DENIED':
        print("      \033[1;40;33mREASON:\033[0m\033[1;31m", response_json["reasons"][0], "\033[0m")
        print("      \033[1;40;33mNOTE:\033[0m\033[1;31m", "Income must be at least $15,000", "\033[0m")

    print("   \033[1;30;42mAPPLICANT INFO:\033[0m")
    print("      \033[1;40;33mAPPLICANT ID:\033[0m\033[1;34m", response_json["applicants"][0]["id"], "\033[0m")
    print("      \033[1;40;33mAPPLICANT NAME:\033[0m\033[1;34m", response_json["applicants"][0]["firstName"], response_json["applicants"][0]["lastName"], "\033[0m")
    print("      \033[1;40;33mLAST 4(SSN):\033[0m\033[1;34m", response_json["applicants"][0]["socialSecurity"][-4:], "\033[0m")
    if response_json["status"] == 'DENIED':
        income = response_json["applicants"][0]["income"] / 100
        print(f"      \033[1;40;33mMEMBERSHIP:\033[0m\033[1;31m DENIED (Limited Income)\033[0m")
        print(f"      \033[1;40;33mACCOUNT CREATED:\033[0m\033[1;31m NONE (Limited Income)\033[0m")
        print(f"      \033[1;40;33mAPPLICANT INCOME:\033[0m\033[1;31m ${income:,.2f}\033[0m")
        print("\n\033[1;32;40m===============================================\033[0m\n")
        return
    else:
        print("      \033[1;40;33mMEMBERSHIP ID:\033[0m\033[1;34m", response_json["createdMembers"][0]["membershipId"], "\033[0m")
        if response_json["applicationType"] == "CHECKING_AND_SAVINGS":
            print("      \033[1;40;33mACCOUNTS CREATED:\033[0m\033[1;34m", response_json["applicationType"], "\033[0m")
        else:
            print("      \033[1;40;33mACCOUNT CREATED:\033[0m\033[1;34m", response_json["applicationType"], "\033[0m")

        created_accounts = response_json["createdAccounts"]
        created_accounts = list(reversed(created_accounts))

        for account in created_accounts:
            print(f"         \033[1;40;33m{account['accountType']} ACCOUNT#:\033[0m\033[1;34m {account['accountNumber']}\033[0m")
        print("\n\033[1;32;40m===============================================\033[0m\n")


        return response_json["createdMembers"][0]["membershipId"]
