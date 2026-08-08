# ec2-instance

Provisions a single EC2 instance with an encrypted root volume, IMDSv2 enforced, and a sane default AMI (latest Ubuntu 22.04) if you don't want to pin one yourself.

## Usage

```hcl
module "app_server" {
  source = "../../modules/ec2-instance"

  name                 = "app-server"
  instance_type        = "t3.micro"
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_ids   = [module.web_sg.security_group_id]
  associate_public_ip  = true
  key_name             = "my-keypair"
  user_data            = file("${path.module}/user_data.sh")

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| name | Name tag for the instance | string | n/a |
| ami_id | AMI ID, defaults to latest Ubuntu 22.04 | string | `null` |
| instance_type | Instance type | string | `t3.micro` |
| subnet_id | Subnet to launch into | string | n/a |
| security_group_ids | Security group IDs | list(string) | n/a |
| key_name | SSH key pair name | string | `null` |
| associate_public_ip | Assign a public IP | bool | `false` |
| user_data | Boot script | string | `null` |
| root_volume_size | Root volume size in GB | number | `20` |
| root_volume_type | Root volume type | string | `gp3` |
| tags | Tags applied to the instance | map(string) | `{}` |

## Outputs

| Name | Description |
|---|---|
| instance_id | ID of the instance |
| public_ip | Public IP, if assigned |
| private_ip | Private IP |

## Security defaults

Root volume is encrypted and IMDSv2 (`http_tokens = required`) is enforced, closing off the metadata-service SSRF path that IMDSv1 leaves open.
