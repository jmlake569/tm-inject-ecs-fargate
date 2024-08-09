provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Run the script to fetch and save task definitions
resource "null_resource" "fetch_task_definitions" {
  provisioner "local-exec" {
    command = "./scripts/fetch_task_definitions.sh"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Run the script to patch task definitions
resource "null_resource" "patch_task_definitions" {
  provisioner "local-exec" {
    command = "./scripts/patch_task_definitions.sh"
  }

  depends_on = [null_resource.fetch_task_definitions]
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Run the script to register patched task definitions
resource "null_resource" "register_task_definitions" {
  provisioner "local-exec" {
    command = "./scripts/register_task_definitions.sh"
  }

  depends_on = [null_resource.patch_task_definitions]
  triggers = {
    always_run = "${timestamp()}"
  }