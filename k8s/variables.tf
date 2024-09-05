variable "networking" {
  type = object({
    cidr_block      = string
    vpc_name        = string
    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
    nat_gateways    = bool
    region          = string
  })
  default = {
    cidr_block      = "10.0.0.0/16"
    vpc_name        = "terraform-vpc"
    azs             = ["us-east-2a", "us-east-2b", "us-east-2b"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
    nat_gateways    = true
    region          = "us-east-2"
  }
}
variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    egress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
  default = [{
    name        = "internal-ssh-security-group"
    description = "Inbound & Outbound traffic security-group"
    ingress = [
      {
        description      = "Allow internal ssh"
        protocol         = "tcp"
        from_port        = 22
        to_port          = 22
        cidr_blocks      = ["10.0.0.0/16"]
        ipv6_cidr_blocks = null
      }
    ]
    egress = [
      {
        description      = "Allow all outbound traffic"
        protocol         = "-1"
        from_port        = 0
        to_port          = 0
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ]
  }]
}

variable "addons" {
  type = list(object({
    name = string
  }))

  default = [
    {
      name = "kube-proxy"
    },
    {
      name = "vpc-cni"
    },
    {
      name = "coredns"
    }
  ]
}