# Nombre: Joaquin Alejandro Quispe Bedregal

Este proyecto lo hicimos en grupo en nuestro laboratorio, por eso es algo diferente, pero no terminaron funcionando algunas cosas, por lo que tuve que arreglar la lógica para presentarlo y que ahora si funcione, busca y devulve los datos de forma correcta en una tabla, el único problema es que no lee palabras con tilde, un problema que no llegue a solucionar.

# Pasos para construir y ejecutar el proyecto en Docker

1. Construir la imagen 
   docker build -f Dockerfile -t ibusquedauni . 

2. Crear contenedor
   docker run -d -p 8088:80 --name cbusquedauni ibusquedauni

3. Acceder al proyecto 
  http://127.0.0.1:8088
