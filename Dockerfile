FROM ubuntu:bionic

MAINTAINER ts24@sanger.ac.uk

ENV   BASHRC      /etc/bash.bashrc
ENV   BUILD_DIR   /gffmunger-build
ENV   CONF_DIR    /etc/gffmunger

RUN   apt-get update -qq
RUN   apt-get install -y genometools git python3 python-setuptools python3-biopython python3-pip

# RUN   pip3 install dumper gffutils pyyaml

RUN   grep GENOMETOOLS_PATH ${BASHRC} || bash -c "echo; echo 'export GENOMETOOLS_PATH=\"/usr/bin/gt\"'; echo" >> ${BASHRC}

COPY  . ${BUILD_DIR}

COPY  ./*config.yml  ${CONF_DIR}/

RUN   pip3 install ${BUILD_DIR} && \
      bash -c "cd ${BUILD_DIR} && . ./run_tests.sh --verbose"

RUN   bash -c "echo; echo 'alias gffmunger=\"gffmunger --config ${CONF_DIR}/gffmunger-config.yml\"'; echo" >> ${BASHRC}

VOLUME /var/data

CMD   echo "Usage:  docker run -v \`pwd\`:/var/data -it <IMAGE_NAME> bash" && \
      echo "" && \
      echo "This will place you in a shell with your current working directory accessible as /var/data." && \
      echo "For help, type" && \
      echo "  gffmunger --help"