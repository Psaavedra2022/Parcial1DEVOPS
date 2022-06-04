# Ejercicio Despliegue de una aplicación real utilizando Terraform 

Requisitos previos: 

Descargar repositorio de git.

Contar con instalación previa de:

* Ansible
* Doctl
* Visual Studio Code
* Terraform
* Cuenta activa en Digial Ocean

Es necesario generar un token desde Digital Ocean, este token que se genera, se copia y se pega en el archivo terraform.tfvars, en la linea 1 "do_token", despues de esto se genera el ID Key del droplet con el comando "doctl  -t [TOKEN] compute ssh-key list", esta información se copia y se pega en el archivo terraform.tfvars en la linea 3 "droplet_ssh_key_id"

Tambien es necesario generar una key desde nuestro servidor, el key publico se copia y se pega en nuestro Digital Ocean. 

- Para iniciar terraform, ejecutamos el comando "terraform init".

- Una vez ejecutado "terraform init", podemos crear un plan de ejecucion con el comando "terraform plan".

- Cuando ya se tenga creado el plan de ejecucion, estamos listos para aplicar los cambios que se indican en nuestro codigo, para este fin ejecutamos "terraform apply" en este se inicia la creacion de los servicios en Digital Ocean.

- En este punto nuestro despliegue de aplicacion esta finalizado y ya es funcional.  Para realizar esta validación, consultamos desde una pagina web la dirección ip  que nos muestra al finalizar la ejecución de terraform apply, que corresponde a una ip publica, nos mostrará la aplicacion instalada, en mi caso WordPress. (adjunto imagen)

- Para finalizar,  con el comando "terraform destroy", podemos destruir la infraestructura creada anteriormente.
 


# Ejercicio Clúster de Docker Swarm de Pruebas 

Requisitos previos: 

Descargar repositorio de git.

Contar con instalación previa de:
 * Vagrant
 * VMWare
 * Visual Studio Code

Paso 1: "vagrant up"

Se provisionaran, por medio de VMWare Desktop las maquinas virtuales.

Paso 2: "vagrant status"

Validamos la instalacion de las maquinas virtuales, ejecutando el comango "vagrant status". Lo cual nos devuelve lo siguiente:

# PS C:\Dock_Swarm> vagrant status
# Current machine states:

# admin                     running (virtualbox)
# user                      running (virtualbox)

Como podemos ver, las maquinas virtuales creadas con hostname "admin" y "user" se encuentran activas.

Paso 3: "vagrant ssh admin"

Nos conectamos por medio de ssh a la maquina virtual "admin" con el comando "vagrant ssh admin", password: vagrant

Paso 4: "docker version"

Para asegurarnos que docker esta instalado dentro de las maquinas virtuales, ejecutamos el comando "docker version", lo cual no devuelve la siguiente información:

# vagrant@admin ~ $ docker version
# Client:
#  Version:      1.12.1
#  API version:  1.24
#  Go version:   go1.6.3
#  Git commit:   23cf638
#  Built:        Thu Aug 18 05:22:43 2016
#  OS/Arch:      linux/amd64

# Server:
#  Version:      1.12.1
#  API version:  1.24
#  Go version:   go1.6.3
#  Git commit:   23cf638
#  Built:        Thu Aug 18 05:22:43 2016
#  OS/Arch:      linux/amd64
 
Paso 5: 

En este momento, no se tiene creado ningun cluster, podemos verificar esto ejectuando el comando "docker node ls"

# vagrant@admin ~ $ docker node ls
# Error response from daemon: This node is not a swarm manager. Use "docker swarm init" or "docker swarm join" # to connect this node to swarm and try again.

Como podemos observar, el mensaje que nos indica que no existe ningun nodo conectado a swarm.

Paso 6: "docker swarm init"

Creamos el cluster con el comando "docker swarm init --advertise-addr 172.16.1.10:2377" La ip es la indicada en el archivo Vafrantfile para el servidor hostname "admin"

Recibimos la siguiente respuesta: 

# vagrant@admin ~ $ docker swarm init --advertise-addr 172.16.1.10:2377
# Swarm initialized: current node (6c8788iscnd589hri5u0y3rj5) is now a manager.

# To add a worker to this swarm, run the following command:

#     docker swarm join \
#     --token SWMTKN-1-274q5mtkgaidkihuvdl9cm89o7zv0ilyi3adlwrwuqu1g9izko-cgaczwn5hhqfirbevl1jyc3qy \
#     172.16.1.10:2377

# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions. 

Paso 7: "vagrant ssh user"

Nos conectamos por medio de ssh a la maquina virtual "user" con el comando "vagrant ssh user", password: vagrant

Paso 8: Docker Swarm

Como podemos observar, en el paso 6 recibimos como respuesta un tocken que se generó, lo utilizaremos para realizar la union de el user hacia el custer.

Ejecutamos "docker swarm join --token SWMTKN-1-274q5mtkgaidkihuvdl9cm89o7zv0ilyi3adlwrwuqu1g9izko-cgaczwn5hhqfirbevl1jyc3qy \
172.16.1.10:2377"

recibimos el siguiente mensaje:

# vagrant@user ~ $ docker swarm join --token SWMTKN-1-274q5mtkgaidkihuvdl9cm89o7zv0ilyi3adlwrwuqu1g9izko-cgaczwn5hhqfirbevl1jyc3qy \
# > 172.16.1.10:2377
# This node joined a swarm as a worker.


Paso 9:

Salimos del servidor "user" y volvemos a conectarnos nuevamente via ssh hacia el servidor "admin"

Paso 10:

Ejecutamos nuevamente el comando "docker node ls", como podemos ver, en el paso 5 nos indica que no existe ningun nodo conectado a swarm, pero en este punto, al ejecutar nuevamente el mismo comando, recibimos el siguiente mensaje: 

# vagrant@admin ~ $ docker node ls
# ID                           HOSTNAME   STATUS  AVAILABILITY  MANAGER STATUS
# 6c8788iscnd589hri5u0y3rj5 *  localhost  Ready   Active        Leader
# af79onac6tgfwo90pwb01b1tt    localhost  Ready   Active

Como podemos observar, ya se encuentra un nodo conectado a swarm.


Paso 11: 100 PTS jaja