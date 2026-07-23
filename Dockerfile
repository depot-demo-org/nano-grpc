FROM node:24

ARG TARGETARCH
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.51 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${TARGETARCH} && \
    chmod +x /bin/grpc_health_probe

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --non-interactive --production && yarn cache clean

COPY proto proto
COPY src src
COPY index.js .

USER node

EXPOSE 50051
CMD ["node", "index.js"]
