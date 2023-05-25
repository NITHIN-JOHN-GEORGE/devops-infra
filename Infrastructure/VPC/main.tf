

data "aws_caller_identity" "current" {}



#----------vpc code block------------------------------

resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    ManagedBy = "terraform"
    Name      = "${var.vpc_name}-vpc"
  "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned" })

}

#----------------Public subnet--------------------------------------

resource "aws_subnet" "public" {
  vpc_id                  = element(aws_vpc.vpc.*.id, count.index)
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    ManagedBy                                       = "terraform"
    subnets                                         = "public"
    Name                                            = "${var.vpc_name}-${element(var.availability_zones, count.index)}-public${count.index + 1}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "kubernetes.io/role/elb" = 1 }, var.public_subnet_tags)

  depends_on = [aws_vpc.vpc]
}

#------internet-gateway | will be used by the public subnets-----------------------

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    MangedBy = "terraform"
    Name     = "${var.vpc_name}-igw"
  }
  depends_on = [aws_subnet.public]
}

#---------------Public subnets route table------------------------------------------

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.vpc.id


  tags = {
    MangedBy    = "terraform"
    Name        = "${var.vpc_name}-public-route-table"

  }
  depends_on = [aws_internet_gateway.ig]
}



resource "aws_route" "default_public_internet_gateway_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = ["0.0.0.0/0"]
  gateway_id             = aws_internet_gateway.ig.id
  depends_on             = [aws_route_table.public]
}

#---------------Associate the public route table to public subnets---------------------------------------

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_route.default_public_internet_gateway_route]
}

#---------Private subnets--------------------------------------------

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge({
    MangedBy                                        = "terraform"
    subnets                                         = "private"
    Name                                            = "${var.vpc_name}-${element(var.availability_zones, count.index)}-private${count.index + 1}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"               = 1
  }, var.private_subnet_tags)

  depends_on = [aws_vpc.vpc]
}

#-----elastic ip for the nat gateway | nat static ip-----------------------------------------

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags       = {
    MangedBy = "terraform"
    Name     = "${var.vpc_name}-nat_eip"
  }
}



#----------------Nat gateway for the private subnets----------------------------------------------

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    MangedBy = "terraform"
    Name     = "${var.vpc_name}-nat"
  }
}



#--------------Private subnets route table-----------------------------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id


  tags = {
    MangedBy    = "terraform"
    Name        = "${var.vpc_name}-private-route-table"
  }
}



resource "aws_route" "default_route_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = ["0.0.0.0/0"]
  nat_gateway_id         = aws_nat_gateway.nat.id
}


#-------------Associate the private route table to private subnets-------------------

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}




