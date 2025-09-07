output "vpc_id" {
  value = aws_vpc.ruby_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.ruby_vpc.cidr_block
}

output "vpc_public_subnets" {
  # Result is a map of subnet id to cidr block, e.g.
  # {"subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.web :
    #subnet.id => subnet.cidr_block
    subnet.id => subnet.tags_all
  }
}

output "vpc_private_subnets" {
  value = {
    for subnet in aws_subnet.app :
    #subnet.id => subnet.cidr_block
    subnet.id => subnet.tags_all
  }
}

output "vpc_db_subnets" {
  value = {
    for subnet in aws_subnet.db :
    #subnet.id => subnet.cidr_block
    subnet.id => subnet.tags_all
  }
}

output "security_groups_created" {
  value = {
    for sg in aws_security_group.security_groups :
    sg.id => sg.name
  }
}

output "internal_lb_sg_id" {
  value = aws_security_group.security_groups["int-alb-SG"].id
}

output "external_lb_sg_id" {
  value = aws_security_group.security_groups["ext-alb-SG"].id
}

output "app_sg_id" {
  value = aws_security_group.security_groups["app-SG"].id
}

output "web_sg_id" {
  value = aws_security_group.security_groups["web-SG"].id
}

output "db_sg_id" {
  value = aws_security_group.security_groups["db-SG"].id
}
