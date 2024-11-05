
data "aws_ami" "almalinux" {

 filter {
   name = "name"
   values = ["al2023-ami-2023.6.20241*"]
 }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 most_recent = true
 owners = ["amazon"]
}



data "aws_ami" "ubuntu" {

 filter {
   name = "name"
   values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
 }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 most_recent = true
 owners = ["amazon"]
}
