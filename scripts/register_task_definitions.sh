#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

PATCHER_IMAGE="trendmicrocloudone/ecs-taskdef-patcher:2.3.44"  # Replace with the correct version

#ensure required directories exist
mkdir -p container_definitions

#array to hold the list of registered task definitions
registered_task_definitions=()

#iterate over each JSON file in the task_definitions directory
for input_file in task_definitions/*.json; do
  input_filename=$(basename "$input_file")  # Get the filename
  output_file="container_definitions/$input_filename"  # Define output file path
  
  #print the JSON content before patching
  echo "Patching file: $input_file"
  cat "$input_file"
  
  #validate JSON file using jq
  if ! jq empty "$input_file"; then
    echo "Error: Invalid JSON in $input_file"
    exit 1
  fi

  #print the command to be run for debugging
  echo "Running Docker command to patch the file:"
  echo "docker run --rm -v \"$(pwd)/task_definitions\":/mnt/input -v \"$(pwd)/container_definitions\":/mnt/output $PATCHER_IMAGE -i /mnt/input/$input_filename -o /mnt/output/$input_filename"
  
  #run the Docker container to patch the task definition
  docker run --rm \
    -v "$(pwd)/task_definitions":/mnt/input \
    -v "$(pwd)/container_definitions":/mnt/output \
    $PATCHER_IMAGE \
    -i "/mnt/input/$input_filename" \
    -o "/mnt/output/$input_filename"

  #check if the output file was created
  if [ ! -f "$output_file" ]; then
    echo "Error: Output file $output_file was not created."
    exit 1
  fi

  #register the patched task definition with AWS ECS
  aws ecs register-task-definition --cli-input-json file://"$output_file"

  # Add the registered task definition ARN to the array
  task_definition_arn=$(jq -r '.taskDefinitionArn' < "$output_file")
  registered_task_definitions+=("$task_definition_arn")
done

#list registered task definitions
echo "Registered task definitions:"
for task_definition in "${registered_task_definitions[@]}"; do
  echo "$task_definition"
done
