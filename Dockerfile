# --- Imagen base con TeX Live completo ---
FROM blang/latex:ubuntu

# --- Evitar prompts interactivos ---
ENV DEBIAN_FRONTEND=noninteractive

# --- Instalar Python 3 y pip ---
RUN apt-get update && \
    apt-get install -y python3 python3-pip ca-certificates wget perl && \
    rm -rf /var/lib/apt/lists/*

# --- Actualizar tlmgr y asegurar schemata ---
RUN tlmgr update --self && \
    tlmgr install schemata songs imakeidx hyperref babel-spanish xcolor geometry pdfpages

# --- Crear directorio de trabajo ---
WORKDIR /app

# --- Copiar dependencias Python e instalarlas ---
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

# --- Copiar el código de la app ---
COPY . /app/

# --- Exponer el puerto para Render ---
EXPOSE 8000

# --- Comando por defecto para ejecutar Gunicorn ---
CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]
