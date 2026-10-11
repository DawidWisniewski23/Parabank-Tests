import requests
import sys

OMS_URL = "https://httpbin.org/post"

def submit_order_safely(payload):
    print(f"[*] Submitting order for trader: {payload.get('trader_id')}...")
    
    try:
        response = requests.post(OMS_URL, json=payload, timeout=3.0)
    except requests.exceptions.Timeout:
        print("[ERROR] Request timed out. OMS gateway is not responding.")
        sys.exit(1)
    except requests.exceptions.RequestException as e:
        print(f"[ERROR] Network infrastructure failure: {e}")
        sys.exit(1)

    if response.status_code not in (200, 201):
        print(f"[ERROR] Expected HTTP 200/201, got {response.status_code}.")
        print(f"Body preview: {response.text[:200]}")
        sys.exit(1)

    content_type = response.headers.get("Content-Type", "")
    if "application/json" not in content_type:
        print(f"[ERROR] Expected JSON response, got '{content_type}'.")
        sys.exit(1)

    try:
        data = response.json()
    except ValueError:
        print("[ERROR] Response body contains malformed JSON.")
        sys.exit(1)

    print("[SUCCESS] Order successfully validated, transmitted, and parsed.")
    return data

# MAKE SURE THIS PART HAS NO SPACES/INDENTATION AT THE START OF THE LINE
if __name__ == "__main__":
    some_payload = {
        "trader_id": "T_PARIS_09",
        "symbol": "EUR/USD",
        "side": "BUY",
        "order_type": "LIMIT",
        "price": 1.0850,
        "quantity": 1000000
    }
    
    result = submit_order_safely(some_payload)
    print("\nEchoed Payload Received Back from Gateway:")
    print(result.get("json"))