ARG DOCKER_IMAGE=python:3.11-buster
FROM $DOCKER_IMAGE

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["uwsgi", "app.ini"]
