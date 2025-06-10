import json
import logging
from typing import Dict, List, Any

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    AWS Lambda handler function that processes job data.

    Expected event structure:
    {
        "job_title": "Software Engineer",
        "job_location": "San Francisco, CA, USA"
    }

    Returns:
    {
        "jobs": [
            {
                "id": 1,
                "title": "Software Engineer",
                "company": "Company Name",
                "location": "San Francisco, CA, USA",
                "description": "Job description here...",
                "publicationDate": "2025-06-10T12:00:00.000Z",
                "jobUrl": "https://www.somecompany.com/careers/software-engineer-1"
            },
            {
                "id": 1,
                "title": "Software Engineer",
                "company": "Company Name",
                "location": "Full Remote",
                "description": "Job description here...",
                "publicationDate": "2025-06-10T12:00:00.000Z",
                "jobUrl": "https://www.somecompany.com/careers/software-engineer-2"
            }
        ]
    }
    """

    try:
        logger.info(f"Received event: {json.dumps(event)}")

        # Extract job data from event
        job_title = event.get('job_title', '')
        job_location = event.get('job_location', '')

        # Validate required fields
        if not job_title or not job_location:
            return {
                'statusCode': 400,
                'body': {
                    'error': 'Missing required fields: job_title and job_location are required'
                }
            }

        # Process the job data (example processing)
        processed_jobs = process_jobs_data(job_title, job_location)

        # Return response in the expected format
        response = {
            'statusCode': 200,
            'jobs': processed_jobs
        }

        logger.info(f"Returning response: {json.dumps(response)}")
        return response

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return {
            'statusCode': 500,
            'body': {
                'error': f'Internal server error: {str(e)}'
            }
        }


def process_jobs_data(job_title: str, job_location: str) -> List[Dict[str, Any]]:
    """
    Process job data and return structured job objects.
    This is where you would implement your business logic.
    """
    processed_jobs = []

    # Return as array
    return processed_jobs

