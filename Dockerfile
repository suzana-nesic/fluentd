FROM registry.redhat.io/openshift-logging/fluentd-rhel9@sha256:a31038fa2b953660e09b7db8411e808075c9037b679ba56a4a6245f56853db56

USER root

RUN microdnf install -y \
    gcc \
    make \
    redhat-rpm-config \
    ruby-devel \
    libffi-devel \
    zlib-devel \
 && microdnf clean all

# skip installing documentation
RUN echo 'gem: --no-document' >> /etc/gemrc

RUN gem install \
    fluent-plugin-s3 \
    fluent-plugin-slack \
    fluent-plugin-cloudwatch-logs \
    fluent-plugin-teams \
    fluent-plugin-rewrite-tag-filter \
    nokogiri && \
    rm -rf /usr/share/gems/cache/*.gem /tmp/* /var/tmp/*

USER fluent
