FROM python:alpine

RUN apk update \
    && apk add git

ADD https://github.com/alexellis/faas/releases/download/0.9.11/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY handler.py ./TekDefense-Automater/handler.py
WORKDIR /root//TekDefense-Automater

ENV fprocess="python handler.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
