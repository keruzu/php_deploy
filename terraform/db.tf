

resource "aws_instance" "db" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subneta.id
  vpc_security_group_ids = [aws_security_group.db_ports.id]
  iam_instance_profile = aws_iam_instance_profile.db-ec2-profile.name

  tags = {
    Name = "db"
  }

   user_data = <<-EOL
  #!/bin/bash -xe

  sudo apt-get update
  sudo apt-get install -y mysql-server git zip unzip libpng-dev libzip-dev default-mysql-client sudo iputils-ping net-tools
  sudo sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
  sudo systemctl restart mysql
  sudo mysql -u root --execute "CREATE USER IF NOT EXISTS 'app_user' IDENTIFIED BY 's3kr3ts3kr3ts3kr3t';create database if not exists example_db;GRANT ALL ON example_db.* TO 'app_user'; "
  EOL
}

resource "aws_iam_instance_profile" "db-ec2-profile" {
  name = "db-ec2-profile"
  role = aws_iam_role.codedeploy-role.name
}

resource "aws_security_group" "db_ports" {
  name        = "db_ports"
  description = "Allow database traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "db_ports"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql_ports" {
  security_group_id = aws_security_group.db_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}


resource "aws_vpc_security_group_ingress_rule" "db-ssh" {
  security_group_id = aws_security_group.db_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "db_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.db_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

