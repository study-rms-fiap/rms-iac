resource "aws_db_subnet_group" "rms" {
  name = "rms-prod-subnetgroup"
  // o certo era estar na privada, maaas nao consegui fazer a conexão funcionar,
  // talvez eu precise de um nlb?
  subnet_ids = var.public_subnets
}

resource "aws_security_group" "rds" {
  name   = "rms-rds-securitygroup"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "rms" {
  name   = "rms-rds-paramgroup"
  family = "mariadb10.11"
}

//----------DB ORDER--------------//

resource "aws_db_instance" "rms_order" {
  identifier                  = "rms-dp-order"
  instance_class              = "db.t3.micro"
  allocated_storage           = 5
  db_name                     = "dborder"
  engine                      = "mariadb"
  manage_master_user_password = true # Cria e salva num secrets na AWS. Nao consegui usar no yaml. Tem que passar manualmente para o secrets do github
  username                    = "root"
  db_subnet_group_name        = aws_db_subnet_group.rms.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  parameter_group_name        = aws_db_parameter_group.rms.name
  publicly_accessible         = true
  skip_final_snapshot         = true //parece que vai tirar um snapshot quando deletar. desativando porque deve custar mais
  storage_encrypted           = false
}

# Faz a rotação do secrets sozinho, Util se eu conseguir usar o secrets no k8 yaml
# buscar sozinho os valores. Para efeito da pós 7 dias tá ok.
resource "aws_secretsmanager_secret_rotation" "rms_order" {
  secret_id = aws_db_instance.rms_order.master_user_secret[0].secret_arn

  rotation_rules {
    automatically_after_days = 7
  }
}