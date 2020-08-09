output "loadbalancer-public-fqdn" {
  description = "Public fqdn for the azure load balancer"
  value       = azurerm_public_ip.loadbalancer-public-ip.fqdn
}