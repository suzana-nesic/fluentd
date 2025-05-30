FROM registry.access.redhat.com/ubi8/ubi

USER root

RUN dnf -y module enable ruby:3.1 && \
    dnf -y install \
        ruby \
        ruby-devel \
        gcc \
        make \
        ncurses-base \
        ncurses-libs \
        openssl \
        openssl-libs \
        && echo 'gem: --no-document' >> /etc/gemrc

RUN curl -L https://busybox.net/downloads/binaries/1.36.0-defconfig-multiarch/busybox-x86_64 \
    -o /usr/local/bin/busybox && \
    chmod +x /usr/local/bin/busybox && \
    ln -s /usr/local/bin/busybox /usr/local/bin/sh

# Install Fluentd and plugins
RUN gem install fluentd \
    fluent-plugin-s3 \
    fluent-plugin-slack \
    fluent-plugin-cloudwatch-logs \
    fluent-plugin-teams \
    fluent-plugin-rewrite-tag-filter \
    nokogiri

# Optional cleanup to reduce image size
RUN dnf remove -y \
        gcc \
        make \
        ruby-devel \
    && dnf clean all \
    && rm -rf /root/.gem /tmp/* /var/tmp/* /var/cache/*

RUN mkdir -p /fluentd/log /fluentd/etc
USER fluent
