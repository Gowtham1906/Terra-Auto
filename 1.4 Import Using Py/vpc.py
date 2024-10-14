import subprocess

def terraform_init():
    """Runs terraform init command to initialize the working directory."""
    try:
        subprocess.run(["terraform", "init"], check=True)
        print("Terraform initialized successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error during terraform init: {e}")

def terraform_import(resource, resource_id):
    """Runs terraform import command to import an existing resource."""
    try:
        subprocess.run(["terraform", "import", resource, resource_id], check=True)
        print(f"Successfully imported {resource} with ID {resource_id}.")
    except subprocess.CalledProcessError as e:
        print(f"Error during terraform import: {e}")

if __name__ == "__main__":

    terraform_init()

    vpc_list = [
        {"resource": "aws_vpc.my_vpc_1", "vpc_id": "vpc-0408de3b6d3e92705"},  
        {"resource": "aws_vpc.my_vpc_2", "vpc_id": "vpc-0214440731046e006"},
    ]

    for vpc in vpc_list:
        resource_name = vpc["resource"]
        vpc_id = vpc["vpc_id"]
        terraform_import(resource_name, vpc_id)
