FROM mono:4.0.1

RUN apt-get -qq update && apt-get -qqy install unzip

# Install libuv for Kestrel from source code (binary is not in wheezy and one in jessie is still too old)
RUN apt-get -qqy install \
    autoconf \
    automake \
    build-essential \
    libtool
RUN LIBUV_VERSION=1.4.2 \
    && curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
    && cd /usr/local/src/libuv-$LIBUV_VERSION \
    && sh autogen.sh && ./configure && make && make install \
    && rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
    && ldconfig

RUN useradd -m -s /bin/bash aspnet

USER aspnet

ENV DNX_USER_HOME /home/aspnet/dnx
RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_USER_HOME=$DNX_USER_HOME sh

ENV DNX_VERSION 1.0.0-beta6-12100
RUN bash -c "source $DNX_USER_HOME/dnvm/dnvm.sh \
    && dnvm install -u $DNX_VERSION -a default \
    && dnvm alias default | xargs -i ln -s $DNX_USER_HOME/runtimes/{} $DNX_USER_HOME/runtimes/default"

ENV PATH $PATH:$DNX_USER_HOME/runtimes/default/bin
