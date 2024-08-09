#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

PATCHER_IMAGE="trendmicrocloudone/ecs-taskdef-patcher:2.3.44"  # Replace with the correct version

#ensure required directories exist
mkdir -p container_definitions

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
done

#list patched files in the container_definitions directory
echo "Patching complete. Patched files:"
ls -1 container_definitions/

#output the list of patched files as JSON
file_list=$(ls -1 container_definitions/ | jq -R . | jq -s .)
echo "{\"files\": $file_list}"
