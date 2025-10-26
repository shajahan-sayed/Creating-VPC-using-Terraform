terraform {
  required providers {
     aws = {
       source = "hashicorp/aws"
           version = "~> 5.0"
     }
  }

  required_version = ">= 1.3.0"
}

provider {
  region = var.aws_region
}
    
