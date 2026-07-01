variable "ec2_instance_type" {
    default = "t3.micro"
    type = string 
}

variable "ec2_root-storage_size" {
    default = 15
    type = number  
}

variable "ec2_ami_id" {
    default = "ami-0199ac7c9fbf9ed83"
    type = string
}