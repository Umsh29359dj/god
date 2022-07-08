FROM 412314/mltb:heroku

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -y update && apt-get install -y wget 

RUN apt -qq install -y --no-install-recommends mediainfo
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/Jitendra7007/gdrive

RUN curl -L https://github.com/jaskaranSM/drivedlgo/releases/download/1.5/drivedlgo_1.5_Linux_x86_64.gz -o drivedl.gz && \
    7z x drivedl.gz && mv drivedlgo /usr/bin/drivedl && chmod +x /usr/bin/drivedl && rm drivedl.gz && \
    extra-api https://dl.dropboxusercontent.com/s/do9pw2ctzecj5ch/drivedl.zip && 7z x drivedl.zip && rm drivedl.zip

RUN wget -P /usr/src/app/.gdrive/ https://raw.githubusercontent.com/bowchaw/mkoin/bond2/.gdrive/token_v2.json && \
    wget https://dl.dropboxusercontent.com/s/5ud5ulrgxcplapv/splrc.zip && 7z x splrc.zip && rm splrc.zip && \
    wget -P /usr/local/bin/ https://raw.githubusercontent.com/bowchaw/mltb3/h-code/gup && chmod +x /usr/local/bin/gup && \
    wget -P /usr/local/bin/ https://raw.githubusercontent.com/bowchaw/mltb3/h-code/g && chmod +x /usr/local/bin/g && \
    wget -P /usr/local/bin/ https://raw.githubusercontent.com/hex-313/jdhhf/main/lrc && chmod +x /usr/local/bin/lrc
#PSA unofficial telegram channel bypass script
RUN echo "aWYgWyAkMSBdCnRoZW4KcHl0aG9uMyAtYyAiZXhlYyhcImltcG9ydCByZXF1ZXN0cyBhcyBycSxz\neXNcbmZyb20gYmFzZTY0IGltcG9ydCBiNjRkZWNvZGUgYXMgZFxucz1ycS5nZXQoc3lzLmFyZ3Zb\nMV0pLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXVxuZm9yIGkgaW4gcmFuZ2UoMyk6IHM9ZChz\nKVxucHJpbnQoJ2h0dHAnK3MuZGVjb2RlKCkucnNwbGl0KCdodHRwJywxKVsxXSlcIikiICQxCmVs\nc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/psa;chmod +x /usr/bin/psa
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip install vcsi
CMD ["bash", "start.sh"]
