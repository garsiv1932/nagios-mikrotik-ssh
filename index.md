## Nagios vs Mikrotik?

Para monitorear equipos Mikrotik tenemos las opciones de SNMP o API. En Linux SNMP puede ser monitoreado desde bash mediante la instalación y configuración del daeamon SNMP, pero hay algunas cuestiones que los OIDS no pueden resolver (o al menos yo no encontre) y API enfrenta el problema de que debe ser implementado por lenguajes de programación como PHP, Python, NodeJS,etc y no todos  los sysadmins saben programar en los mencionados lenguajes.
Para resolver esta brecha hay una solución, que es correr comandos en la consola de RouterOS directamente desde nuestro servidor de monitoreo Nagios. Para esto tendremos que generar un usuario que se conectara mediante SSH solamente desde nuestro servidor y mediante un certificado pre compartido único. 

(*) Este manual esta basado en un servidor con DEBIAN.
Primero deberemos generar la siguiente ruta de directorios /home/nagios/.ssh/ . Esto es debido a que el cliente SSH por defecto genera un arachivo known_hosts en el cual se guardan las claves RSA.


### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
sudo mkdir -p /home/nagios/.ssh/

ssh-keygen -t rsa -b 2048 -v
sudo chown -R nagios:nagios /home/nagios/
```

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/garsiv1932/nagios-mikrotik-ssh/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
