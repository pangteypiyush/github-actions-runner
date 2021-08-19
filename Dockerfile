FROM myoung34/github-runner:latest

LABEL org.opencontainers.image.title=pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.url=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.source=https://github.com/pangteypiyush/github-actions-runner
LABEL org.opencontainers.image.description="Github Actions runner with its own Docker daemon"

ARG YARN_VERSION=1.22.11
ARG GO_VERSION=1.17
ARG TERRAFROM_VERSION=1.0.5

RUN set -xe; apt-get update \
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
       libfontconfig1 \
       libfreetype6 \
       libltdl7 \
       libsnmp35 \
       libmagickwand-6.q16-6 \
       libmagickcore-6.q16-6 \
       imagemagick \
       liblcms2-2 \
       liblqr-1-0 \
       libfftw3-double3 \
  && ln -s /usr/bin/node /usr/local/bin/nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

ENV PATH=$PATH:/opt/yarn-v$YARN_VERSION/bin
RUN set -xe; wget -q "https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && rm yarn-v$YARN_VERSION.tar.gz \
  && yarn --version

ENV PATH=$PATH:/opt/go/bin
RUN set -xe; wget -q "https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz" \
  && tar -xzf go$GO_VERSION.linux-amd64.tar.gz -C /opt/ \
  && rm go$GO_VERSION.linux-amd64.tar.gz \
  && go version

RUN set -xe; wget -q "https://releases.hashicorp.com/terraform/$TERRAFROM_VERSION/terraform_${TERRAFROM_VERSION}_linux_amd64.zip" \
  && unzip terraform_${TERRAFROM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
  && rm terraform_${TERRAFROM_VERSION}_linux_amd64.zip \
  && terraform version

COPY /entrypoint-wrapper.sh /
ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
