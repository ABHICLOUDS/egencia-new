data "aws_s3_object" "user_data_script" {
  bucket = "demo-8795"
  key    = "script.sh"
}

