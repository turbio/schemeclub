FROM alpine

# setup environment and install electrum
RUN set -xe && \
	adduser -S -h /home/electrum electrum && \
	mkdir /electrum && \
	chown electrum:nogroup /electrum && \
	apk add --no-cache python py-pip curl bash && \
	pip install https://download.electrum.org/2.7.12/Electrum-2.7.12.tar.gz

USER electrum
WORKDIR /home/electrum

# config electrum
RUN ln -fs /electrum /home/electrum/.electrum && \
	electrum setconfig rpcport 7777 && \
	electrum setconfig rpchost 0.0.0.0

CMD electrum daemon start | cat
