# Tracky

Este documento é uma tentativa de compreender os requisitos descritos nos enunciados do trabalho.

---

Uma empresa de logística enfrenta desafios na gestão eficiente de suas entregas e no rastreamento em tempo real de seus veículos. Eles buscam uma solução tecnológica que permita aos clientes acompanhar suas encomendas, aos motoristas gerenciar suas rotas e à empresa otimizar suas operações logísticas.

## 1. Requisitos da disciplina

1.1. O trabalho deve ser desenvolvido em grupos de até 5 alunos.

1.2. O trabalho deve ser entregue no GitHub Classroom.

1.3. Todos os alunos devem se envolver em atividades de desenvolvimento.

1.4. As atividades do projeto devem ser registradas como _issues_.

1.5. Os commits do repositório devem ser atômicos.

1.6. Os commits do repositório devem usar o padrão [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

1.7. Os commits do repositório devem referenciar o issue correspondente às alterações realizadas.

## 2. Requisitos de documentação

2.1. Atividades de desenvolvimento em nuvem devem ser documentadas de forma detalhada no repositório e os scripts de configuração devem ser exportados e submetidos ao GitHub, de forma que o projeto seja reprodutível.

2.2. Todo o código do projeto deve ser documentado.

## 3. Requisitos funcionais

3.1. O aplicativo deve permitir aos clientes visualizar a geolocalização dos pedidos, com atualização a cada 2 minutos.

3.2. O sistema deve disparar alertas aos motoristas quando houver restrições de rota, como obras ou bloqueios.

3.3. O aplicativo deve permitir ao operador logístico gerar relatórios de produtividade por veículo, com a métrica de kilômetros rodados por pedido concluído.

3.4. O aplicativo deve permitir aos clientes e motoristas gerenciar suas preferências de notificação.

3.5. O aplicativo deve permitir ao motorista acessar o histórico de pedidos concluídas com métricas de desempenho.

3.6. O aplicativo deve permitir aos operadores logísticos simular cenários de distribuição com variáveis climáticas e de demanda.

3.7. O aplicativo deve permitir aos clientes visualizar o histórico de pedidos.

3.8. O aplicativo deve permitir aos motoristas reportar incidentes em tempo real, como avarias no veículo e acidentes.

3.9. O aplicativo deve permitir aos operadores logísticos monitorar o consumo de combustível em tempo real por rota.

3.10. O sistema deve disparar notificações aos clientes quando o status de um pedido for alterado.

3.11. O aplicativo deve permitir aos motoristas atualizar o status de um pedido mediante a captura de uma foto com a câmera do celular e da geolocalização.

3.12. O aplicativo deve permitir aos clientes e motoristas gerenciar sua preferência de tema claro e escuro.

3.13. O aplicativo deve permitir aos clientes e motoristas cancelarem pedidos.

## 4. Requisitos não funcionais

4.1. O aplicativo deve armazenar dados localmente, em um banco de dados SQLite, para permitir funcionamento sem conexão com a internet.

4.2. O aplicativo deve sincronizar os dados armazenados localmente com o back-end quando a conexão com a internet for reestabelecida.

4.3. O aplicativo deve armazenar as preferências dos usuários usando Shared Preferences.

4.4. O aplicativo deve solicitar permissão disparo de notificações _push_.

4.5. O aplicativo deve implementar estratégias de tratamento de erro, como tratamento de falhas de requisição, tratamento de permissões negadas à câmera ou geolocalização, e tratamento de falhas no armazenamento de dados locais (SQLite e Shared Preferences).

4.6. O aplicativo deve ser desenvolvido em Flutter com a linguagem Dart.
