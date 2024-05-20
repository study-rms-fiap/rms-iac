resource "aws_apigatewayv2_api" "rms" {
  name          = "rms"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.rms.id

  name        = "dev"
  auto_deploy = true
}

////////////////////////////

resource "aws_security_group" "vpc_link" {
  name   = "vpc-link"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "eks"
  security_group_ids = [aws_security_group.vpc_link.id]
  subnet_ids = [
    # aws_subnet.private-us-east-1a.id,
    # aws_subnet.private-us-east-1b.id
    var.private_subnets[0],
    var.private_subnets[1],
    var.private_subnets[2]
  ]
}

resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.rms.id
  /**
Esse integration uri eu nao consegui fazer ele ser automatico
Foi necessário ir buscar no loadbalancer do ec2
https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancers:
clica no name do loadbalancer criado, no final da pagina, vai em listerners
e copia o valor de arn de lá.
*/
  integration_uri    = "arn:aws:elasticloadbalancing:us-east-1:211125380755:listener/net/a083cf68c61964285bb9d3d2014c4768/76830dd23e7307cf/708de6dc14198605"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks.id
}

resource "aws_apigatewayv2_route" "get_echo" {
  api_id = aws_apigatewayv2_api.rms.id

  route_key = "GET /echo"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

