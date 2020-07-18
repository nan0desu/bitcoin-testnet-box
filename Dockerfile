# bitcoin-testnet-box docker image

# Ubuntu 20.04 LTS (focal)
FROM ubuntu:20.04
LABEL maintainer="Nika Topolchanskaya <nanodesuu@gmail.com>"

# add bitcoind from the luke-jr PPA
# install bitcoind (from PPA) and make
RUN apt-get update && \
	apt-get install --yes software-properties-common && \
	add-apt-repository --yes ppa:luke-jr/bitcoincore && \
	apt-get update && \
	apt-get install --yes bitcoind make nano-tiny net-tools

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# copy the testnet-box files into the image
ADD . /home/tester/bitcoin-testnet-box

# make tester user own the bitcoin-testnet-box
RUN chown -R tester:tester /home/tester/bitcoin-testnet-box

# color PS1
RUN mv /home/tester/bitcoin-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/bitcoin-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
