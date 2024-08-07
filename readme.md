# RMS

## Como executar a aplicação localmente
É necessário baixar todos os 3 microserviços para executar o projeto
Order:
Payment:
Production:

Você precisa criar uma imagem dos 3 microserviços com os respectivos comandos
`docker build -t production-api .`
`docker build -t payment-api .`
`docker build -t order-api .`

Com as 3 imagens criadas em seu repositorio local, pode ser executado o comando `docker-compose up`.

Note que existe uma race condition com o Kafka e os microserviços production e payment. Ambos irão iniciar e cair até o Kafka estar em pronto, dependendo da configuração da sua maquina isso pode levar alguns segundos ou minutos.

Com todos os serviços ativos, é possível acessar as aplicações através dos sequinters endereços:
Order: http://localhost:3001/docs
Payment: http://localhost:3002/docs
Production: http://localhost:3003/docs
DB:http://localhost:3006 - usuário e senha "postgres"
Mongo: mongodb://localhost:27017
Kafdrop: http://localhost:9000/

Executar os aplicativos individualmente não é recomendado, pois será necessário subir os respectivos bancos (postgres e Mongo) bem como o Kafka. Não subir um desses irá causar erros de conexão no NestJS e o mesmo não irá subir a aplicação. Caso seja necessário, adicione um arquivo .env na raiz do microserviço com as variáveis de ambiente de conexão dos bancos necessários, do Kafka e a porta desejada para aplicaçao. As variáveis de ambiente necessárias para cada aplicação está listada no arquivo main.ts.

Criados os arquivos, execute o comando `npm install` no diretório da aplicação e depois `npm run start`.

### Requisitos

Acessar a raiz do projeto usando um terminal de sua escolha que tenha acesso a CLI do Docker

Executar do comando: `docker-compose up`


## SAGA
Devido a baixa complexidade e ao uso de arquitetura de microserviços, foi decidido o uso de uma SAGA Coreografada. A implementação de uma SAGA Orquestrada foi considerada e descartada por dois motivos:

1) As quantidade de mudanças no fluxo da solução e na arquitetura da Fase 2, para a 3 e da 3 para a fase 4 foram consideráveis. Essas mudanças (em um cenário real) tem um impacto grande no time de desenvolvimento que precisa adequar seu dia a dia e conhecimentos para continuar entregando melhorias de software enquanto o mesmo se mantem operando.

2) O atual cenário de negócio, não sofre nenhuma influencia negativa do uso de uma saga orquestrada. Os sistemas envolvidos são pagamento e produção, e uma desincronização no estados entre eles, desde que pequena, não tem um efeito grande na entrega do serviço aos clientes do negócio.


## OWASP ZAP

## RIPD

## Arquitetura

## Video



## Comandos

- terraform init 
- terraform fmt - recursive # para formatar tudo
- terraform validate # bom rodar para evitar perda de tempo
- terraform plan
- terraform apply -auto-approve #já dá YES para correr com a execuçao
- terraform destroy -auto-aprove # destroy com auto approve.


## Algumas referencias usadas
https://dev.to/aws-builders/navigating-aws-eks-with-terraform-understanding-vpc-essentials-for-eks-cluster-management-51e3

https://www.youtube.com/watch?v=kRKmcYC71J4

https://github.com/stacksimplify/terraform-on-aws-eks/tree/main