# Usar una imagen base de TeX Live completa y reciente
FROM texlive/texlive:latest

# Actualiza tlmgr
RUN tlmgr update --self

# Instala cada paquete de forma individual
RUN tlmgr install schemata
RUN tlmgr install songs
RUN tlmgr install imakeidx
RUN tlmgr install hyperref
RUN tlmgr install babel-spanish
RUN tlmgr install xcolor
RUN tlmgr install geometry
RUN tlmgr install pdfpages

# Copia los archivos de tu proyecto
COPY . /app

# Establece el directorio de trabajo
WORKDIR /app

# Comando de inicio de tu aplicación
CMD ["python", "app.py"]
