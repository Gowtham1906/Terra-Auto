import boto3
import subprocess

def get_vpcs():
    """Fetch all VPCs from all regions."""
    vpc_list = []
    ec2 = boto3.client('ec2')

    # Get all regions
    regions = ec2.describe_regions()['Regions']
    
    for region in regions:
        region_name = region['RegionName']
        print(f"Checking region: {region_name}")

        # Create an EC2 client for the current region
        regional_ec2 = boto3.client('ec2', region_name=region_name)
        
        # Describe VPCs in the current region
        vpcs = regional_ec2.describe_vpcs()['Vpcs']
        
        for vpc in vpcs:
            vpc_id = vpc['VpcId']
            if region_name == "us-east-1":
                # Use correct resource name for us-east-1
                resource_name = "aws_vpc.my_vpc_1"
            elif region_name == "us-east-2":
                # Use correct resource name for us-east-2
                resource_name = "aws_vpc.my_vpc_2"
            else:
                continue 
            
            vpc_list.append({"resource": resource_name, "vpc_id": vpc_id, "region": region_name})
            print(f"Found VPC: {vpc_id} in region: {region_name}")

    return vpc_list

def terraform_init():
    """Initialize Terraform."""
    try:
        subprocess.run(["terraform", "init"], check=True)
        print("Terraform initialized successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error during terraform init: {e}")

def is_resource_managed(resource):
    """Check if the resource is already managed by Terraform."""
    try:
        result = subprocess.run(["terraform", "state", "list"], capture_output=True, text=True, check=True)
        if resource in result.stdout.splitlines():
            return True
    except subprocess.CalledProcessError as e:
        print(f"Error during terraform state list: {e}")
    return False

def terraform_import(resource, resource_id):
    """Run terraform import command to import an existing resource."""
    if is_resource_managed(resource):
        print(f"Resource {resource} is already managed by Terraform")
        return

    try:
        subprocess.run(["terraform", "import", resource, resource_id], check=True)
        print(f"Successfully imported {resource} with ID {resource_id}.")
    except subprocess.CalledProcessError as e:
        print(f"Error during terraform import: {e}")

if __name__ == "__main__":
    # Initialize Terraform
    terraform_init()

    # Get the list of VPCs
    vpc_list = get_vpcs()

    # Loop through the VPC list and import each one
    for vpc in vpc_list:
        resource_name = vpc["resource"]
        vpc_id = vpc["vpc_id"]
        terraform_import(resource_name, vpc_id)
