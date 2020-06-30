
# Bem vindos a instância beta do NGINX com docker compose. Instalação e configuração de instância minishift para rodar imagem personalizada!




- Objetivo:
		
	- Criar imagem personalizada NGINX com docker;
	- Disponibilizar de forma estática um arquivo Json através do servidor NGINX exportando através da porta 80;
	- Instalar e configurar instância Minishift para rodar nossa imagem personalizada em docker;
	- Acessar endpoint de qualquer local da internet e efetuar a leitura do arquivo em formato Json.

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

## Exportar imagem para DockerHub:
`docker login`
Efetuar login no docker hub

`docker push thiago7sc/nginx:tagname`
Este comando envia a imagemcirada para o repositório remoto:

### OBS: Você precisa préviamente criar umrepositório com o nome da sua imagem. Neste exemplo meu repositório no DockerHub é [nginx](https://hub.docker.com/repository/docker/thiago7sc/nginx)

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

### Imagens da construção da imagem:
![conf d](https://user-images.githubusercontent.com/53309633/86056723-4102f500-ba34-11ea-94b6-3ca676c927f1.png)
![build](https://user-images.githubusercontent.com/53309633/86056736-45c7a900-ba34-11ea-900c-d0c7efdf80b2.png)
![up](https://user-images.githubusercontent.com/53309633/86056732-44967c00-ba34-11ea-8d32-33731e2b8451.png)



# Configuração Instância Minishift:

 #### Observações iniciais:
 
- Primeiramente precisamos de um hardware acima de 8GB de RAM e um processador ao menos dual core. Além disso, Máquina precisa aceitar virtualização, setada através da BIOS. Dito isto, após diversas tentativas de iniciar o minishift em VMS do Google Cloud, nenhuma instância aceitou a virtualização no período de testes que o GCP disponibiliza. Caso seja necessário após o período de testes, o GCP disponibiliza um processo de configuração de VM com [virtualização aninhada](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances?hl=pt-br).
	
- Após isto, precisei de um hardware local mesmo para isto. Primeira tentativa em um Noteboook rodando LUBUNTU 18.04 com 4GB de RAM + i3. Consegui efetuar a instalação mas ao subir a instância completamente, estourou até a swap do Linux. 
	
- Foi necessário um plano C, até que consegui uma maquina rodando W10 Ultimate com CPU de 8GB de RAM com processador i5. Rodou muito bem, no entanto, consome em torno de 95% de RAM com a instância do minishift instalada e rodando.

## Ativar virtualização via BIOS:

- Procurar a opção virtualização da BIOS da sua CPU e marcarf como ativa.

## Download Minishift:

- O downloado pode ser efetuado através do repositório oficial em aqui: [Minishift](https://github.com/minishift/minishift/releases/tag/v1.34.2).
- Descompactar o arquivo em uma pasta de fácil acesso;

## Instalação Minishift e Hyper-V:

- Um dos pŕé requisitos para rodar o Minishift, é a instalação de um driver de virtualização, neste caso utilizei o Hyper-V nativo no W10. Basta procurar no windows por Hyper.
- ??? Print
- Abrir o CMD ou Terminal e acessar a pasta do Minishift que foi descompactada
- Na raíz desta pasta descompactada, efetuar o comando `minishift start` e aguardar a configuração e inicialização
![iniciando minishift windows](https://user-images.githubusercontent.com/53309633/86068773-94823c80-ba4e-11ea-87de-616a38342bb6.png)
![minishift up windows1](https://user-images.githubusercontent.com/53309633/86068742-8a603e00-ba4e-11ea-8f77-6da8a03e8e37.png)
- Se tudo ocorrer bem, conforme seguido até aqui, mostrará na tela a `OpenShift server Starter` e estará pronto para configuração via console
![minishift up windows](https://user-images.githubusercontent.com/53309633/86068758-90561f00-ba4e-11ea-840a-fa26f95a07bf.png)
- O Ip e porta para acesso ao console estará no log de inicialização, será algo assim: `https://172.17.59.62:8443/console`
- Login e senha já vem pré configurado para admin:admin ou developer:developer

![criação projeto dentro do minishift](https://user-images.githubusercontent.com/53309633/86068759-91874c00-ba4e-11ea-9ce4-82c98845de2d.png)


#### OBS: A configuração inicial de acesso, projeto, deploy e rotas será feito via painel console. Outra forma de configurar é via OpenShift CLI (oc), por linha de comando. Este link [Aqui](https://docs.openshift.com/container-platform/4.4/cli_reference/openshift_cli/getting-started-cli.html) possui as isntruções de instalação nos diversos sistemas. O download da ferramenta para windows está [aqui](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-windows.zip).

## Configuração isntância Minishift:

- Com o console já acessado, é necessário criar um projeto novo em branco
- Após o projeto criado, vamos fazer um deploy da imagem personalizada criada anteriormemente, que estará hospedada no [DockerHUb](https://hub.docker.com/repository/docker/thiago7sc/nginx).
![deploy imagem personalizada](https://user-images.githubusercontent.com/53309633/86068768-93510f80-ba4e-11ea-96e9-da016a06884f.png)
- Assim que a imagem é configurada atarvés do image name thiago7sc/nginx:alpine, o POD será criado automaticamente e estará rodando em seguida.
![deploy rodando](https://user-images.githubusercontent.com/53309633/86068736-892f1100-ba4e-11ea-84b3-b8a6a540e413.png)
- Após isto, é necessário criar a rota externa para o endpoint de sua aplicação, conforme configuração de porta efetuada no docker compose da imagem.
![rota externa criada ](https://user-images.githubusercontent.com/53309633/86068750-8cc29800-ba4e-11ea-88b1-3ac97648a7af.png)

## IMPORTANTE:
 #### Com restrições de contexto de segurança (SCCs)
- Algumas imagens de banco e serviços precisam rodar com root devido as restrições de segurança, por isso é necessário configurar o SCC para seu pod.
- Siga para a psta que descompactou a sua OpenShift CLI (oc) e abra um terminal ali. Digite os comandos oc todos na raíz desta pasta.

`oc status`
Verifica o status do ambiente que voce está conectado

`oc project {seuprojeto}`
Adiciona acesso ao projeto que voce escolher da lista 

`oc get pods`
Efetua leitura do status do pod que você acabou de criar.

`oc get scc` 
Lista todos os contextos de segurança pré-configurados.
![login e status pod e projeto](https://user-images.githubusercontent.com/53309633/86068731-86342080-ba4e-11ea-9c4c-9c4f5352787f.png)

`oc adm policy add-scc-to-user privileged -z default`
Este comando coloca seu pod no contexto correto para rodar o POD.
![configurando scc](https://user-images.githubusercontent.com/53309633/86068732-86ccb700-ba4e-11ea-8dea-75d50cd3c5f4.png)
 
 - É necessário agora refazer o deploy do seu projeto, onde estará rodando sem erros.
 ![deploy completo e imagem rodando](https://user-images.githubusercontent.com/53309633/86068763-92b87900-ba4e-11ea-95db-25bf3895d3c4.png)
 ![pod rodando](https://user-images.githubusercontent.com/53309633/86068727-83393000-ba4e-11ea-93a4-003f3b6eade5.png)

 
 ![serviço estático gerado pela imagem nginx em uma instancia minishift](https://user-images.githubusercontent.com/53309633/86068746-8b916b00-ba4e-11ea-9aba-51ad5c7a4540.png)
 
 # BONUS:

### Configuração ngrok para exposição de seu endpoint para a internet:

- O link gerado pela instância minishift tem acesso somente em seu localhost, por isso se voce precisar utilizar de forma paliativa a exposição para a internet de suas aplicações, poderá utilziar o app [NGROK](dashboard.ngrok.com/get-started/setup).
![download ngrok](https://user-images.githubusercontent.com/53309633/86068754-8df3c500-ba4e-11ea-9297-f39c6d80600d.png)
- Após baixar o pacote referente a seu sistema, faça a descompactação em uma pasta de facil acesso. 
- Para utilizar no exemplo aqui citado, abra o CMD na pasta raiz descompactada e execute o comando `ngrok http 80`
- Em seguida com o CMD aberto na pasta raiz do OpenShift CLI (oc) execute o comando para verificar o nome do seu pod `oc get pods`
- Com isto em mãos, execute o comando `òc port-forward-{nome pod} 80:80` que fará a exposição e encaminhamento da porta de dentro do pod minishift para o ngrok em seu localhost.
![ngrok com forward para expor porta 80](https://user-images.githubusercontent.com/53309633/86068757-8f24f200-ba4e-11ea-9b7e-b056578654c1.png)
- O NGROk criará um link aleatório que estará exposto à internet.



## Instância no GCP rodando imagem personalizada nos procedimentos citados:

[API GCP](http://35.192.197.96/api.json)

## Testado e desenvolvido por:

#### Thiago Azevedo

thiago7azevedo@gmail.com - [Docker HUB](https://hub.docker.com/repository/docker/thiago7sc)

