import boto3
import os
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
import urllib3
import json
import uuid

# deepseek
url = "https://api.deepseek.com/chat/completions"

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE']  # Get table name from environment variable
table = dynamodb.Table(table_name)

# secret
client = boto3.client('secretsmanager')
secret = client.get_secret_value(SecretId='app/ds-key')
api_key = json.loads(secret['SecretString'])['DEEPSEEK_API_KEY']

def lambda_handler(event, context):
    body = json.loads(event.get('body', '{}'))
    state = body['state'] if 'state' in event else str(uuid.uuid4())

    if not body['content']:
        return {
            'statusCode': 400,
            'body': 'Content is required'
        }

    try:
        # Example: Fetch item by primary key
        response = table.query(
            KeyConditionExpression=Key('state').eq(state)
        )
        
        # Check if item exists
        items = response.get('Items', None)
        items.append({'role': 'user', 'content': body['content']})

        response = call_deepseek(items)
        
        if 'error' in response:
            return {
                'statusCode': 500,
                'body': response['error']
            }
        
        return {
            'statusCode': 200,
            'body': {
                'state': state,
                'content': response['choices'][0]['message']
            }
        }

    except ClientError as e:
        print(f"Error: {e.response['Error']['Message']}")
        return {
            'statusCode': 500,
            'body': e.response['Error']['Message']
        }

def call_deepseek(history):
    # Prepare messages
    messages = []
    for message in history:
        if message['role'] in ('user', 'assistant'):
            messages.append({
                "role": message['role'],
                "content": message['content']
            })
    
    # Configure request
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }
    payload = {
        "model": "deepseek-chat",
        "messages": messages,
        "stream": False
    }
    
    # Create connection pool
    http = urllib3.PoolManager()
    
    try:
        # Make POST request
        response = http.request(
            "POST",
            url,
            body=json.dumps(payload).encode('utf-8'),
            headers=headers
        )
        
        # Check status
        if response.status != 200:
            return {"error": f"API request failed with status {response.status}"}
            
        # Parse JSON response
        return json.loads(response.data.decode('utf-8'))
        
    except urllib3.exceptions.HTTPError as e:
        return {"error": f"HTTP Error: {str(e)}"}
    except json.JSONDecodeError as e:
        return {"error": f"Failed to parse response: {str(e)}"}
    except Exception as e:
        return {"error": f"Unexpected error: {str(e)}"}