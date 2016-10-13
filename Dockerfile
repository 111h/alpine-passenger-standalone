FROM ruby:alpine

ARG PACKAGES="build-base linux-headers gcc abuild binutils ca-certificates cmake procps pcre-dev curl-dev libressl-dev libexecinfo-dev git nodejs pkgconf"
ENV APP_PATH /usr/src/app

ENV PATH="/opt/passenger/bin:$PATH"

RUN mkdir -p /opt/passenger
COPY passenger /opt/passenger

RUN echo '' > /etc/apk/repositories && \
		echo 'http://mirror.yandex.ru/mirrors/alpine/edge/main/' >> /etc/apk/repositories && \
		echo 'http://mirror.yandex.ru/mirrors/alpine/edge/testing/' >> /etc/apk/repositories 

# default packages
RUN apk --no-cache add $PACKAGES

#app dir
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

######################################### example rack app
RUN gem install rack
COPY config.ru /usr/src/app/

CMD ["passenger", "start", "--no-install-runtime", "--no-compile-runtime"]
EXPOSE 3000
