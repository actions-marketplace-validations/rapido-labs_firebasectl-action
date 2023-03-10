FROM alpine:latest
ARG FIREBASECTL_VERSION=1.0.1
COPY entrypoint.sh /
RUN apk add --no-cache ca-certificates jq curl && chmod +x /entrypoint.sh && wget https://github.com/rapido-labs/firebase-ctl/releases/download/v${FIREBASECTL_VERSION}/firebase-ctl_${FIREBASECTL_VERSION}_linux_x86_64.tar.gz && tar -xzf firebase-ctl_${FIREBASECTL_VERSION}_linux_x86_64.tar.gz -C /usr/bin && rm firebase-ctl_${FIREBASECTL_VERSION}_linux_x86_64.tar.gz
ENTRYPOINT [ "/entrypoint.sh" ]