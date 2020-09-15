## Nagios vs Mikrotik?

Para monitorear equipos Mikrotik tenemos las opciones de SNMP o API. En Linux SNMP puede ser monitoreado desde bash mediante la instalación y configuración del daeamon SNMP, pero hay algunas cuestiones que los OIDS no pueden resolver (o al menos yo no encontre) y API enfrenta el problema de que debe ser implementado por lenguajes de programación como PHP, Python, NodeJS,etc y no todos  los sysadmins saben programar en los mencionados lenguajes.
Para resolver esta brecha hay una solución, que es correr comandos en la consola de RouterOS directamente desde nuestro servidor de monitoreo Nagios. Para esto tendremos que generar un usuario que se conectara mediante SSH solamente desde nuestro servidor y mediante un certificado pre compartido único. 

(*) Este manual esta basado en un servidor con DEBIAN.

# En el Servidor

Primero deberemos generar la siguiente ruta de directorios /home/nagios/.ssh/ . Esto es debido a que el cliente SSH por defecto genera un arachivo known_hosts en el cual se guardan las claves RSA.

```markdown
sudo mkdir -p /home/nagios/.ssh/
```
Posteriormente, parados en el directorio antes creado, generaremos un certificado en el servidor con los siguientes comandos en el directorio.

```markdown
ssh-keygen -t rsa -b 2048 -v
sudo chown -R nagios:nagios /home/nagios/
```

Esto generara dos archivos un id_rsa.pub y un id_rsa sin extension el cual deberemos renombrar a id_resa.pem.
El archivo mas importante en todo esto es el .pub, el cual deberemos copiar a nuestro equipo Mikrotik. Para esto nos conectaremos por FTP:

```markdown
ftp 192.168.1.10   
put id_rsa.pub
bye
```

# En el Mikrotik

Posteriormente nos conectaremos a nuestro Mikrotik y crearemos:
###### Un grupo
![Success](https://github.com/garsiv1932/nagios-mikrotik-ssh/blob/master/grupo.jpg?raw=true)

###### Un usuario
![Success](https://github.com/garsiv1932/nagios-mikrotik-ssh/blob/master/usuario.jpg?raw=true)

(*) Por seguridad restringimos el acceso de este usuario a conecciones provenientes solo desde el servidor.



# En el Servidor

Y por ultimo le asignamos a este usuario el certificado que se encargara de la autenticacion:

```markdown
user ssh-keys import public-key-file=id_rsa.pub user=nagios
```

Una vez hecho esto ya tenemos todo configurado para hacer las configuraciones en Nagios para monitoreear este router mediante SSH y comandos nativos de Mikrotik.

```markdown
sudo nano /usr/local/nagios/etc/nrpe.cfg
command[check_nagios_firmware]=/usr/local/nagios/libexec/check_Mikrotik_OS.sh -H 192.168.1.10 -C
```

```markdown
define service{
        use			generic-service
        host_name		Server
        service_description	Router Update
        contact_groups		admins
        check_command	check_nrpe!check_nagios_firmware
}
```

Por ultimo nos queda provocar la primer coneccion al servidor desde el usuario nagios para que se cree el archivo known_hosts:

```markdown
sudo su
su nagios
/usr/local/nagios/libexec/check_Mikrotik_OS.sh -H 192.168.1.10 -U nagios -C
```

El script admite las siguientes banderas:

```markdown
-U: Nombre de usuario en el router nagios habilitado para lanzar comandos.
-C: Cual es el mensaje que queremos que reciba en caso de firmware desactualizado, por defecto es CRITICAL.
-H: Direccion IP del servidor. 
```

## REFERENCIAS
