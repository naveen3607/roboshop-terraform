security_group = [ "sg-094473d55ab4bd85d" ]

zone_id = "Z06537442IUXZV0J4PKFE"

instance_type = "t2.micro"

components = {
    frontend = {
      name = "frontend"
    }
    catalogue = {
      name = "catalogue"
    }
    mongodb = {
      name = "mongodb"
    }
    redis = {
      name = "redis"
    }
    user = {
      name = "user"
    }
    cart = {
      name = "cart"
    }
    mysql = {
      name = "mysql"
    }
    shipping = {
      name = "shipping"
    }
    rabbitmq = {
      name = "rabbitmq"
    }
    payment = {
      name = "payment"
    }
    dispatch = {
      name = "dispatch"
    }
  }