FROM node:16-slim

ENV APP_HOME /coffee_passport
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update

COPY  package.json .
RUN yarn install

