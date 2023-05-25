
variable "region" {
  type = string
  description = "please enter a valid region for vpc launching"
}

variable "vpc_cidr" {
  type        = string
  description = "please enter a valid cidr range for your vpc in string eg: 10.1.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "please enter a vpc_name for your new vpc"
}

variable "vpc_tags" {
  type = map(string)
  description = "please enter a custom tag for your vpc in a key value pair"
}

variable "eks_cluster_name" {
  type        = string
  description = "Assume your eks cluster name and enter here, this is used under your vpc tags"
}

variable "public_subnets_cidr" {
  type = list(string)
  description = "please enter your public subnet's cidr's in a list of string. note => if you want 3 public subnets you can enter 3 cidrs ranges for that"
}

variable "public_subnet_tags" {
  type = map(string)
  description = "please enter a custom tag for your public_subnet_tags in a key value pair"
}

variable "availability_zones" {
  type = list(string)
  description = "please enter your availability_zones for your subnets in a  list of string note => if you want 3 subnets in 3 differnt zone plaese enter 3 zones. You can follow single avilablility zone or multi availability zone method as your wish"
}

variable "private_subnets_cidr" {
  type = list(string)
  description = "please enter your private subnet's cidr's in a list of string note => if you want 3 private subnets you can enter 3 cidrs ranges for that"
}

variable "private_subnet_tags" {
  type = map(string)
  description = "please enter a custom tag for your private_subnet in a key value pair "
}


variable "AWS_SECRET_KEY" {
 description = "to run terraform code in workspace please enter your AWS_SECRET_KEY"
}

variable "AWS_ACCESS_KEY" {
 description = "to run terraform code in workspace please enter your AWS_ACCESS_KEY"
}