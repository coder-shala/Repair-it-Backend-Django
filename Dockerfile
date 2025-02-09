FROM python:3.8-alpine3.13

LABEL maintainer="coder-shala"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

RUN python -m venv /ve && \
    /ve/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
    build-base postgresql-dev musl-dev && \
    /ve/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /vol/web/static/ && \
    mkdir -p /vol/web/media/ && \
    chown -R app:app /vol && \
    chmod -R 755 /vol


ENV PATH="/ve/bin:$PATH"

USER app