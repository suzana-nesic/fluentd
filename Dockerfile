FROM quay.io/app-sre/fluentd-upstream:v1.15-1

USER root

RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-slack
RUN gem install fluent-plugin-cloudwatch-logs
RUN gem install fluent-plugin-teams

USER fluent
