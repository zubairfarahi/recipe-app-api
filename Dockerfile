FROM python:3.10-slim
LABEL maintainer="zfarahi.dev"

ENV PYTHONUNBUFFERD 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

COPY ./app /app
WORKDIR /app

EXPOSE 8002

RUN apt update && apt install -y --no-install-recommends bash
RUN apt update && apt install -y --no-install-recommends \
    gcc \
    build-essential \
    musl-dev \
    python3-dev \
    libffi-dev \
    libssl-dev \
    libpcre3-dev \
    uwsgi-plugin-python3

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get install -y --no-install-recommends postgresql-client gcc python3-dev libpq-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

        
ENV PATH="/py/bin:${PATH}"

USER django-user


