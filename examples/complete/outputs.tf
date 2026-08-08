output "vpc_id" {
  value = module.vpc.vpc_id
}

output "app_server_public_ip" {
  value = module.app_server.public_ip
}

output "assets_bucket_id" {
  value = module.assets_bucket.bucket_id
}
