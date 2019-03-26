FROM node:lts-alpine


RUN mkdir app
RUN chown -R node:node app


# Prepare the environment to install esy.
RUN apk add --no-cache \
		ca-certificates wget \
		bash curl perl-utils \
		git patch gcc g++ musl-dev make m4

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add glibc-2.29-r0.apk
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

USER node
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=/home/node/.npm-global/bin:$PATH

RUN npm i -g esy@latest

WORKDIR app

COPY ocaml-4.02.3.json ocaml-4.02.3.json
COPY ocaml-4.02.3.esy.lock ocaml-4.02.3.esy.lock
COPY ocaml-4.02.3._esyinstall ocaml-4.02.3._esyinstall

COPY ocaml-4.07.1.json ocaml-4.07.1.json
COPY ocaml-4.07.1.esy.lock ocaml-4.07.1.esy.lock
COPY ocaml-4.07.1._esyinstall ocaml-4.07.1._esyinstall

COPY build.sh build.sh

RUN bash build.sh

VOLUME /build
CMD sh -i
