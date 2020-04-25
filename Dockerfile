FROM python:3.7-alpine as base

From base as builder

RUN apk add gcc musl-dev python3-dev

RUN mkdir /install
WORKDIR /install

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install pip requirements
COPY requirements.txt /requirements.txt
RUN pip install --install-option="--prefix=/install" -r /requirements.txt

FROM base

EXPOSE 5001

COPY --from=builder /install /usr/local
COPY src /app
WORKDIR /app

ENTRYPOINT [ "python" ]

CMD [ "main.py" ]
