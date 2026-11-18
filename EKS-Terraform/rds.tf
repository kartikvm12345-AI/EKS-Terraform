############################
# RDS SECURITY GROUP
############################

resource "aws_security_group" "rds_sg" {

  name        = "rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # For practice only.
    # Restrict this to your IP if you connect from your laptop.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

############################
# RDS SUBNET GROUP
############################

resource "aws_db_subnet_group" "sub_grp" {

  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

############################
# RDS MYSQL
############################

resource "aws_db_instance" "rds" {

  allocated_storage = 20

  identifier = "microservices-rds"

  db_subnet_group_name = aws_db_subnet_group.sub_grp.name

  engine         = "mysql"
  engine_version = "8.4.8"

  instance_class = "db.t3.micro"

  db_name  = "mydb"
  username = "admin"
  password = "Cloud123"

  multi_az = false

  publicly_accessible = true

  backup_retention_period = 0

  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  depends_on = [
    aws_db_subnet_group.sub_grp
  ]

  tags = {
    DB_identifier = "microservices-rds"
  }
}
