FROM ubuntu:trusty

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8 && \
    dpkg-reconfigure locales
RUN apt-get update && apt-get install -qy wget curl build-essential inotify-tools
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    rm -f erlang-solutions_1.0_all.deb
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get update && apt-get install -y nodejs elixir git
RUN apt-get update && apt-get install -y mysql-client
RUN npm install -g elm@0.16.0
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
