output "alb_dns_name_prod" {
  value       = module.webserver-cluster.alb_dns_name
  description = "The domain name of the load balancer."
}