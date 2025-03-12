
variable "region" {
  default = "us-east-1"
}
variable "ssh_key_path" {
  default = "~/Documents"
}
variable "instance_type" {
  default = "t2.large"
}
variable "ssh_key_name" {
  default = "terraform-key"
}
variable "ip_whitelist" {
  default = ["1.3.3.7/32"]
}
variable "vpc_id"{
    type = string
}

variable "subnet_id" {
    type = string
}
variable "tf_token" {
  type        = string
  description = "TFE Token"

  validation {
    condition     = length(var.tf_token) > 0
    error_message = "Terraform Enterprise API token cannot be empty."
  }
}

variable "workspace" {
  type = string
}