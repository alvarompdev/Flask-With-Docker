# Usar una imagen base de Python ligera (3.10 o superior)
# Se indica la imagen base sobre la que se construye la iamgen; la imagen base es de Python ligera (versión 3.10)
FROM python:3.10-slim

# Establece el directorio /app como el directorio de trabajo
# Todas las acciones siguientes (COPY, RUN, etc) se van a ejecutar dentro de este directorio; si no existe, Docker lo creará
WORKDIR /app

# Copia el archivo 'requirements.txt' desde el contexto build (mi máquina) al directorio /app dentro del contenedor
COPY requirements.txt .

# Ejecuta el pip install para instalar todos los paquetes necesarios para poder ejecutar la aplicación python
RUN pip install -r requirements.txt

# Copiar el resto de la aplicación (incluye app.py y la carpeta templates/, static/)
# Copia todo lo que esté en la carpeta 'web' de tu PC (ORIGEN, representado por .) 
# al directorio de trabajo '/app' del contenedor (DESTINO, representado por .)
COPY . .

# Flask por defecto escucha en el puerto 5000 
EXPOSE 5000

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]