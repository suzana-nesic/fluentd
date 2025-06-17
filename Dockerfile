FROM registry.redhat.io/openshift-logging/fluentd-rhel9@sha256:a31038fa2b953660e09b7db8411e808075c9037b679ba56a4a6245f56853db56

USER root

RUN microdnf install -y \
    gcc \
    make \
    ncurses-base \
    ncurses-libs \
    redhat-rpm-config \
    ruby-devel \
    openssl \
    openssl-libs \
 && microdnf clean all

# skip installing documentation
RUN echo 'gem: --no-document' >> /etc/gemrc

RUN curl -L https://busybox.net/downloads/binaries/1.36.0-defconfig-multiarch/busybox-x86_64 \
    -o /usr/local/bin/busybox && \
    chmod +x /usr/local/bin/busybox && \
    ln -s /usr/local/bin/busybox /usr/local/bin/sh

RUN gem install \
    fluent-plugin-s3 \
    fluent-plugin-slack \
    fluent-plugin-cloudwatch-logs \
    fluent-plugin-teams \
    fluent-plugin-rewrite-tag-filter \
    nokogiri && \
    rm -rf /usr/share/gems/cache/*.gem /tmp/* /var/tmp/*
RUN touch /etc/fluent/configs.d/user/fluent.conf
RUN useradd --create-home --shell /bin/bash fluent
USER fluent
CMD ["fluentd", "-c", "/etc/fluent/configs.d/user/fluent.conf"]
