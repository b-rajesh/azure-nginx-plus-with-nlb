output "weather_api_url" {
  description = "Curl command to access weather API"
  value       = "curl http://${azurerm_public_ip.loadbalancer-public-ip.fqdn}/weather?city=melbourne"
}

output "hello-nginxplus_api_url" {
  description = "HTTPie command to access Hellow NGINX Plus API"
  value       = "http ${azurerm_public_ip.loadbalancer-public-ip.fqdn}/hello-nginxplus-api"
}

output "f1_api_url" {
  description = "HTTPie command to access F1 detail through API"
  value       = "http ${azurerm_public_ip.loadbalancer-public-ip.fqdn}/f1-api/f1/drivers.json"
}

output "nginxplus_dashboard_url" {
  description = "NGINX Plus dashboard App"
  value       = "http://${azurerm_public_ip.loadbalancer-public-ip.fqdn}:8080/dashboard.html"
}

output "admin_api_url" {
  description = "HTTPie command to access Admin API"
  value       = "http ${azurerm_public_ip.loadbalancer-public-ip.fqdn}:8080/api/6/http/upstreams"
}

output "inventory_api_url" {
  description = "HTTPie command to access Inventory API"
  value       = "http ${azurerm_public_ip.loadbalancer-public-ip.fqdn}/warehouse-api/inventory"
}

output "pricing_api_url" {
  description = "HTTPie command to access Pricing API"
  value       = "http ${azurerm_public_ip.loadbalancer-public-ip.fqdn}/warehouse-api/pricing"
}

