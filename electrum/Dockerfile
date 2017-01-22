FROM alpine

# setup environment and install electrum
RUN set -xe && \
	adduser -S -h /home/electrum electrum && \
	mkdir /electrum && \
	chown electrum:nogroup /electrum && \
	apk add --update --no-cache python py2-pip && \
	pip install https://download.electrum.org/2.7.17/Electrum-2.7.17.tar.gz

USER electrum
ADD ./data /electrum
WORKDIR /home/electrum

# config electrum
RUN ln -fs /electrum /home/electrum/.electrum && \
	electrum setconfig rpcport 7777 && \
	electrum setconfig rpchost 0.0.0.0

CMD electrum daemon start | cat
