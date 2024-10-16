import random

def create_transaction_body(transaction_type, account_number1, account_number2=None):

    add_money = random.randint(500000, 1000000)

    if transaction_type == 'REFUND':
        add_money = random.randint(2000, 50000)

    subtract_money = random.randint(10000, 50000)

    if transaction_type == 'WITHDRAWAL':
        subtract_money = random.choice([2000, 4000, 6000, 8000, 10000, 20000, 30000, 40000, 50000])


    if(transaction_type in {'DEPOSIT', 'REFUND'}):
        transaction_body = {
            "type": transaction_type,
            "method": "ACH",
            "amount": add_money,
            "merchantCode": random.randint(11111, 99999),
            "merchantName": None,
            "accountNumber": account_number1,
            "hold": True
        }

        transaction_body['merchantName'] = f"Merchant {transaction_body['merchantCode']}"

        return transaction_body

    if(transaction_type in {'PURCHASE', 'PAYMENT'}):
        transaction_body = {
            "type": transaction_type,
            "method": "ACH",
            "amount": subtract_money,
            "merchantCode": random.randint(11111, 99999),
            "merchantName": None,
            "accountNumber": account_number1,
            "hold": True
        }

        transaction_body['merchantName'] = f"Merchant {transaction_body['merchantCode']}"

        return transaction_body

    if(transaction_type == 'WITHDRAWAL'):
        transaction_body = {
            "type": "WITHDRAWAL",
            "method": "ATM",
            "amount": subtract_money,
            "accountNumber": account_number1,
            "hold": True
        }

        return transaction_body

    if(transaction_type == 'TRANSFER'):
        transaction_body ={
            "fromAccountNumber": account_number1,
            "toAccountNumber": account_number2,
            "amount": subtract_money
        }

        return transaction_body
