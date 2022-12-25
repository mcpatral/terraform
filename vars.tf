variable "REGION" {
  default = "us-east-1"
}

variable "NAME" {
  default = "utc"
}
variable "CIDR" {
  default = "10.0.0.0/16"
}
variable "ZONE1" {
  default = "us-east-1a"
}
variable "ZONE2" {
  default = "us-east-1b"
}
variable "ZONE3" {
  default = "us-east-1c"
}
variable "PrivSub1" {
  default = "10.0.1.0/24"
}
variable "PrivSub2" {
  default = "10.0.2.0/24"
}
variable "PrivSub3" {
  default = "10.0.3.0/24"
}
variable "PubSub1" {
  default = "10.0.101.0/24"
}
variable "PubSub2" {
  default = "10.0.102.0/24"

}
variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0b5eea76982371e91"
    us-east-2 = "ami-0a606d8395a538502"
  }

}