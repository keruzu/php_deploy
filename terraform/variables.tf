
variable "ami_id" {
  type = string
  default = "ami-00385a401487aefa4"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "external_access"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "database_name" {
  type    = string
  default = "example_db"
}

variable "username" {
  type    = string
  default = "app_user"
}

variable "password" {
  type    = string
  default = "s3kr3ts3kr3ts3kr3t"
}
