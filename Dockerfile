# Base image - Python 3.11 slim version (smaller size, production-ready)
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Install system dependencies needed for PostgreSQL adapter
# postgresql-dev: headers needed to compile psycopg2
# gcc: compiler for building Python packages
RUN apt-get update && apt-get install -y \
    postgresql-client \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (Docker caches layers - if requirements don't change, this layer is reused)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port 5000 (Flask default)
EXPOSE 5000

# Command to run when container starts
CMD ["python", "run.py"]
