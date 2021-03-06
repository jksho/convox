variable "arm_type" {
  default = false
}

variable "availability_zones" {
  default = ""
}

variable "cidr" {
  default = "10.1.0.0/16"
}

variable "gpu_type" {
  default = false
}

variable "high_availability" {
  default = true
}

variable "internet_gateway_id" {
  default = ""
}

variable "k8s_version" {
  type = string
  default = "1.18"
}

variable "name" {
  type = string
}

variable "node_capacity_type" {
  default = "ON_DEMAND"
}

variable "node_disk" {
  default = 20
}

variable "node_type" {
  default = "t3.small"
}

variable "private" {
  default = true
}

variable "vpc_id" {
  default = ""
}
