FROM ruby:2.7.4
# apt-getコマンドとは、Debian系のディストリビューション(DebianやUbuntsu)のパッケージ管理システムであるAPT(Advanced Package Tool)ライブラリを利用してパッケージを操作・管理するコマンド。
# apt-get update＝インストール可能なパッケージの一覧を更新する.
# オプションの-qqはエラー以外表示しないの意。
RUN  apt-get update -qq && apt-get install -y \
# nodejs=サーバサイドのJavaScript実行環境。
# Railsの一部をコンパイルする時にJavaScriptのランタイムが必要で、それを準備するための最適解がNodejsである。
        # nodejs \
# build-essential=開発に必須のビルドツールを提供しているパッケージ
# オプションの-yは問い合わせがあった場合は全て「y」と答える。
        build-essential \
        curl apt-transport-https wget

# RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
# yarnのインストール
# Yarnのレポジトリを有効化。レポジトリのGPGキーをcurlコマンドを使って取得する。
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
# yarnのAPTパッケージレポジトリを自分のシステムに追加する。teeコマンドを使って書き込み。
                echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
# レポジトリがシステムに加えられたらパッケージリストをアップデートしてから
# yarnをインストールする。
                apt-get update && apt-get install -y yarn
#aptキャッシュの削除
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /coffee_passport
ENV APP_ROOT /coffee_passport
WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
# gem(Rails6)のインストール
RUN bundle install
# 足りないファイルを確認してインストール
RUN  yarn install --check-files

ADD . $APP_ROOT

CMD ["rails", "server", "-b", "0.0.0.0"]
# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets