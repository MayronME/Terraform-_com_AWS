resource "aws_default_security_group" "ssh-us-east-1" {
    provider = aws.us-east-1                # referência para o provider
    vpc_id = "vpc-00acc95229636e4d5"
    ingress {
        self      = true
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks =  var.cdirs_acesso_remoto
    }
    tags = {
        "Name" = "ssh"
    }
}

resource "aws_default_security_group" "ssh-us-east-2" {
    provider = aws.us-east-2
    vpc_id = "vpc-02b7be1cb00567bdb"        # VPC padrão
    ingress {
        self      = true
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks = var.cdirs_acesso_remoto
    }
  tags = {
    "Name" = "ssh-us-east-2"
  }
}