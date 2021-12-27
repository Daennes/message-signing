FROM rust:1.57
ARG NPM_TOKEN
ARG TARGET

WORKDIR /app

COPY ./rust .
COPY ./README.md .

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

RUN sed -i 's/{PACKAGE_NAME}/daennes-emurgo-message-signing-'"$TARGET"'/' Cargo.toml

RUN wasm-pack build --target="$TARGET"

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash && apt-get install -y nodejs

RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" >> ~/.npmrc

RUN cd pkg/ && npm publish
