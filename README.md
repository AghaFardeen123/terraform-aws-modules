# terraform-aws-modules

A small library of reusable, versioned Terraform modules for common AWS building blocks, plus a complete working example that wires them together and a CI pipeline that validates, lints, and security-scans every module on every push.

## Why this exists

Most Terraform work on real projects isn't writing a VPC from scratch every time, it's assembling the same handful of building blocks (network, security group, compute, storage) with slightly different inputs per environment. These modules are built to be dropped into a project and configured through variables rather than copy-pasted and edited by hand.

## Modules

| Module | Description |
|---|---|
| [`modules/vpc`](modules/vpc) | VPC with public/private subnets across AZs, optional NAT gateway |
| [`modules/security-group`](modules/security-group) | Security group driven by a list of rule objects |
| [`modules/ec2-instance`](modules/ec2-instance) | EC2 instance with encrypted root volume and IMDSv2 enforced |
| [`modules/s3-bucket`](modules/s3-bucket) | S3 bucket with versioning, encryption, and public access blocked by default |

Each module has its own README with full input/output documentation and a usage example.

## Example

[`examples/complete`](examples/complete) wires all four modules together into a small working stack: a VPC with one public subnet, a security group, an EC2 instance running Nginx, and an S3 bucket. It's a real `terraform apply`-able configuration, not pseudocode.

```
cd examples/complete
cp terraform.tfvars.example terraform.tfvars   # set your admin_cidr
terraform init
terraform apply
```

## CI

Every push runs three jobs:

- **validate** — `terraform fmt -check`, `terraform init`, and `terraform validate` against each module and the example, in a matrix
- **lint** — [tflint](https://github.com/terraform-linters/tflint) with the AWS ruleset, catching things like unused variables and non-standard naming
- **security-scan** — [tfsec](https://github.com/aquasecurity/tfsec) static analysis for common misconfigurations

## Design choices

Security-sensitive defaults (encryption, public access blocks, IMDSv2) are on by default and have to be explicitly turned off, not on. The `vpc` module's NAT gateway defaults to off since it bills hourly regardless of usage, and plenty of stacks don't need outbound access from private subnets.

## License

MIT, see [LICENSE](LICENSE).
