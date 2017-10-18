FROM alpine

RUN apk add -Uuv --no-cache python3 \
    && apk upgrade -v --available --no-cache \
    && apk add ca-certificates && pip3 install --no-cache-dir --upgrade pip3 setuptools wheel \
    && pip3 install requests certifi

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY handler.py .

ENV fprocess="python3 handler.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
