variable "name" {
  type        = string
  description = "Name tag for the instance."
}

variable "ami_id" {
  type        = string
  description = "AMI to launch. Defaults to the latest Ubuntu 22.04 image if left null."
  default     = null
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch the instance in."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach."
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access. Leave null to launch without one."
  default     = null
}

variable "associate_public_ip" {
  type        = bool
  description = "Assign a public IP on launch."
  default     = false
}

variable "user_data" {
  type        = string
  description = "User data script to run on first boot."
  default     = null
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GB."
  default     = 20
}

variable "root_volume_type" {
  type        = string
  description = "Root EBS volume type."
  default     = "gp3"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the instance."
  default     = {}
}
