from unittest.mock import patch
import pytest
from generate_applicant import create_applicants

@pytest.fixture
def mock_generate_applications():
    with patch('generate_application.generate_applications') as mock_generate_applications:
        yield mock_generate_applications

@pytest.fixture
def mock_applicant_logs():
    with patch('create_applicants.applicant_logs') as mock_applicant_logs:
        yield mock_applicant_logs

def test_create_applicants(mock_generate_applications, mock_applicant_logs):
    # Mock the return value of generate_applications
    mock_generate_applications.return_value = [{'applicant_id': 1, 'name': 'John Doe'}, {'applicant_id': 2, 'name': 'Jane Smith'}]

    # Call the function
    create_applicants()

    # Assert that generate_applications was called
    mock_generate_applications.assert_called_once_with(False, True)

    # Assert that applicant_logs was called for each applicant
    mock_applicant_logs.assert_called_with({'applicant_id': 1, 'name': 'John Doe'})
    mock_applicant_logs.assert_called_with({'applicant_id': 2, 'name': 'Jane Smith'})
