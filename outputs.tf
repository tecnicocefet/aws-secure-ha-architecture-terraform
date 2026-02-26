output "bastion_public_ip" { value = module.bastion.public_ip }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "cloudfront_domain" { value = module.cdn.cloudfront_domain }

output "rds_endpoint" { value = module.rds.db_endpoint }
output "efs_dns_name" { value = module.efs.dns_name }