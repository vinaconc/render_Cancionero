# Utiliza una imagen base de TeX Live
FROM blang/latex:ubuntu

# Instala Python y pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Actualiza tlmgr
RUN tlmgr update --self

# Instala los paquetes de LaTeX
RUN tlmgr install schemata
RUN tlmgr install songs
RUN tlmgr install imakeidx
RUN tlmgr install hyperref
RUN tlmgr install babel-spanish
RUN tlmgr install xcolor
RUN tlmgr install geometry
RUN tlmgr install pdfpages

COPY . /app    

# Crear directorio de la app
WORKDIR /app

# Copiar dependencias de Python e instalarlas
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código y la plantilla
COPY convert.py plantilla.tex /app/

# Exponer el puerto (Render usará $PORT)
EXPOSE 8000

# Comando por defecto: usar gunicorn enlazado a $PORT
# convert:app es el módulo:objeto WSGI
CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]


