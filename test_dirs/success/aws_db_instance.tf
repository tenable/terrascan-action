#provider "aws" {
#  region = "us-west-2"
#}

resource "aws_db_instance" "secureInstance" {
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t2.micro"
  name                                = "mydb"
  backup_retention_period             = 90
  iam_database_authentication_enabled = true
  auto_minor_version_upgrade          = true
  kms_key_id                          = "ARN1234"
}
