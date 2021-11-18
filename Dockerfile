FROM alpine:latest
COPY entrypoint.sh /
RUN apk add --no-cache ca-certificates jq curl && chmod +x /entrypoint.sh && wget https://github.com/rapido-labs/firebase-ctl/releases/download/v0.1.0/firebase-ctl_0.1.0_linux_x86_64.tar.gz && tar -xzf firebase-ctl_0.1.0_linux_x86_64.tar.gz -C /usr/bin && rm firebase-ctl_0.1.0_linux_x86_64.tar.gz
ENTRYPOINT [ "/entrypoint.sh" ]