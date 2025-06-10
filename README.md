# AWS Lambda Docker Container - Job Processor

This template provides a complete AWS Lambda function deployed as a Docker container that processes job data.

## Structure

- `Dockerfile` - Container configuration for AWS Lambda
- `lambda_function.py` - Main Lambda function code
- `requirements.txt` - Python dependencies
- `deploy.sh` - Deployment script
- `test_event.json` - Sample test event

## Function Specification

### Input Event Format
```json
{
    "job_title": "Software Engineer",
    "job_location": "San Francisco, CA, USA"
}
```

### Output Response Format
```json
{
    "statusCode": 200,
    "jobs": [
        {
            "id": 1,
            "title": "Software Engineer",
            "company": "Company Name",
            "location": "San Francisco, CA, USA",
            "description": "Job description text...",
            "publicationDate": "2025-06-10T12:00:00.000Z",
            "jobUrl": "https://www.somecompany.com/careers/software-engineer-1"
        }
    ]
}
```

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Docker installed and running
3. An IAM role for Lambda execution with basic permissions

## Deployment

1. Make the deploy script executable:
   ```bash
   chmod +x deploy.sh
   ```

2. Update the configuration variables in `deploy.sh`:
   - `AWS_REGION`
   - `ECR_REPOSITORY_NAME`
   - `FUNCTION_NAME`

3. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## Testing

You can test the function using the AWS CLI:

```bash
aws lambda invoke \
    --function-name job-processor-function \
    --payload file://test_event.json \
    response.json
```

## Customization

The `process_job_data()` function contains the main business logic. You can modify this function to:
- Integrate with external APIs
- Perform more sophisticated text analysis
- Connect to databases
- Add validation logic
- Implement job matching algorithms
