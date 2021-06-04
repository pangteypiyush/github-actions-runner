FROM myoung34/github-runner:latest

LABEL org.opencontainers.image.title=pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.url=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.source=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.description="Github Actions runner with its own Docker daemon"

ARG YARN_VERSION=1.22.10

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
  && curl -fsSLO --compressed "https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz \
  && ln -s /usr/bin/node /usr/local/bin/nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

COPY /entrypoint-wrapper.sh /
ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
