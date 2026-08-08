# vpc

Provisions a VPC with public and private subnets across the AZs you specify, an internet gateway for the public subnets, and an optional NAT gateway for outbound access from private subnets.

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name                 = "app"
  cidr_block           = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| name | Name prefix for resources | string | n/a |
| cidr_block | VPC CIDR block | string | `10.0.0.0/16` |
| azs | Availability zones | list(string) | n/a |
| public_subnet_cidrs | Public subnet CIDRs | list(string) | `[]` |
| private_subnet_cidrs | Private subnet CIDRs | list(string) | `[]` |
| enable_nat_gateway | Provision NAT gateway(s) | bool | `false` |
| single_nat_gateway | Share one NAT gateway across AZs instead of one each | bool | `true` |
| tags | Tags applied to all resources | map(string) | `{}` |

## Outputs

| Name | Description |
|---|---|
| vpc_id | ID of the VPC |
| vpc_cidr_block | CIDR block of the VPC |
| public_subnet_ids | IDs of public subnets |
| private_subnet_ids | IDs of private subnets |
| nat_gateway_ids | IDs of NAT gateways, if any |

## Notes

NAT gateways bill hourly plus data processing charges. Leave `enable_nat_gateway` off for environments that don't need outbound access from private subnets, such as short-lived demo or test stacks.
