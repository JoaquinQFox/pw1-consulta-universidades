FROM debian:latest

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl cpanminus && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cpanm Text::Unidecode

# Crear usuario y carpeta para pweb con permisos adecuados
RUN mkdir -p /home/pweb
RUN useradd pweb -m && echo "pweb:12345678" | chpasswd
RUN echo "root:12345678" | chpasswd
RUN chown pweb:www-data /usr/lib/cgi-bin/
RUN chown pweb:www-data /var/www/html/
RUN chmod 750 /usr/lib/cgi-bin/
RUN chmod 750 /var/www/html/


# Crear enlaces simbólicos para facilitar el acceso
RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin && \
    ln -s /var/www/html/ /home/pweb/html && \
    ln -s /home/pweb /usr/lib/cgi-bin/toHOME && \
    ln -s /home/pweb /var/www/html/toHOME

# Habilitar el módulo CGI y copiar archivos necesarios
RUN a2enmod cgid
RUN service apache2 restart

COPY ./cgi-bin/lab06.pl /usr/lib/cgi-bin
COPY ./cgi-bin/Universidades_Lab06.csv /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin/lab06.pl

COPY ./html/index.html /var/www/html

COPY ./css/ /var/www/html/css

# Modificar configuración de SSH para evitar problemas con login

# Exponer puertos y comando de inicio
EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
