# FROM quay.io/app-sre/fluentd-upstream:v1.16-1
FROM registry.access.redhat.com/ubi9/ruby-33@sha256:187a53898774e040b9719d14212143441ba1070fec346700591a7f4f55291aff

USER root

RUN mkdir -p /fluentd

WORKDIR /fluentd

COPY Gemfile .

# Install required system packages and build dependencies
RUN dnf update -y && \
    dnf install -y \
      gcc \
      make \
      redhat-rpm-config \
      ruby-devel \
      glibc-langpack-en \
      openssl-devel \
      ncurses-libs \
      which \
      git \
      libxml2-devel \
      libxslt-devel && \
    gem install bundler:2.4.22 && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN mkdir -p /etc/fluent /etc/fluent/log /etc/fluent/etc
# WORKDIR /etc/fluent

RUN touch /etc/fluent/fluent.conf
RUN useradd --create-home --shell /bin/bash fluent

USER fluent
CMD ["bundle", "exec", "fluentd", "-c", "/etc/fluent/fluent.conf"]
