FROM debian:trixie-20261104-slim AS opencode
ARG OPENCODE_VERSION=2.4.1
ARG HOST_UID=1000
ARG HOST_GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential ca-certificates clang clang-format clang-tidy clangd libclang-rt-dev llvm \
        strace elfutils libasan8 libssl-dev bison \
        cmake curl gdb git ninja-build pkg-config ripgrep valgrind \
        ccache cppcheck gcovr hyperfine jq shellcheck yamllint \
        libbenchmark-dev libcatch2-dev libgmock-dev libgtest-dev libboost-all-dev \
        libopencv-dev protobuf-compiler libprotobuf-dev nanopb libnanopb-dev \
        qt6-base-dev qt6-declarative-dev qt6-declarative-dev-tools \
        qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools fonts-dejavu-core \
        qt6-websockets-dev qt6-serialport-dev qt6-serialbus-dev \
        python3 python3-venv python3-pip python3-pytest python3-numpy black mypy \
        python3-opencv python3-protobuf \
        gdb-multiarch \
    && rm -rf /var/lib/apt/lists/*

ENV CMAKE_C_COMPILER_LAUNCHER=ccache \
    CMAKE_CXX_COMPILER_LAUNCHER=ccache \
    QT_QPA_PLATFORM=offscreen \
    LANG=C.UTF-8

RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" \
        > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce-cli \
        docker-compose-plugin \
        docker-buildx-plugin \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-linux-x64.tar.gz /tmp/opencode.tar.gz
RUN tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode \
    && rm /tmp/opencode.tar.gz

RUN groupadd -g ${HOST_GID} dev \
    && useradd -m -u ${HOST_UID} -g dev -s /bin/bash dev \
    && mkdir /workspace \
    && chown dev:dev /workspace

USER dev
WORKDIR /workspace

EXPOSE 4096

CMD ["opencode", "serve", "--service", "--hostname", "0.0.0.0", "--port", "4096"]


FROM opencode AS code-server

ARG CODE_SERVER_VERSION=4.145.2
ARG CODELLDB_VERSION=1.12.3

USER root

ADD https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb /tmp/code-server.deb
RUN dpkg -i /tmp/code-server.deb && rm /tmp/code-server.deb \
    && install -d -o dev -g dev /opt/code-server/extensions

USER dev

RUN curl -fsSL -o /tmp/codelldb.vsix https://github.com/vadimcn/codelldb/releases/download/v${CODELLDB_VERSION}/codelldb-linux-x64.vsix \
    && code-server --extensions-dir /opt/code-server/extensions \
        --install-extension /tmp/codelldb.vsix \
        --install-extension llvm-vs-code-extensions.vscode-clangd@0.6.0 \
        --install-extension ms-vscode.cmake-tools@1.25.10 \
        --install-extension ms-azuretools.vscode-containers@2.4.5 \
        --install-extension theqtcompany.qt-core@1.17.1 \
        --install-extension theqtcompany.qt-qml@1.17.1 \
    && rm -rf /tmp/codelldb.vsix ~/.local/share/code-server ~/.config/code-server

COPY --chown=dev:dev code-server/settings.json /home/dev/.local/share/code-server/User/settings.json

EXPOSE 8443

CMD ["code-server", "--bind-addr", "0.0.0.0:8443", "--extensions-dir", "/opt/code-server/extensions", \
     "--disable-telemetry", "--disable-update-check", "/workspace"]


FROM node:22.23.5-trixie-slim AS node

FROM opencode AS compiler-explorer

ARG COMPILER_EXPLORER_VERSION=gh-20403

USER root

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
RUN apt-get update && apt-get install -y --no-install-recommends file rsync && rm -rf /var/lib/apt/lists/* \
    && ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && install -d -o dev -g dev /opt/compiler-explorer

USER dev
WORKDIR /opt/compiler-explorer
RUN git clone -q --depth 1 --branch ${COMPILER_EXPLORER_VERSION} https://github.com/compiler-explorer/compiler-explorer.git . \
    && CYPRESS_INSTALL_BINARY=0 make prebuild \
    && npm prune --omit=dev \
    && rm -rf ~/.npm ~/.cache
COPY --chown=dev:dev compiler-explorer/c++.local.properties compiler-explorer/c.local.properties etc/config/

ENV NODE_ENV=production

EXPOSE 10240

CMD ["node", "out/dist/app.js", "--static", "out/webpack/static", "--language", "c++", "c"]
