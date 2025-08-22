# --- Imagen base con Python ---
FROM python:3.11-slim

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# --- Instalar LaTeX y dependencias necesarias ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-lang-spanish \
        texlive-music \
        texlive-humanities \
        texlive-schemata \
        makeindex \
        ca-certificates \
        wget \
        perl \
    && rm -rf /var/lib/apt/lists/*

# --- Crear directorio de trabajo ---
WORKDIR /app

# --- Copiar dependencias de Python ---
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# --- Copiar el código y plantilla ---
COPY . /app/

# --- Exponer puerto para Render ---
EXPOSE 8000

# --- Comando por defecto para Gunicorn ---
CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]
