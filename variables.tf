variable "prefix" {
  description = "A prefix used for all resources in this example - keep it within 3-5 letters"
}
variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}
variable "public-subnet-cidr" {
  description = "Enter CIDR(10.0.2.0/24) to host your API Gateway which will be accessed by Azure network load balancer"
}
variable "private-subnet-cidr" {
  description = "Enter CIDR(10.0.3.0/24) to host your microservices which will be accessed by NGINX Plus API Gateway"
}
variable "vnet-cidr" {
  description = "Enter CIDR(10.0.0.0/16) to host virual network"
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
}

variable "admin_password"  {
  description = "Password to use as the admin account on the VMs that will be part of the VM Scale Set"
}

variable "nginx-plus-resource-group" {
  description = "Enter the resource group name where you have already stored the nginx plus image"
}

variable "nginx-plus-image-name" {
  description = "Enter nginx plus image name thats stored in your resource group"
}
variable "f1-image-resource-group" {}
variable "f1-image-name" {}
variable "hello-image-resource-group" {}
variable "hello-image-name" {}
variable "weather-image-resource-group" {}
variable "weather-image-name" {}
