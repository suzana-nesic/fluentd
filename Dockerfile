FROM fluent/fluentd:v1.7-1

USER root

RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-slack

USER fluent
