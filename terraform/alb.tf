module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name               = "my-alb"
  load_balancer_type = "application"
  internal           = false

  vpc_id  = module.eks-vpc.vpc_id
  subnets = module.eks-vpc.public_subnets

  security_groups = [aws_security_group.alb_sg.id]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "tg1"
      }
    }
  }

  target_groups = {
    tg1 = {
      name_prefix      = "tg1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      vpc_id           = module.eks-vpc.vpc_id
    }
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.eks-vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group_attachment" "eks_node_attachment" {
  for_each = { for id in data.aws_instances.eks_nodes.ids : id => id }

  target_group_arn = module.alb.target_groups["tg1"].arn
  target_id        = each.value
  port             = 80
}


data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:aws:eks:nodegroup-name"
    values = ["eks-nodegroup"]
  }
}
