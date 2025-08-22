FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-full \
        makeindex \
        ca-certificates \
        wget \
        perl \
    && rm -rf /var/lib/apt/lists/*

# Instalar schemata vía tlmgr en modo usuario
RUN tlmgr init-usertree && \
    tlmgr install schemata

WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/

EXPOSE 8000
CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]
