FROM blang/latex:ubuntu

WORKDIR /app
COPY . /app

# Instalar tlmgr si no está y el paquete schemata
RUN tlmgr update --self \
    && tlmgr install schemata

# Copiar Python y dependencias
COPY requirements.txt /app/
RUN apt-get update && apt-get install -y python3 python3-pip \
    && pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD ["bash", "-lc", "exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 --timeout 180 convert:app"]
