output "strapi_url" {
  value = "http://${module.alb.alb_dns}"
}
