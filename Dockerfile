FROM alpine:latest

COPY harmony-master /harmony

RUN apk update && \
    apk add python3 && \
    apk add gcc && \
    apk add musl-dev

RUN (cd /harmony && python3 install.py && chmod +x wrapper.sh)
RUN (cd /harmony && ./wrapper.sh code/Diners.hny)
RUN (cd /harmony && rm -rf code archive.xml charm.c code python install.py)

FROM alpine:latest
RUN apk update && \
    apk add python3
COPY --from=0 /harmony /harmony
