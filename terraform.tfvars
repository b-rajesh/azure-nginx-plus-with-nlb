prefix                          = "raj" //keep it within 3-5 letters as the code is also generating unique petname along with it.
location                        = "australiasoutheast"
public-subnet-cidr              = "10.0.2.0/24"
private-subnet-cidr             = "10.0.3.0/24"
vnet-cidr                       = "10.0.0.0/16"
nginx-plus-resource-group       = "nginxplus-image-rg"
nginx-plus-image-name           = "ngx-plus-r22"
admin_user                      = "azureadmin"
f1-image-resource-group         = "microservice-image-rg"
f1-image-name                   = "f1-api-v1"
hello-image-resource-group      = "microservice-image-rg"
hello-image-name                = "hello-nginxplus-api-v1"
weather-image-resource-group    = "microservice-image-rg"
weather-image-name              = "weather-api-v1"