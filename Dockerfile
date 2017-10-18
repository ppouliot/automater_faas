FROM alpine

RUN apk add -Uuv --no-cache python3 \
    && apk upgrade -v --available --no-cache \
    && apk add ca-certificates && pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install requests certifi

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY handler.py .

ENV fprocess="python handler.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
