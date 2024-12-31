provider "aws" {
  region  = "us-east-1"
  profile = "thej"
}


# Networking Module
module "networking" {
  source            = "./modules/networking"
  cidr_block        = "10.10.10.0/24"
  public_subnet     = "10.10.10.0/26"
  availability_zone = "us-east-1a"
}



# Security Group Module
module "security_group" {
  source        = "./modules/security-group"
  vpc_id        = module.networking.vpc_id
  ingress_ports = [22, 8080] # SSH and Jenkins
}

# EC2 Jenkins Module
module "ec2_jenkins" {
  source            = "./modules/ec2-jenkins"
  instance_type     = "t2.micro"
  ami_id            = "ami-0c02fb55956c7d316" # Amazon Linux 2
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = "abc" # this key need to available in local machine (download before this tf excute from aws console )
}
