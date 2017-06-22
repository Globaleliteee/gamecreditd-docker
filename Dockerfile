FROM quay.io/kwiksand/cryptocoin-base:latest

ENV GAMECOIN_DATA=/home/gamecredits/.gamecredits

RUN useradd -m gamecredits

USER gamecredits

RUN cd /home/gamecredits && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone https://github.com/gamecredits-project/GameCredits gamecreditsd && \
    cd /home/gamecredits/gamecreditsd && \
    git checkout tags/0.9.4.4 && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/gamecredits/db4/lib/" CPPFLAGS="-I/home/gamecredits//db4/include/" && \
    sed -i 's/const CScriptID&/CScriptID/g' src\/rpcrawtransaction.cpp && \
    make && \
    cd src && \
    strip gamecreditsd
    
EXPOSE 40001 40002

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/gamecredits/gamecreditsd/src/gamecreditsd /usr/bin/gamecreditsd && chmod 755 /usr/bin/gamecreditsd

ENTRYPOINT ["/entrypoint.sh"]

CMD ["gamecreditsd"]
