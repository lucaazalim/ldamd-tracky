# Orientações para Correção (PT-BR)

Olá, Hugo!

Preparamos este documento para orientá-lo sobre como avaliar o que foi desenvolvido para esta última entrega do trabalho de Laboratório de Desenvolvimento de Aplicações Móveis e Distribuídas.

---

## Links Úteis

- [Documentação técnica do backend](/code/backend/README.md)
- [Documentação técnica do aplicativo móvel](/code/mobile/README.md)

---

## Demonstração da UI

O vídeo abaixo demonstra o funcionamento do aplicativo móvel desenvolvido, com integração funcional com o backend. Todas as requisições realizadas foram roteadas por meio do API Gateway.

<img src="assets/demo.gif" alt="Demonstração da aplicação Tracky" height="600">

---

## Arquitetura

A arquitetura da aplicação Tracky foi projetada com base em microsserviços, garantindo escalabilidade, isolamento de responsabilidades e facilidade de manutenção. O diagrama a seguir ilustra a composição e interação entre os principais componentes do sistema, incluindo:

- Serviços independentes desenvolvidos com Spring Boot;
- Bancos de dados PostgreSQL dedicados para cada domínio;
- Um barramento de mensagens RabbitMQ para comunicação assíncrona;
- Descoberta de serviços via Consul.

O roteamento de requisições externas é realizado por meio do API Gateway (Spring Cloud Gateway), que centraliza o acesso às APIs REST expostas pelos serviços. Cada microsserviço é responsável por um domínio específico.

![Arquitetura](/assets/architecture.png)

---

## Critérios de Avaliação

Para auxiliar na avaliação do trabalho, a seguir são descritas as implementações realizadas em relação a cada critério de correção.

---

### Critério: Notificação de Avaliação

Foi implementado um fluxo de notificação para alertar o cliente quando o motorista concluir uma entrega. Quando o pedido tem seu status atualizado para `DELIVERED`, uma mensagem é publicada via RabbitMQ pelo `order-service` na fila `order.delivered.queue` e, posteriormente, processada pelo `notification-service` para envio via e-mail (utilizando **SMTP**) e push notification (utilizando **Firebase Cloud Messaging**).

Embora não tenhamos conseguido demonstrar o funcionamento completo em vídeo devido a problemas no ambiente de desenvolvimento do aplicativo Flutter, que nos impediu de gerar um device token para cadastro via API do Firebase, acreditamos que a implementação desenvolvida seja suficiente para demonstrar que o critério foi atendido adequadamente.

**Fluxo:**

![Fluxo de notificação](/assets/order-delivered-diagram.png)

**Arquivos críticos da implementação:**

- [OrderService.java](/code/backend/order-service/src/main/java/com/tracky/orderservice/service/OrderService.java) (`order-service`)
- [OrderEventPublisher.java](/code/backend/order-service/src/main/java/com/tracky/orderservice/service/OrderEventPublisher.java) (`order-service`)
- [OrderDeliveredEventListener.java](/code/backend/notification-service/src/main/java/com/tracky/notificationservice/listener/OrderDeliveredEventListener.java) (`notification-service`)
- [NotificationService.java](/code/backend/notification-service/src/main/java/com/tracky/notificationservice/service/NotificationService.java) (`notification-service`)

---

### Critério: Envio de E-mail de Resumo

O mesmo fluxo de notificação de conclusão de pedido, descrito no critério anterior, também é responsável por construir e enviar os e-mails de resumo de pedido tanto para o cliente quanto para o motorista, garantindo que ambas as partes recebam informações detalhadas sobre a transação finalizada.

![Email de pedido entregue](/assets/order-delivered-email.png)

**Arquivos críticos da implementação:**

- [EmailService.java](/code/backend/notification-service/src/main/java/com/tracky/notificationservice/service/EmailService.java) (`notification-service`)

---

### Critério: Segmentação Inteligente

O mecanismo de campanhas implementado permite a segmentação de notificações promocionais baseada no **tipo de usuário**, viabilizando o envio de ofertas e oportunidades distintas para clientes e motoristas. A arquitetura foi projetada de forma modular, permitindo que novos critérios de segmentação sejam facilmente implementados no futuro.

**Arquivos críticos da implementação:**

- [EmailService.java](/code/backend/notification-service/src/main/java/com/tracky/notificationservice/service/EmailService.java) (`notification-service`)

---

### Critério: Campanhas Promocionais

Foi desenvolvido um sistema completo de criação e envio de campanhas promocionais, envolvendo a integração entre os microsserviços [`campaign-service`](/code/backend/campaign-service/) e [`notification-service`](/code/backend/notification-service/). Este mecanismo permite o gerenciamento centralizado de campanhas de marketing direcionadas.

![Fluxo de envio de campanhas promocionais](/assets/campaign-diagram.png)

---

### Critério: Event-Driven Architecture

O desacoplamento entre os microsserviços foi alcançado por meio da implementação de uma arquitetura orientada a eventos, utilizando o message broker **RabbitMQ**, conforme demonstrado no diagrama da arquitetura e nos diagramas de sequência incluídos neste documento.

Para situações específicas em que uma informação é necessária de forma imediata (comunicação síncrona), foram mantidas comunicações diretas pontuais entre os microsserviços, garantindo assim o equilíbrio entre desacoplamento e performance.

---

### Critério: Arquitetura Serverless

Este critério não foi implementado devido a limitações de tempo. A abordagem sugerida no enunciado previa a comunicação direta entre funções Lambda e os microsserviços, o que exigiria o provisionamento completo da infraestrutura na AWS, incluindo o deploy dos serviços em contêineres EC2 e a configuração de rede necessária. Diante do prazo restrito de uma semana, essa implementação se mostrou inviável.
