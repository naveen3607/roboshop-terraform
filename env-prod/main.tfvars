vpc = {
  main = {
    cidr = "10.50.0.0/16"
    subnets = {
      public = {
        public1 = { cidr = "10.50.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.50.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.50.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.50.3.0/24", az = "us-east-1b" }
      }
      db = {
        db1 = { cidr = "10.50.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.50.5.0/24", az = "us-east-1b" }
      }
    }
  }
}

default_vpc_id = "vpc-03a15501ce2cd642f"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_route_table_id = "rtb-0555ec001edd385f2"
zone_id = "Z06537442IUXZV0J4PKFE"
ssh_ingress_cidr = ["172.31.0.0/16"]
monitoring_ingress_cidr = ["172.31.0.0/16"]
acm_certificate_arn = "arn:aws:acm:us-east-1:207153251982:certificate/107eeb19-7228-4afd-96ea-b2da2468f651"
kms_key_id = "arn:aws:kms:us-east-1:207153251982:key/91ab5fca-9ae7-4c4e-9dd8-f1e1ee3da95f"

tags = {
  company_name = "ABC Tech"
  business_unit = "Ecommerce"
  project_name = "robotshop"
  cost_center = "ecom_rs"
  created_by = "terraform"
}

env = "prod"

alb = {
  public = {
    internal = false
    lb_type = "application"
    sg_ingress_cidr = ["0.0.0.0/0"]
    sg_port = 443
  }
  private = {
    internal = true
    lb_type = "application"
    sg_ingress_cidr = ["172.31.0.0/16", "10.50.0.0/16"]
    sg_port = 80
  }
}

docdb = {
  main = {
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot = true
    engine_version = "4.0.0"
    engine_family = "docdb4.0"
    instance_count = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    engine_version = "5.7.mysql_aurora.2.11.3"
    engine_family = "aurora-mysql5.7"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    rds_type = "mysql"
    db_port = 3306
    engine = "aurora-mysql"
    skip_final_snapshot = true
    instance_count = 1
    instance_class = "db.t3.small"
  }
}

elasticache = {
  main = {
    port = 6379
    elasticache_type = "redis"
    node_type = "cache.t3.micro"
    num_cache_nodes = 1
    engine = "redis"
    family = "redis6.x"
    engine_version = "6.2"
  }
}

rabbitmq = {
  main = {
    instance_type = "t3.micro"
  }
}

apps = {
  frontend = {
    instance_type = "t3.micro"
    port = 80
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 1
    parameters = ["nexus"]
    tags = { Monitor_Nginx = "yes" }
  }
  catalogue = {
    instance_type = "t3.micro"
    port = 8080
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 2
    parameters = ["docdb", "nexus"]
    tags = {}
  }
  user = {
    instance_type = "t3.micro"
    port = 8080
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 3
    parameters = ["docdb", "nexus"]
    tags = {}
  }
  cart = {
    instance_type = "t3.micro"
    port = 8080
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 4
    parameters = ["nexus"]
    tags = {}
  }
  shipping = {
    instance_type = "t3.medium"
    port = 8080
    desired_capacity = 2
    max_size = 10
    min_size = 1
    lb_priority = 5
    parameters = ["rds", "nexus"]
    tags = {}
  }
  payment = {
    instance_type = "t3.micro"
    port = 8080
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 6
    parameters = ["rabbitmq", "nexus"]
    tags = {}
  }
  dispatch = {
    instance_type = "t3.micro"
    port = 8080
    desired_capacity = 1
    max_size = 10
    min_size = 1
    lb_priority = 7
    parameters = ["nexus"]
    tags = {}
  }
}