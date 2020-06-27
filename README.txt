#######################################################

Bem vindos a instância beta do NGINX com docker compose!

#######################################################

-> Objetivo:

	- Disponibilizar de forma estática um arquivo Json através do servidor NGINX;
	- Expor através da porta 80;
	- Rodar instância em um cluster Minishift.

-> Procedimentos para iniciar instância Nginx:

	- Clone do projeto em seu repositório local:
		git clone https://github.com/thiago7azevedo/devops.git
	- Dentro da pasta devops, iniciar container:
		docker-compose up -d
	- Verificar se existem erros nos logs:
		docker-compose logs -f
	- Efetuar chamada no endpoint JSON:
		{Seu IP}/api.json

-> Resultado esperado:

	- Veremos um Arquivo JSON:
		{"service": {"oracle": "ok", "redis": "ok", "mongo": "down", "pgsql": "down", "mysql": "ok"}}


#######################################################

Instância no GCP rodando imagem personalizada nos procedimentos citados:

http://35.192.197.96/api.json

#######################################################

Testado e desenvolvido por:

Thiago Azevedo - thiago7azevedo@gmail.com - https://hub.docker.com/repository/docker/thiago7sc
