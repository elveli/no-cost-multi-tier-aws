import json

json_data = '''
{
    "customer": {
        "id": 12345,
        "name": "Jordan",
        "account_details": {
            "plan": "Premium",
            "billing": {
                "current_month": 100,
                "previous_month": 80
            }
        }
    }
}
'''
data = json.loads(json_data)
current_month_billing = data["customer"]["account_details"]["billing"]["current_month"]
print("Current Month Billing:", current_month_billing)