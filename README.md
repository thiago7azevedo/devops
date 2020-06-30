
# Bem vindos a instância beta do NGINX com docker compose. Instalação e configuração de instância minishift para rodar imagem personalizada!

* [Início](#Início)
* [Nginx](#Nginx)
* [Docker](#Docker)
* [Build](#Build)
* [Minishift](#Minishift)
* [Hyper-v](#Hyper-v)
* [Instancia-Minishift](#Instancia-Minishift)
* [SCC](#SCC)
* [OC](#OC)
* [NGROK](#NGROK)
* [Freenom](#Freenom)
* [SCC](#SCC)

### Início

- Objetivo:
		
	- Criar imagem personalizada NGINX com docker;
	- Disponibilizar de forma estática um arquivo Json através do servidor NGINX exportando através da porta 80;
	- Instalar e configurar instância Minishift para rodar nossa imagem personalizada em docker;
	- Acessar endpoint de qualquer local da internet e efetuar a leitura do arquivo em formato Json.

### Nginx

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
   
### Docker

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
`docker-compose up -d`

### Verificar logs:
`docker-compose logs -f`

### Chamada endpoint:
Verificar em seu navegador com localhost/api.json a saida a seguir:

`{"service": {"oracle": "ok", "redis": "ok", "mongo": "down", "pgsql": "down", "mysql": "ok"}}`

### Imagens da construção da imagem:
![conf d](https://user-images.githubusercontent.com/53309633/86056723-4102f500-ba34-11ea-94b6-3ca676c927f1.png)
![build](https://user-images.githubusercontent.com/53309633/86056736-45c7a900-ba34-11ea-900c-d0c7efdf80b2.png)
![up](https://user-images.githubusercontent.com/53309633/86056732-44967c00-ba34-11ea-8d32-33731e2b8451.png)


## Minishift

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

### Hyper-v

## Instalação Minishift e Hyper-V:

- Um dos pré requisitos para rodar o Minishift, é a instalação de um driver de virtualização, neste caso utilizei o Hyper-V, assistente de virtualização de maquinas nativo do Windows
![hyper-v](https://user-images.githubusercontent.com/53309633/86075387-45dc9e80-ba5e-11ea-9b86-35b06cd98e43.png)

- Abrir o CMD ou Terminal e acessar a pasta do Minishift que foi descompactada
- Na raíz desta pasta descompactada, efetuar o comando `minishift start` e aguardar a configuração e inicialização
![minishift start](https://user-images.githubusercontent.com/53309633/86075392-46753500-ba5e-11ea-9d7e-edfbe6fc3360.png)
![iniciando minishift windows](https://user-images.githubusercontent.com/53309633/86068773-94823c80-ba4e-11ea-87de-616a38342bb6.png)
![minishift up windows1](https://user-images.githubusercontent.com/53309633/86068742-8a603e00-ba4e-11ea-8f77-6da8a03e8e37.png)

- Se tudo ocorrer bem, conforme seguido até aqui, mostrará na tela a `OpenShift server Starter` e estará pronto para configuração via console
![minishift up windows](https://user-images.githubusercontent.com/53309633/86068758-90561f00-ba4e-11ea-840a-fa26f95a07bf.png)

- O Ip e porta para acesso ao console estará no log de inicialização, será algo assim: `https://172.17.59.62:8443/console`
- Login e senha já vem pré configurado para admin:admin ou developer:developer

![criação projeto dentro do minishift](https://user-images.githubusercontent.com/53309633/86068759-91874c00-ba4e-11ea-9ce4-82c98845de2d.png)


#### OBS: A configuração inicial de acesso, projeto, deploy e rotas será feito via painel console. Outra forma de configurar é via OpenShift CLI (oc), por linha de comando. Este link [Aqui](https://docs.openshift.com/container-platform/4.4/cli_reference/openshift_cli/getting-started-cli.html) possui as isntruções de instalação nos diversos sistemas. O download da ferramenta para windows está [aqui](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-windows.zip).

### Instancia-Minishift

## Configuração isntância Minishift:

- Após acesso ao console, é necessário criar um projeto novo em branco
- Após o projeto criado, vamos fazer um deploy da imagem personalizada criada anteriormemente, que estará hospedada no [DockerHUb](https://hub.docker.com/repository/docker/thiago7sc/nginx).
![deploy imagem personalizada](https://user-images.githubusercontent.com/53309633/86068768-93510f80-ba4e-11ea-96e9-da016a06884f.png)
![imagem_deploy](https://user-images.githubusercontent.com/53309633/86075388-45dc9e80-ba5e-11ea-88b9-7a81f831411b.png)

- Assim que a imagem é configurada atarvés do image name thiago7sc/nginx:alpine, o POD será criado automaticamente e estará rodando em seguida.
![primeiro deploy](https://user-images.githubusercontent.com/53309633/86075396-47a66200-ba5e-11ea-8b09-d1c58d325acb.png)

- Após isto, é necessário criar a rota externa para o endpoint de sua aplicação, conforme configuração de porta efetuada no docker compose da imagem.
![route](https://user-images.githubusercontent.com/53309633/86075397-47a66200-ba5e-11ea-9b98-2a8ed3f921ff.png)
![rota externa criada ](https://user-images.githubusercontent.com/53309633/86068750-8cc29800-ba4e-11ea-88b1-3ac97648a7af.png)

### SCC

## IMPORTANTE:
 #### Com restrições de contexto de segurança (SCCs)
- Algumas imagens de banco e serviços precisam rodar com root devido as restrições de segurança, por isso é necessário configurar o SCC para seu pod.
- Siga para a psta que descompactou a sua OpenShift CLI (oc) e abra um terminal ali. Digite os comandos oc todos na raíz desta pasta.

## Erro de contexto de segurança

- Caso ocorra o erro de contexto de segurança, abrirá o POD com este erro
![pod error inicial](https://user-images.githubusercontent.com/53309633/86075395-470dcb80-ba5e-11ea-96c9-52834213e28e.png)

- Pela linha de comando após um `oc status` mostrará `crash-looping` 
![looping_credenciais](https://user-images.githubusercontent.com/53309633/86075391-46753500-ba5e-11ea-89ec-03d728328415.png)


## Comandos OC

# OC

`oc status`
Verifica o status do ambiente que voce está conectado

`oc project {seuprojeto}`
Adiciona acesso ao projeto que voce escolher da lista 

`oc get pods`
Efetua leitura do status do pod que você acabou de criar

`oc get scc` 
Lista todos os contextos de segurança pré-configurados
![login e status pod e projeto](https://user-images.githubusercontent.com/53309633/86068731-86342080-ba4e-11ea-9c4c-9c4f5352787f.png)

`oc adm policy add-scc-to-user anyuid -z default`
Este comando coloca seu pod no contexto correto para rodar o POD.
![anyuid](https://user-images.githubusercontent.com/53309633/86075375-4412db00-ba5e-11ea-8f87-f5c4d7fdedb1.png)
 
 - É necessário agora refazer o deploy do seu projeto, onde estará rodando sem erros.
 ![deploy](https://user-images.githubusercontent.com/53309633/86075381-44ab7180-ba5e-11ea-8b7a-1805b5f42d7d.png)
 ![deploy completo e imagem rodando](https://user-images.githubusercontent.com/53309633/86068763-92b87900-ba4e-11ea-95db-25bf3895d3c4.png)
 ![pod rodando](https://user-images.githubusercontent.com/53309633/86068727-83393000-ba4e-11ea-93a4-003f3b6eade5.png)
 
 - Podemos escalar vários PODs de forma muito simples, clicando na seta pra cima ou remover pods com a seta para baixo
 ![escalando pod pos depoloy](https://user-images.githubusercontent.com/53309633/86075386-45440800-ba5e-11ea-9699-da00a12e6b85.png)
 ![3 pods](https://user-images.githubusercontent.com/53309633/86075372-42e1ae00-ba5e-11ea-8daa-857c2611cb0d.png)
 
 - Imagem do comando completo
 ![completo](https://user-images.githubusercontent.com/53309633/86075378-44ab7180-ba5e-11ea-9b74-47a579efac37.png)

 - Rota externa criada pelo Minishift 
 ![serviço estático gerado pela imagem nginx em uma instancia minishift](https://user-images.githubusercontent.com/53309633/86068746-8b916b00-ba4e-11ea-9aba-51ad5c7a4540.png)
 
 - Monitoramento 
 ![monitoramento](https://user-images.githubusercontent.com/53309633/86075394-470dcb80-ba5e-11ea-94dc-964f4e180c62.png)

 
 # BONUS 1:
 ### NGROK

### Configuração ngrok para exposição de seu endpoint para a internet:

- O link gerado pela instância minishift tem acesso somente em seu localhost. Se voce precisar utilizar de forma paliativa a exposição para a internet de suas aplicações, poderá utilziar o app [NGROK](dashboard.ngrok.com/get-started/setup).
![download ngrok](https://user-images.githubusercontent.com/53309633/86068754-8df3c500-ba4e-11ea-9297-f39c6d80600d.png)

- Após baixar o pacote referente a seu sistema, faça a descompactação em uma pasta de facil acesso. 
- Para utilizar no exemplo aqui citado, abra o CMD na pasta raiz descompactada e execute o comando `ngrok http 80`
- Em seguida com o CMD aberto na pasta raiz do OpenShift CLI (oc) execute o comando para verificar o nome do seu pod `oc get pods`
- Com isto em mãos, execute o comando `òc port-forward-{nome pod} 80:80` que fará a exposição e encaminhamento da porta de dentro do pod minishift para o ngrok em seu localhost.
![ngrok com forward para expor porta 80](https://user-images.githubusercontent.com/53309633/86068757-8f24f200-ba4e-11ea-9b7e-b056578654c1.png)

- O NGROk criará um link aleatório que estará exposto à internet.
![image](https://user-images.githubusercontent.com/53309633/86076690-e5029580-ba60-11ea-848a-9ef25307fa40.png)

# BONUS 2:
### Freenom

### Registro de um domínio free em Freenom

##### OBS: O plano free do NGROK libera a conexão somente por 8 horas.

- Para expor um domínio próprio e gratuito, segue esta dica que achei na internet, [Freenom](https://my.freenom.com/domains.php)
- Digite um domínio e veja o que está disponível e registre seu domínio
![freenom1](https://user-images.githubusercontent.com/53309633/86071117-d0200500-ba54-11ea-813e-cd9020a1de9f.png)

- Após registrado, vá até a aba Services/My Domains/Manange Domain/Management Tools/URL Forwarding
- cadastre o link aleatório gerado pelo NGROK
![freenom](https://user-images.githubusercontent.com/53309633/86071118-d1513200-ba54-11ea-990f-cf81b7064287.png)

# Suainstância Minishift já está na internet
![appsdevops](https://user-images.githubusercontent.com/53309633/86075377-4412db00-ba5e-11ea-9ba9-931b935572cd.png)


# Espero poder ajudar quem estiver com dúvidas ou esteja começando no mundo devops como eu! Fico à disposição.

### Testado e desenvolvido por - Thiago Azevedo
Florianópolis - SC - thiago7azevedo@gmail.com - [Docker HUB](https://hub.docker.com/repository/docker/thiago7sc)

