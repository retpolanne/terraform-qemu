provider "aws" {
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    endpoints {
        ec2           = "http://localhost:5000"
    }
}

data "cloudinit_config" "foobar" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = file("${path.module}/cloud-config.yaml")
  }
}

resource "aws_instance" "web" {
  ami           = "ami-055744c75048d8296"
  instance_type = "t3.micro"
  user_data = data.cloudinit_config.foobar.rendered

  tags = {
    Name = "HelloWorld"
  }
}
