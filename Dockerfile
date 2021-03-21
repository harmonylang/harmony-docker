FROM alpine:latest

COPY harmony-master /harmony

RUN apk update && \
    apk add python3 && \
    apk add gcc && \
    apk add musl-dev

RUN echo "assert True" > example.hny
RUN (cd /harmony && ./harmony ../example.hny && rm charm.json && chmod +x wrapper.sh)
RUN rm example.hny

FROM alpine:latest
RUN apk update && \
    apk add python3
COPY --from=0 /harmony /harmony
COPY --from=0 /root/.charm.exe /root/.charm.exe
