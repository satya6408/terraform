variable "ec2_instance_type" {

  default = "t3.micro"
  type    = string
}


variable "ec2_root_staorage_size" {

  default = 15
  type    = number

}

variable "ec2_ami_id" {

  default = "ami-0532913178263be11"
  type    = string

}
