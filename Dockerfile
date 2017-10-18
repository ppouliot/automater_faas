FROM alpine

RUN apk add -Uuv --no-cache python3 \
    && apk upgrade -v --available --no-cache \
    && apk add ca-certificates git && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install requests certifi

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

RUN git clone https://github.com/JockDaRock/TekDefense-Automater

RUN cp -a TekDefense-Automater/. /root/

WORKDIR /root/

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY handler.py .

ENV fprocess="python3 handler.py"
ENV read_timeout="60"
ENV write_timeout="60"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
