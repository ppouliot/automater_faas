FROM python:alpine

RUN apk update \
    && apk add git

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

WORKDIR /root/TekDefense-Automater

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY handler.py .

ENV fprocess="python handler.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
