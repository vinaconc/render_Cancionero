# --- Imagen base con Python ---
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# --- Instala dependencias de LaTeX y utilidades ---
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
        makeindex \
        ca-certificates \
        wget \
        perl \
    && rm -rf /var/lib/apt/lists/*

# --- Instala schemata usando tlmgr ---
RUN wget -qO- https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz -C /tmp && \
    tlmgr init-usertree && \
    tlmgr update --self && \
    tlmgr install schemata

# --- Configura directorio de trabajo ---
WORKDIR /app
COPY . /app

# --- Instala dependencias de Python ---
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# --- Exponer puerto para Render ---
EXPOSE 8000

# --- Comando por defecto para Gunicorn ---
CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]
