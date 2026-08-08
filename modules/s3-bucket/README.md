# s3-bucket

Creates an S3 bucket with versioning, default encryption, and public access blocked, all on by default so you have to opt out rather than opt in to a secure configuration.

## Usage

```hcl
module "assets" {
  source = "../../modules/s3-bucket"

  bucket_name = "my-app-assets-prod"

  lifecycle_rules = [
    {
      id                                  = "expire-noncurrent"
      enabled                             = true
      noncurrent_version_expiration_days  = 30
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
| bucket_name | Globally unique bucket name | string | n/a |
| versioning_enabled | Enable object versioning | bool | `true` |
| enable_encryption | Enable default SSE-S3 encryption | bool | `true` |
| block_public_access | Block all public access | bool | `true` |
| lifecycle_rules | Lifecycle rules for expiration | list(object) | `[]` |
| tags | Tags applied to the bucket | map(string) | `{}` |

## Outputs

| Name | Description |
|---|---|
| bucket_id | Bucket name/ID |
| bucket_arn | Bucket ARN |
| bucket_domain_name | Bucket's regional domain name |

## Security defaults

Versioning, encryption, and the public access block are all enabled by default. If you actually need a public bucket (static site hosting, for example), set `block_public_access = false` explicitly and pair it with a bucket policy, rather than this module silently allowing it.
