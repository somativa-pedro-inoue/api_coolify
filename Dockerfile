# Usa uma imagem oficial do Python
FROM python:3.10-slim

# Instala dependências do sistema e o Poetry
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s ~/.local/bin/poetry /usr/local/bin/poetry

# Cria e define diretório de trabalho
WORKDIR /app

# Copia arquivos de dependência primeiro (melhor para cache)
COPY pyproject.toml poetry.lock* /app/

# Instala dependências com poetry no sistema (sem ambiente virtual)
RUN poetry config virtualenvs.create false && poetry install --no-dev --no-root

# Copia o restante da aplicação
COPY . /app

# Expõe a porta 8000 (padrão FastAPI/Uvicorn)
EXPOSE 8000

# Comando para iniciar o servidor FastAPI
CMD ["uvicorn", "app.fast_api:app", "--host", "0.0.0.0", "--port", "8000"]