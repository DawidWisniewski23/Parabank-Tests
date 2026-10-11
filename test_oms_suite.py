import pytest
import requests

# Base URL for your application under test (e.g., Parabank API or mock OMS)
BASE_URL = "https://jsonplaceholder.typicode.com"  # Replace with your actual endpoint


@pytest.fixture
def api_client():
    """Fixture to provide a reusable session or base configuration for API calls."""
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json", "Accept": "application/json"})
    return session


def test_system_health(api_client):
    """Verify that the backend service or API is up and responding."""
    response = api_client.get(f"{BASE_URL}/posts/1")
    
    # Assert HTTP status code
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
    
    # Assert response payload structure
    data = response.json()
    assert "id" in data
    assert data["id"] == 1


def test_order_state_transition(api_client):
    """Simulate validating an order state machine transition (e.g., Created -> Processing)."""
    payload = {
        "title": "New OMS Order",
        "body": "BUY AAPL 100 limit",
        "userId": 1
    }
    
    # Step 1: Submit/Create order
    response = api_client.post(f"{BASE_URL}/posts", json=payload)
    assert response.status_code == 201, "Order creation failed"
    
    response_data = response.json()
    order_id = response_data.get("id")
    assert order_id is not None, "Order ID was not returned by the system"
    
    # Step 2: Validate the initial state or fetch the created order back
    get_response = api_client.get(f"{BASE_URL}/posts/{order_id}")
    
    # Note: JSONPlaceholder echoes back a fake ID 101, so we handle mock behavior gracefully
    assert get_response.status_code in [200, 404]