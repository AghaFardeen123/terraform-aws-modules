variable "name" {
  type        = string
  description = "Name prefix applied to all resources created by this module."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to spread subnets across."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets, one per AZ."
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets, one per AZ."
  default     = []
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Provision a NAT gateway so private subnets can reach the internet. Adds hourly cost."
  default     = false
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one shared NAT gateway instead of one per AZ. Cheaper, less fault tolerant."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
