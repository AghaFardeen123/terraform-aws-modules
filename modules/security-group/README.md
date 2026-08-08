# security-group

Creates a security group with a list of ingress and egress rules passed in as plain objects, instead of hand-writing repeated `ingress {}` blocks.

## Usage

```hcl
module "web_sg" {
  source = "../../modules/security-group"

  name        = "web"
  description = "Allow HTTP/HTTPS from anywhere, SSH from admin CIDR"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.4/32"]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| name | Security group name | string | n/a |
| description | Security group description | string | `Managed by Terraform.` |
| vpc_id | VPC to attach the group to | string | n/a |
| ingress_rules | List of inbound rules | list(object) | `[]` |
| egress_rules | List of outbound rules | list(object) | allow all outbound |
| tags | Tags applied to the group | map(string) | `{}` |

## Outputs

| Name | Description |
|---|---|
| security_group_id | ID of the created security group |
| security_group_arn | ARN of the created security group |
