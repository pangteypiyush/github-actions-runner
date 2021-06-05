FROM myoung34/github-runner:latest

LABEL org.opencontainers.image.title=pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.url=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.source=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.description="Github Actions runner with its own Docker daemon"

ARG YARN_VERSION=1.22.10
ARG GO_VERSION=1.16.5

RUN apt-get update \
  && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y --no-install-recommends \
       fuse-overlayfs \
       nodejs \
       eslint \
       gcc \
       g++ \
       make \
       zip \
       gnupg \
       libicu-dev \
       autoconf \
       automake \
  && ln -s /usr/bin/node /usr/local/bin/nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

RUN wget -q "https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && rm yarn-v$YARN_VERSION.tar.gz
ENV PATH=$PATH:/opt/yarn-v$YARN_VERSION/bin

RUN wget -q "https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz" \
  && tar -xzf go$GO_VERSION.linux-amd64.tar.gz -C /opt/ \
  && rm go$GO_VERSION.linux-amd64.tar.gz
ENV PATH=$PATH:/opt/go/bin

COPY /entrypoint-wrapper.sh /
ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
