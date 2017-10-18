FROM python:alpine

RUN apk update \
    && apk add git \
    && pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install requests

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

WORKDIR /root/TekDefense-Automater

COPY requirements.txt .
COPY handler.py .

ENV fprocess="python handler.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
