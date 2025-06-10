#!/bin/bash

# Build and deploy script for AWS Lambda Docker container

# Configuration
AWS_REGION="us-east-1"
ECR_REPOSITORY_NAME="lambda-job-processor"
FUNCTION_NAME="job-processor-function"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "Starting deployment process..."

# Build Docker image
echo "Building Docker image..."
docker build -t $ECR_REPOSITORY_NAME .

# Create ECR repository if it doesn't exist
echo "Creating ECR repository..."
aws ecr create-repository --repository-name $ECR_REPOSITORY_NAME --region $AWS_REGION 2>/dev/null || true

# Get login token and authenticate Docker to ECR
echo "Authenticating with ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag image for ECR
echo "Tagging image..."
docker tag $ECR_REPOSITORY_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest

# Push image to ECR
echo "Pushing image to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest

# Create or update Lambda function
echo "Updating Lambda function..."
aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --image-uri $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest \
    --region $AWS_REGION 2>/dev/null || \
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --package-type Image \
    --code ImageUri=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest \
    --role arn:aws:iam::$AWS_ACCOUNT_ID:role/lambda-execution-role \
    --timeout 30 \
    --memory-size 512 \
    --region $AWS_REGION

echo "Deployment complete!"