from datetime import datetime
import pytz
from tzlocal import get_localzone

def format_datetime(date_time_str):
    # print("HERE==============", date_time_str)
    # utc_date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%dT%H:%M:%S.%f')
    # local_timezone = get_localzone()
    # local_date_time_obj = utc_date_time_obj.astimezone(local_timezone)
    # formatted_date_time = local_date_time_obj.strftime('%A, %B %d, %Y, %I:%M%p %Z')
    utc_date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%dT%H:%M:%S.%f')
    local_timezone = get_localzone()
    local_date_time_obj = utc_date_time_obj.astimezone(local_timezone)
    formatted_date_time = local_date_time_obj.strftime('%A, %B %d, %Y')
    return formatted_date_time

    return formatted_date_time

def transactions_logs(transactions_summary):
    print("\n\033[1;32;40mTRANSACTIONS HAVE BEEN CREATED FOR ACCOUNTS BELONGING TO THE FOLLOWING USERS:\033[0m")
    print("\033[1;40;32m=============================================================================\033[0m\n\n")


    for transaction_info in transactions_summary:
        user_info = transaction_info['user_info']
        account_info = transaction_info['account_info']
        transactions = transaction_info['transactions']

        print("\033[1;30;42mUSER INFO:\033[0m")
        print("   \033[1;40;33mUSER ID:\033[0m\033[1;34m", user_info['id'], "\033[0m")
        print("   \033[1;40;33mNAME:\033[0m\033[1;34m", user_info['firstName'], user_info['lastName'], "\033[0m")
        print("   \033[1;40;33mUSERNAME:\033[0m\033[1;34m", user_info['username'], "\033[0m")
        print("   \033[1;40;33mEMAIL:\033[0m\033[1;34m", user_info['email'], "\033[0m\n")

        print("   \033[1;30;42mACCOUNT INFO:\033[0m")
        print("      \033[1;40;33mACCOUNT ID:\033[0m\033[1;34m", account_info['id'], "\033[0m")
        print("      \033[1;40;33mACCOUNT TYPE:\033[0m\033[1;34m", account_info['type'], "\033[0m")
        print("      \033[1;40;33mACCOUNT NUMBER:\033[0m\033[1;34m", account_info['accountNumber'], "\033[0m")
        print("      \033[1;40;33mACCOUNT BALANCE:\033[0m\033[1;32m ${:,.2f}\033[0m".format(account_info['balance']/100), end='\n\n')

        print("      \033[1;30;42mTRANSACTIONS:\033[0m")
        for transaction in transactions:
            print("         \033[1;40;33m------------------------------------------------\033[0m")
            print("         \033[1;40;33mTRANSACTION ID:\033[0m\033[1;34m", transaction['id'], "\033[0m")
            print("         \033[1;40;33mTRANSACTION TYPE:\033[0m\033[1;34m", transaction['type'], "\033[0m")
            print("         \033[1;40;33mTRANSACTION AMOUNT:\033[0m\033[1;32m ${:,.2f}\033[0m".format(transaction['amount']/100))
            print("         \033[1;40;33mTRANSACTION STATUS:\033[0m\033[1;34m", transaction['status'], "\033[0m")
            if transaction['type'] in {'TRANSFER_IN', 'TRANSFER_OUT'}:
                print("         \033[1;40;33mDESCRIPTION:\033[0m\033[1;34m", transaction['description'], "\033[0m")
            print("         \033[1;40;33mINITIAL BALANCE:\033[0m\033[1;32m ${:,.2f}\033[0m".format(transaction['initialBalance']/100))
            print("         \033[1;40;33mPOSTED BALANCE:\033[0m\033[1;32m ${:,.2f}\033[0m".format(transaction['postedBalance']/100))
            date_posted = format_datetime(transaction['date'])
            formatted_date_posted = f"\033[1;38;5;208m{date_posted}\033[0m"
            print("         \033[1;40;33mDATE POSTED:\033[0m", formatted_date_posted, end='\n')


            if transaction['type'] in {'PURCHASE', 'PAYMENT', 'REFUND'}:
                if transaction['merchant']:
                    print("         \033[1;30;42mMERCHANT INFO:\033[0m")
                    print("            \033[1;40;33mMERCHANT CODE:\033[0m\033[1;34m", transaction['merchant']['code'], "\033[0m")
                    print("            \033[1;40;33mMERCHANT NAME:\033[0m\033[1;34m", transaction['merchant']['name'], "\033[0m")

        print("         \033[1;40;33m------------------------------------------------\033[0m")


        print("\n\033[1;30;42m================================================================\033[0m\n")






# Print transactions summary
