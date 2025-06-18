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

RUN mkdir -p /fluentd

WORKDIR /fluentd

COPY Gemfile .

RUN gem install bundler:2.4.22 && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install && \
    rm -rf /usr/share/gems/cache/*.gem /tmp/* /var/tmp/*

RUN touch /etc/fluent/fluent.conf

RUN useradd --create-home --shell /bin/bash fluent

USER fluent

CMD ["fluentd", "-c", "/etc/fluent/fluent.conf"]
