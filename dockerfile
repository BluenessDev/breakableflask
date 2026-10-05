FROM python:3.13-slim-trixie

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Crée un utilisateur non-root
RUN groupadd --system appgroup \
    && useradd --system --gid appgroup --create-home appuser

# On copie d'abord uniquement les dépendances
COPY requirements.txt .

# Mise à jour des outils Python + installation des dépendances
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir --upgrade -r requirements.txt

# Copie du code
COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
