#!/bin/bash
set -e

#directory to store fetched task definitions
mkdir -p task_definitions

#fetch current task definitions from AWS
echo "Fetching current task definitions from AWS..."
aws ecs list-task-definitions --query "taskDefinitionArns" --output json > all_task_definitions.json

#print the raw task definitions fetched from AWS
echo "Raw task definitions fetched from AWS:"
cat all_task_definitions.json

#filter and save task definitions based on the keyword
KEYWORD="ecs-fargate-trend-demo-nginx:9"
jq -r --arg KEYWORD "$KEYWORD" '
  .[] |
  select(contains($KEYWORD)) |
  split(":") as $parts |
  {"arn": ., "family": ($parts[5] | split("/")[1]), "revision": ($parts[6] | tonumber)}
' all_task_definitions.json | jq -s '
  group_by(.family) |
  map(max_by(.revision))
' > filtered_task_definitions.json

echo "Filtered task definitions:"
cat filtered_task_definitions.json

#fetch the full task definition details for each highest revision and save to individual files
echo "Fetching full task definitions..."
mkdir -p task_definitions
for arn in $(jq -r '.[].arn' filtered_task_definitions.json); do
  family=$(echo $arn | awk -F'/' '{print $2}' | awk -F':' '{print $1}')
  revision=$(echo $arn | awk -F':' '{print $2}')
  aws ecs describe-task-definition --task-definition $arn --query 'taskDefinition' --output json > "task_definitions/${family}-${revision}.json"
done

echo "Saved task definitions:"
ls -1 task_definitions/

#print content of each fetched task definition
for file in task_definitions/*.json; do
  echo "Content of $file:"
  cat "$file"
done
