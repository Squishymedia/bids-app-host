FROM docker:17.05.0-ce

COPY busybox /usr/src/busybox

RUN adduser -S abuild && \
    addgroup abuild abuild && \
    apk add --no-cache --update alpine-sdk linux-headers && \
    chown -R abuild:abuild /usr/src/busybox

USER abuild

RUN cd /usr/src/busybox && \
    abuild-keygen -a -i && \
    abuild -F

USER root

RUN apk add --no-cache --update --allow-untrusted /home/abuild/packages/src/x86_64/busybox-1.26.2-r4.apk && \
    apk del alpine-sdk && \
    rm -r /usr/src/busybox && \
    rm -r /home/abuild && \
    deluser abuild

RUN apk add --no-cache --update bash jq curl && \
  mkdir /snapshot && \
  mkdir /output

COPY run-bids-app.sh /usr/local/bin/run-bids-app.sh

CMD /usr/local/bin/run-bids-app.sh
