
#resource "aws_security_group" "example_sg" {
#  name_prefix = "${var.tags}-pl-sg-tf"
# vpc_id      = aws_vpc.this_vpc.id
#dynamic "ingress" {
# for_each = [22, 80, 8080, 443]
#iterator = port
#content {
# from_port   = port.value
# to_port     = port.value
# protocol    = "tcp"
# cidr_blocks = ["0.0.0.0/0"]
# }
# }
# egress {
#  from_port   = 0
# to_port     = 0
#protocol    = "-1"
# cidr_blocks = ["0.0.0.0/0"]
#  }
# tags = {
#  Name = "${var.tags}-pl-sg-tf"
# }
#}
