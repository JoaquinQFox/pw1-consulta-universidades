# Nombre: Joaquin Alejandro Quispe Bedregal

# Pasos para construir y ejecutar el proyecto en Docker

1. Construir la imagen 
   docker build -f Dockerfile -t ibusquedauni . 

2. Crear contenedor
   docker run -d -p 8088:80 --name cbusquedauni ibusquedauni

3. Acceder al proyecto 
  http://127.0.0.1:8088
