import os
import subprocess
import boto3
import json

def get_module_path():
    return os.path.dirname(os.path.abspath(__file__))

def run_terraform_command(command, cwd):
    try:
        result = subprocess.run(command, cwd=cwd, check=True, capture_output=True, text=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error executing Terraform command: {e}")
        print(f"Stderr: {e.stderr}")
        raise

def create_vpc_resources(module_path):
    print("Creating new VPC and associated resources...")
    run_terraform_command(["terraform", "init"], module_path)
    run_terraform_command(["terraform", "apply", "-auto-approve"], module_path)
    print("New VPC and associated resources created successfully.")

def import_existing_vpc(module_path, vpc_id):
    print(f"Importing existing VPC {vpc_id}...")
    import_command = ["terraform", "import", f"aws_vpc.imported_vpc", vpc_id]
    run_terraform_command(import_command, module_path)
    print(f"Existing VPC {vpc_id} imported successfully.")

def list_existing_vpcs():
    ec2 = boto3.client('ec2')
    response = ec2.describe_vpcs()
    vpcs = response['Vpcs']
    
    print("\nExisting VPCs:")
    for i, vpc in enumerate(vpcs, 1):
        vpc_id = vpc['VpcId']
        cidr_block = vpc['CidrBlock']
        tags = vpc.get('Tags', [])
        tag_str = ', '.join([f"{tag['Key']}:{tag['Value']}" for tag in tags])
        print(f"{i}. VPC ID: {vpc_id}, CIDR: {cidr_block}, Tags: {tag_str}")
    
    return vpcs

def get_existing_vpc_info():
    vpcs = list_existing_vpcs()
    
    while True:
        try:
            choice = int(input("\nEnter the number of the VPC you want to import: ")) - 1
            if 0 <= choice < len(vpcs):
                selected_vpc = vpcs[choice]
                vpc_id = selected_vpc['VpcId']
                cidr_block = selected_vpc['CidrBlock']
                tags = {tag['Key']: tag['Value'] for tag in selected_vpc.get('Tags', [])}
                return vpc_id, cidr_block, tags
            else:
                print("Invalid selection. Please try again.")
        except ValueError:
            print("Please enter a valid number.")

def update_terraform_config(module_path, vpc_id, cidr_block, tags):
    config_path = os.path.join(module_path, "import.tf")
    with open(config_path, "w") as f:  # Using "w" to overwrite the file if it exists
        f.write(f"""
resource "aws_vpc" "imported_vpc" {{
  cidr_block = "{cidr_block}"
  tags = {json.dumps(tags, indent=2)}
}}
""")
    print(f"Created/Updated import.tf with imported VPC {vpc_id} configuration")

if __name__ == "__main__":
    module_path = get_module_path()
    
    # Initialize Terraform
    #run_terraform_command(["terraform", "init"], module_path)

    # Create new VPC and resources
    create_vpc_resources(module_path)

    # Get existing VPC information
    vpc_id, cidr_block, tags = get_existing_vpc_info()

    # Update Terraform configuration for the imported VPC
    update_terraform_config(module_path, vpc_id, cidr_block, tags)

    # Import existing VPC
    import_existing_vpc(module_path, vpc_id)

    # Apply changes to sync state
    run_terraform_command(["terraform", "plan"], module_path)
    run_terraform_command(["terraform", "apply", "-auto-approve"], module_path)

    print("VPC creation and import process completed successfully.")