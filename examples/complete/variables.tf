variable "name" {
  type        = string
  description = "Name prefix for all resources in this example."
  default     = "demo"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "us-east-1"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to use."
  default     = ["us-east-1a"]
}

variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the app server."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource."
  default = {
    Project = "terraform-aws-modules-example"
  }
}
