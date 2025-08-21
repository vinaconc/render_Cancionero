# Imagen base ligera con Python
FROM python:3.11-slim

# Evitar prompts interactivos de APT
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias de LaTeX necesarias (incluye songs, schemata, hyperref, imakeidx, babel spanish), pdflatex y makeindex
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-binaries \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-lang-spanish \
        texlive-music \
        texlive-humanities \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

FROM texlive/texlive:latest

# Instalar paquete schemata de TeX Live
RUN tlmgr update --self && \
    tlmgr install schemata

WORKDIR /app
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

