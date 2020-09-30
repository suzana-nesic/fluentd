FROM quay.io/app-sre/fluentd-upstream:v1.7-1

USER root

RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-slack
RUN gem install fluent-plugin-cloudwatch-logs

USER fluent
