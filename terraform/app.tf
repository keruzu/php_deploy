

resource "aws_network_interface" "home-net" {
  subnet_id   = aws_subnet.public_subneta.id

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "app" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subneta.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  iam_instance_profile = aws_iam_instance_profile.app-ec2-profile.name

  tags = {
    Name = "app"
  }

  depends_on = [ aws_instance.db ]

   user_data = <<-EOL
  #!/bin/bash -xe

  sudo apt-get update
  sudo apt-get install -y git zip unzip libpng-dev libzip-dev default-mysql-client sudo iputils-ping net-tools ruby-full
  sudo add-apt-repository -y ppa:ondrej/php 
  sudo apt-get update
  sudo sudo apt install -y php8.3 php8.3-cli php8.3-{bz2,curl,mbstring,intl,mysqli}
  sudo systemctl stop apache2
  sudo useradd -c "PHP application user" --user-group php-app
  sudo mkdir -p /var/www/public
  wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
  chmod +x ./install
  sudo ./install auto
  sudo cat <<-CONFIG >> /var/www/config.txt
  hostname=${aws_instance.db.private_ip}
  username=app_user
  password=s3kr3ts3kr3ts3kr3t
  dbname=example_db
  CONFIG
  EOL
}

resource "aws_iam_instance_profile" "app-ec2-profile" {
  name = "app-ec2-profile"
  role = aws_iam_role.codedeploy-role.name
}



resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

