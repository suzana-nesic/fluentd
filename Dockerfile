FROM quay.io/app-sre/fluentd-upstream:v1.15-1

USER root

RUN apk add --no-cache --update --virtual .build-deps \
        build-base ruby-dev

RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-slack
RUN gem install fluent-plugin-cloudwatch-logs
RUN gem install fluent-plugin-teams
RUN gem install fluent-plugin-rewrite-tag-filter
RUN gem install nokogiri

RUN rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
    && apk del .build-deps

USER fluent
