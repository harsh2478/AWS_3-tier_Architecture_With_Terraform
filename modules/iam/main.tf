resource "aws_iam_role" "ec2-role" {
  name = "${var.environment}-${var.project}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-ec2-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "secret_manager" {
    name = "${var.environment}-${var.project}-secrets-manager-policy"
    description = "Allow EC2 instance to read secrets from secret manager"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "Secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]
                Resource = var.secret_arns
            }
        ]
    }) 
}

resource "aws_iam_role_policy_attachment" "secret_manager" {
  role = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.secret_manager.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.environment}-${var.project}-ec2-intance-profile"
    role = aws_iam_role.ec2-role.name

    tags = merge(
        var.tags,
        {
            Name = "${var.environment}-${var.project}-ec2-intance-profile"
        }
    )  
}