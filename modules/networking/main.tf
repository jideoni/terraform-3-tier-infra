resource "aws_vpc" "ruby_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.infra_env}-vpc"
    Environment = var.infra_env
  }
}

resource "aws_flow_log" "ruby_vpc_flow_logs" {
  #reference s3 bucket for logs created in s3 module
  log_destination      = var.bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.ruby_vpc.id
}

#create an internet gateway
resource "aws_internet_gateway" "ruby_igw" {
  vpc_id = aws_vpc.ruby_vpc.id

  tags = {
    Name        = "${var.infra_env}-igw"
    Environment = var.infra_env
  }
}

#create eip for NAT GW
resource "aws_eip" "web_eips" {
  for_each = var.web_eips_name

  domain = "vpc"

  tags = {
    Name = each.key
  }
}

#create nat gateway 1
resource "aws_nat_gateway" "ruby_nat_gw_1" {
  subnet_id = aws_subnet.web["ca-central-1a"].id

  allocation_id = aws_eip.web_eips["web-eip-1"].id

  tags = {
    Name        = "${var.infra_env}-NAT-gw-1"
    Environment = var.infra_env
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ruby_igw]
}

#create nat gateway 2
resource "aws_nat_gateway" "ruby_nat_gw_2" {
  subnet_id = aws_subnet.web["ca-central-1b"].id

  allocation_id = aws_eip.web_eips["web-eip-2"].id

  tags = {
    Name        = "${var.infra_env}-NAT-gw-2"
    Environment = var.infra_env
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ruby_igw]
}

#create nat gateway 3
resource "aws_nat_gateway" "ruby_nat_gw_3" {
  subnet_id = aws_subnet.web["ca-central-1d"].id

  allocation_id = aws_eip.web_eips["web-eip-3"].id

  tags = {
    Name        = "${var.infra_env}-NAT-gw-3"
    Environment = var.infra_env
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ruby_igw]
}

#create web subnets
resource "aws_subnet" "web" {
  for_each = var.web_subnet_number

  vpc_id = aws_vpc.ruby_vpc.id

  #cidr_block - cidrsubnet(prefix, newbits, netnum)
  #newbits is the number of additional bits with which to extend the prefix. For example,
  #if given a prefix ending in /16 and a newbits value of 4,
  #the resulting subnet address will have length /20.
  cidr_block              = cidrsubnet(aws_vpc.ruby_vpc.cidr_block, 4, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.infra_env}-web-subnet-${each.key}"
    Role        = "public"
    Environment = var.infra_env
    #Subnet      = "${each.key}-${each.value}"
  }
}

#create app subnets
resource "aws_subnet" "app" {
  for_each = var.app_subnet_number

  vpc_id = aws_vpc.ruby_vpc.id

  #cidr_block - cidrsubnet(prefix, newbits, netnum)
  #newbits is the number of additional bits with which to extend the prefix. For example,
  #if given a prefix ending in /17 and a newbits value of 4,
  #the resulting subnet address will have length /21.
  cidr_block        = cidrsubnet(aws_vpc.ruby_vpc.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    Name        = "${var.infra_env}-app-subnet-${each.key}"
    Role        = "private"
    Environment = var.infra_env
    #Subnet      = "${each.key}-${each.value}"
  }
}

#create db subnets
resource "aws_subnet" "db" {
  for_each = var.db_subnet_number

  vpc_id = aws_vpc.ruby_vpc.id

  #cidr_block - cidrsubnet(prefix, newbits, netnum)
  #newbits is the number of additional bits with which to extend the prefix. For example,
  #if given a prefix ending in /17 and a newbits value of 4,
  #the resulting subnet address will have length /21.
  cidr_block        = cidrsubnet(aws_vpc.ruby_vpc.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    Name        = "${var.infra_env}-db-subnet-${each.key}"
    Role        = "private"
    Environment = var.infra_env
    #Subnet      = "${each.key}-${each.value}"
  }
}

/*###using count
resource "aws_subnet" "private" {
  count = length(var.private_subnet_number)

  vpc_id = aws_vpc.vpc.id

  #cidr_block - cidrsubnet(prefix, newbits, netnum)
  #newbits is the number of additional bits with which to extend the prefix. For example,
  #if given a prefix ending in /16 and a newbits value of 4,
  #the resulting subnet address will have length /20.
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)

  tags = {
    Name        = "${var.infra_env}-private-subnet-${count.index}"
    Role        = "private"
    Environment = var.infra_env
    #Subnet      = "${each.key}-${each.value}"
  }
}*/

#create web route table
resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.ruby_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ruby_igw.id
  }

  tags = {
    Name = var.web_route_table
  }
}

#associate web subnets with web rt
resource "aws_route_table_association" "web_subnet_association" {
  for_each = aws_subnet.web

  subnet_id      = each.value.id
  route_table_id = aws_route_table.web_rt.id
}

#create app route table 1
resource "aws_route_table" "app_rt_1" {
  vpc_id = aws_vpc.ruby_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ruby_nat_gw_1.id #change this to NAT gateway
  }

  tags = {
    Name        = "app tier route table-${var.app_route_table["app-rt-1"]}"
    Environment = var.infra_env
  }
}

/*#associate app subnets with app rt 1
resource "aws_route_table_association" "app_subnet_association_1" {
  for_each = aws_subnet.app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.app_rt_1.id
}*/

#associate app subnets with app rt 1
resource "aws_route_table_association" "app_subnet_association_1" {
  subnet_id      = aws_subnet.app["ca-central-1a"].id
  route_table_id = aws_route_table.app_rt_1.id
}

#create app route table 2
resource "aws_route_table" "app_rt_2" {
  vpc_id = aws_vpc.ruby_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ruby_nat_gw_2.id #change this to NAT gateway
  }

  tags = {
    Name        = "app tier route table-${var.app_route_table["app-rt-2"]}"
    Environment = var.infra_env
  }
}

#associate app subnets with app rt 1
resource "aws_route_table_association" "app_subnet_association_2" {
  subnet_id      = aws_subnet.app["ca-central-1b"].id
  route_table_id = aws_route_table.app_rt_2.id
}

#create app route table 3
resource "aws_route_table" "app_rt_3" {
  vpc_id = aws_vpc.ruby_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ruby_nat_gw_3.id #change this to NAT gateway
  }

  tags = {
    Name        = "app tier route table-${var.app_route_table["app-rt-3"]}"
    Environment = var.infra_env
  }
}

#associate app subnets with app rt 1
resource "aws_route_table_association" "app_subnet_association_3" {
  subnet_id      = aws_subnet.app["ca-central-1d"].id
  route_table_id = aws_route_table.app_rt_3.id
}

#create 5 security groups
resource "aws_security_group" "security_groups" {
  for_each    = var.security_groups
  vpc_id      = aws_vpc.ruby_vpc.id
  name        = "ruby-${each.key}"
  description = each.value

  tags = {
    Name = "ruby-${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ext-alb-SG-rule" {
  security_group_id = aws_security_group.security_groups["ext-alb-SG"].id
  cidr_ipv4         = var.internet
  from_port         = 80
  ip_protocol       = var.tcp
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "ext-alb-SG-rule-ping" {
  security_group_id = aws_security_group.security_groups["ext-alb-SG"].id
  cidr_ipv4         = var.internet
  from_port         = 8 #Echo Request
  ip_protocol       = var.icmp
  to_port           = 0
}

resource "aws_vpc_security_group_ingress_rule" "web-SG-rule" {
  security_group_id            = aws_security_group.security_groups["web-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["ext-alb-SG"].id # allow traffic from external ALB security group only
  from_port                    = 80
  ip_protocol                  = var.tcp
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "web-SG-rule-ping" {
  security_group_id            = aws_security_group.security_groups["web-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["ext-alb-SG"].id # allow traffic from external ALB security group only
  from_port                    = 8                                                   #Echo Request
  ip_protocol                  = var.icmp
  to_port                      = 0
}

resource "aws_vpc_security_group_ingress_rule" "int-alb-SG-rule" {
  security_group_id            = aws_security_group.security_groups["int-alb-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["web-SG"].id # allow traffic from external ALB security group only
  from_port                    = 80
  ip_protocol                  = var.tcp
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "int-alb-SG-rule-ping" {
  security_group_id            = aws_security_group.security_groups["int-alb-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["web-SG"].id # allow traffic from external ALB security group only
  from_port                    = 8
  ip_protocol                  = var.icmp
  to_port                      = 0
}

resource "aws_vpc_security_group_ingress_rule" "app-SG-rule" {
  security_group_id            = aws_security_group.security_groups["app-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["int-alb-SG"].id # allow traffic from external ALB security group only
  from_port                    = 4000                                                #react
  ip_protocol                  = var.tcp
  to_port                      = 4000
}
resource "aws_vpc_security_group_ingress_rule" "app-SG-rule-ping" {
  security_group_id            = aws_security_group.security_groups["app-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["int-alb-SG"].id # allow traffic from external ALB security group only
  from_port                    = 8                                                   #Echo Request
  ip_protocol                  = var.icmp
  to_port                      = 0
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  for_each = var.security_groups

  security_group_id = aws_security_group.security_groups[each.key].id
  cidr_ipv4         = var.internet
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "db-SG-rule" {
  security_group_id            = aws_security_group.security_groups["db-SG"].id
  referenced_security_group_id = aws_security_group.security_groups["app-SG"].id # allow traffic from external ALB security group only
  from_port                    = 3306                                            #mysql
  ip_protocol                  = var.tcp
  to_port                      = 3306
}
