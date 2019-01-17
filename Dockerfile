FROM fluent/fluentd:v1.3-1

USER root

RUN gem install fluent-plugin-s3

USER fluent
