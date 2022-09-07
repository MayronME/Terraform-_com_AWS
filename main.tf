# Configure the AWS Provider
provider "aws" {
  alias   = "us-east-1" # para definir qual a area 
  region  = "us-east-1"
}

provider "aws" {
  alias   = "us-east-2" # para definir qual a area 
  region  = "us-east-2"
}


# 3 maquinas DEV
resource "aws_instance" "dev" {
  provider = aws.us-east-1
  count         = 3
  ami           = var.amis["us-east-1"] # nome na aws que define o tipo de maquina
  instance_type = "t2.micro"              # tipo de maquina
  key_name      = var.key_name         # 
  tags = {
    Name = "dev"
    Name = "dev${count.index}"
  }
  vpc_security_group_ids = [              # referência para o securit group
    aws_default_security_group.ssh-us-east-1.id
  ]
}

#Maquina linkada com o S3 dev4
resource "aws_instance" "dev4" {
  provider = aws.us-east-1
  ami           = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name      = var.key_name
  tags = {
    Name = "dev"
    Name = "dev4"
  }
  vpc_security_group_ids = [
    aws_default_security_group.ssh-us-east-1.id
  ]
  depends_on = [
    aws_s3_bucket.dev4
  ]
}

# Maquina contecnada ao dynamodb
resource "aws_instance" "dev6" {
  provider = aws.us-east-2
  ami           = var.amis["us-east-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name
  tags = {
    Name = "dev"
    Name = "dev6"
  }
  vpc_security_group_ids = [
    aws_default_security_group.ssh-us-east-2.id
  ]
  depends_on = [
    aws_dynamodb_table.dynamodb-homologacao
  ]
}

#S3
resource "aws_s3_bucket" "dev4" {
  bucket        = "rmerceslabs-m-dev4" 
  tags = {
    Name        = "rmerceslabs-m-dev4"
    Environment = "Dev4"
  }
}

resource "aws_s3_bucket_acl" "dev4_ref" {
  bucket = aws_s3_bucket.dev4.id
  acl    = "private"
}

resource "aws_dynamodb_table" "dynamodb-homologacao" {
  provider = aws.us-east-2
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

}

# para excluir apenas um recursos 
# terraform destroy -taget aws_instance.dev4