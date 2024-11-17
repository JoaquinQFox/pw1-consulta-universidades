# Usa una imagen base con Apache y Perl
FROM httpd:2.4

# Instala Perl y módulos necesarios para CGI
RUN apt-get update && apt-get install -y \
    perl \
    libtext-csv-perl \
    && apt-get clean

# Configuración para habilitar CGI en Apache
RUN sed -i 's/#LoadModule cgi_module/LoadModule cgi_module/' /usr/local/apache2/conf/httpd.conf && \
    echo "ScriptAlias /cgi-bin/ /usr/local/apache2/cgi-bin/" >> /usr/local/apache2/conf/httpd.conf && \
    echo "<Directory \"/usr/local/apache2/cgi-bin\">\n    AllowOverride None\n    Options +ExecCGI\n    Require all granted\n</Directory>" >> /usr/local/apache2/conf/httpd.conf

# Copiar archivos HTML y CSS al directorio correspondiente
COPY html/index.html /usr/local/apache2/htdocs/
COPY css/style.css /usr/local/apache2/htdocs/css/

# Copiar scripts CGI y el archivo CSV
COPY cg-bin/* /usr/local/apache2/cgi-bin/

# Dar permisos de ejecución a los scripts CGI
RUN chmod +x /usr/local/apache2/cgi-bin/*.pl

# Exponer el puerto 80 para el servidor web
EXPOSE 80

# Comando por defecto para iniciar Apache
CMD ["httpd-foreground"]
