output "cloudfront_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}
output "static_bucket_name" {
  value = aws_s3_bucket.static.bucket
}