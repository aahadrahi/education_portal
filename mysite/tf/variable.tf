variable region {
  type = string
  default = "ap-south-1"
  description = "AWS Region"
}

variable name_prefix {
  type = string
  default = "educationportal"
  description = "Prefix applied to the name of most resources"
}

variable environment_tag {
  type = string
  default = "educationportal"
  description = "Environment tag applied to most resources"
}

variable vpc_cidr_block {
  type = string
  default = "10.232.0.0/16"
  description = "Private IPv4 address space for the VPC"
}

variable default_from_email {
  type = string
  default = "educationportal@example.com"
  description = "Email address to send from; also used as the default initial superuser email address"
}
