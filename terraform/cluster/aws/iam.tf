data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_eks" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_efs" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = local.oidc_sub
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster" {
  assume_role_policy = data.aws_iam_policy_document.assume_eks.json
  name               = "${var.name}-cluster"
  path               = "/convox/"
}

resource "aws_iam_role_policy_attachment" "cluster_eks_cluster" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_eks_service" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_ec2_readonly" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role" "efs_role" {
  name = "${var.name}-efs"
  assume_role_policy = data.aws_iam_policy_document.assume_efs.json
}

resource "aws_iam_policy" "efs_management_policy" {
  name        = "${var.name}-efs-management"
  description = "EFS Management Policy for Convox"

  policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = ["elasticfilesystem:DescribeAccessPoints","elasticfilesystem:DescribeFileSystems"]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = ["elasticfilesystem:CreateAccessPoint"]
          Resource = "*"
          Condition = {
            StringLike = { "aws:RequestTag/efs.csi.aws.com/cluster" = "true" }
          }
        },
        {
          Effect = "Allow"
          Action = "elasticfilesystem:DeleteAccessPoint"
          Resource = "*"
          Condition = {
            StringEquals = { "aws:ResourceTag/efs.csi.aws.com/cluster" = "true" }
          }
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "efs_management" {
  role       = "${aws_iam_role.efs_role.name}"
  policy_arn = "${aws_iam_policy.efs_management_policy.arn}"
}

resource "aws_iam_role" "nodes" {
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
  name               = "${var.name}-nodes"
  path               = "/convox/"
}

resource "aws_iam_role_policy_attachment" "nodes_ecr" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "nodes_eks_cni" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "nodes_eks_worker" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "null_resource" "iam" {
  depends_on = [
    aws_iam_role_policy_attachment.cluster_ec2_readonly,
    aws_iam_role_policy_attachment.cluster_eks_cluster,
    aws_iam_role_policy_attachment.cluster_eks_service,
    aws_iam_role_policy_attachment.nodes_ecr,
    aws_iam_role_policy_attachment.nodes_eks_cni,
    aws_iam_role_policy_attachment.nodes_eks_worker,
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 300"
  }
}
