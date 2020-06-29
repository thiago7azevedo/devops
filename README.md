
# Bem vindos a instância beta do NGINX com docker compose!



- Objetivo:

	- Disponibilizar de forma estática um arquivo Json através do servidor NGINX;
	- Expor através da porta 80;
	- Rodar instância em um cluster Minishift.

- Procedimentos para iniciar instância Nginx:

	- Clone do projeto em seu repositório local:
		`git clone https://github.com/thiago7azevedo/devops.git`
	- Dentro da pasta devops, iniciar container:
		`docker-compose up -d`
	- Verificar se existem erros nos logs:
		`docker-compose logs -f`
	- Efetuar chamada no endpoint JSON:
		`{Seu IP}/api.json`

- Resultado esperado:

	- Veremos um Arquivo JSON:
		`{"service": {"oracle": "ok", "redis": "ok", "mongo": "down", "pgsql": "down", "mysql": "ok"}}`

- Procedimentos para Build da imagem personalizada:

	- Dockerfile:
		`vi Dockerfile`
	- Docker Compose:
		`vi docker-compose.yaml`
	- Configuração de arquivos:
		- `mkdir conf.d`
		
		- `cd conf.d`
		
		- `vi defaul.conf`
		
### Como ficou o arquivo conf.d:		
  ```
server
        {
        listen 80;
        server_name appsdevops.tk;

        location / {        
          autoindex on;
          autoindex_format json;
        }

        location ~ ^/api.json {
	       default_type   application/json;
           return 200  '{"service": {"oracle": "ok", "redis": "ok", "mongo": "down", "pgsql": "down", "mysql": "ok"}}';
         }
   ```
   
### Como ficou o docker-compose:
  ```
version: '3'

services:
 nginx:
    container_name: nginx-json
    image: thiago7sc/nginx:alpine
    ports:
      - "80:80"
    restart: always
    
   ```   
### Como ficou o Dockerfile:

  ```
FROM nginx:alpine
COPY ./conf.d/default.conf /etc/nginx/conf.d
EXPOSE 80
WORKDIR /etc/nginx/conf.d
ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]

  ```
### Build:
`docker build -t thiago7sc/nginx:alpine .`
#### OBS: Executar o comando onde está seu Dockerfile e não esqueçer do ponto ao final do comando. O nome da imagem criada, precisa ser o mesmo que estára no docker-compose.

### Build com docker-compose:
Para carregar a imagem que temos em nosso localhost que acabamos de criar, é necessário efetuar um Build também no docker-compose.
`docker-compose build`

### Subir containercom imagem personalizada:
`docker-compose up -d.`

### Verificar logs:
`docker-compose logs -f`

### Chamada endpoint:
Verificar em seu navegador com localhost/api.json a saida a seguir:

`{"service": {"oracle": "ok", "redis": "ok", "mongo": "down", "pgsql": "down", "mysql": "ok"}}`

## Imagens da construção:
![conf d](https://user-images.githubusercontent.com/53309633/86056723-4102f500-ba34-11ea-94b6-3ca676c927f1.png)
![build](https://user-images.githubusercontent.com/53309633/86056736-45c7a900-ba34-11ea-900c-d0c7efdf80b2.png)
![up](https://user-images.githubusercontent.com/53309633/86056732-44967c00-ba34-11ea-8d32-33731e2b8451.png)


## Instância no GCP rodando imagem personalizada nos procedimentos citados:

[API GCP](http://35.192.197.96/api.json)

## Testado e desenvolvido por:

#### Thiago Azevedo

thiago7azevedo@gmail.com - [Docker HUB](https://hub.docker.com/repository/docker/thiago7sc)

