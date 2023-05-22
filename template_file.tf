data "aws_s3_object" "this" {
  bucket = "demo-8795"
  key    = "apache-tomcat-7.0.64-PL.tar"
}

data "aws_s3_object" "war_file" {
  bucket = "demo-8795"
  key    = "egencia.war"
}


data "template_file" "user_data" {
  template = <<-EOF
    #!/bin/bash
    aws s3 cp s3://${data.aws_s3_bucket_object.this.bucket}/${data.aws_s3_bucket_object.this.key} /usr/local
    tar -xvf /usr/local/apache-tomcat-7.0.64-PL.tar -C /usr/local
    aws s3 cp s3://${data.aws_s3_bucket_object.war_file.bucket}/${data.aws_s3_bucket_object.war_file.key} /usr/local/apache-tomcat-7.0.64-PL/webapps/
    chown -R ec2-user:ec2-user /usr/local/apache-tomcat-7.0.64-PL/webapps/egencia.war
    chmod +x /usr/local/apache-tomcat-7.0.64-PL/webapps/egencia.war
    /usr/local/apache-tomcat-7.0.64-PL/bin/startup.sh
  EOF
}
