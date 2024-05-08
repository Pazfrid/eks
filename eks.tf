resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name     = "eks_cluster_demo"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
    # security_group_ids = [aws_security_group.custom_tcp_8080_2.id]
  }

  tags = {
    Name = "EKS_demo"
  }
}

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "node_demo"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = module.vpc.public_subnets
  instance_types  = ["t3.small"]
  # remote_access {
  #   ec2_ssh_key = "TEST"
  #   source_security_group_ids = [aws_security_group.custom_tcp.id] 
  # }
  

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


# resource "aws_security_group" "custom_tcp" {
#   name        = "custom_tcp"
#   description = "Allow custom_tcp inbound traffic and all outbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   tags = {
#     Name = "custom_tcp"
#   }
# }


# resource "aws_security_group_rule" "custom_tcp_8080" {
#   type              = "ingress"
#   from_port         = "8080"
#   to_port           = "8080"
#   protocol          = "tcp"
#   cidr_blocks       = ["94.188.186.6/32"]  # or specify your specific CIDR range
#   security_group_id = data.aws_autoscaling_group.sg_name.id

# }


# data "aws_autoscaling_group" "sg_name" {
#   name = aws_eks_node_group.node.resources[0].autoscaling_groups[0].name
#   }

# data "aws_security_group" "selected" {
#   vpc_id = module.vpc.vpc_id

#   filter {
#     name   = "group-name"
#     values = [data.aws_autoscaling_group.sg_name.id]
#   }
# }


resource "aws_security_group" "custom_tcp_8080_2" {
  name   = "node group security group"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "custome access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["94.188.186.6/32"] 
  }
  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS-security-group"
  }
}