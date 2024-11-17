FROM bitnami/minideb

ENV DEBIAN_FRONTEND="noninteractive"

# Consolidar la instalación de paquetes y eliminar listas de apt después de la instalación
RUN apt-get update && \
    apt-get install -y apache2 perl openssh-server systemctl vim bash locales tree libcgi-pm-perl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurar locales para español (Perú)
RUN echo -e 'LANG=es_PE.UTF-8\nLC_ALL=es_PE.UTF-8' > /etc/default/locale && \
    sed -i 's/^# *\(es_PE.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen es_PE.UTF-8

# Crear usuario y carpeta para pweb con permisos adecuados
RUN mkdir -p /home/pweb && \
    useradd pweb -m && echo "pweb:12345678" | chpasswd && \
    echo "root:12345678" | chpasswd && \
    chown -R pweb:www-data /usr/lib/cgi-bin /var/www/html && \
    chmod 750 /usr/lib/cgi-bin /var/www/html

# Configuración de variables de entorno en el bashrc de pweb
RUN echo "export LC_ALL=es_PE.UTF-8" >> /home/pweb/.bashrc && \
    echo "export LANG=es_PE.UTF-8" >> /home/pweb/.bashrc && \
    echo "export LANGUAGE=es_PE.UTF-8" >> /home/pweb/.bashrc

# Crear enlaces simbólicos para facilitar el acceso
RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin && \
    ln -s /var/www/html/ /home/pweb/html && \
    ln -s /home/pweb /usr/lib/cgi-bin/toHOME && \
    ln -s /home/pweb /var/www/html/toHOME

# Habilitar el módulo CGI y copiar archivos necesarios
RUN a2enmod cgid

COPY ./cgi-bin/lab06.pl /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin/lab06.pl

COPY ./html/index.html /var/www/html

RUN mkdir -p /var/www/html/css
COPY ./css/style.css /var/www/html/css/
RUN chown -R pweb:www-data /var/www/html/css && chmod -R 755 /var/www/html/css

# Modificar configuración de SSH para evitar problemas con login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Exponer puertos y comando de inicio
EXPOSE 80 22

CMD ["bash", "-c", "service ssh start && apachectl -D FOREGROUND"]
