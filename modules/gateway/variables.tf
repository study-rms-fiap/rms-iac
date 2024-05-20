variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}


variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(any)
}