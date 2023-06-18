#!/bin/bash

# Ubuntu OS

## make sure rust is latest stable version 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

## install dependencies and tools
sudo apt update \
&& sudo apt install -y --no-install-recommends \
    curl \
    git-all \
    cmake \
    gcc \
    libssl-dev \
    pkg-config \
    libclang-dev \
    libpq-dev \
    build-essential \
    tzdata \
    ca-certificates \
    openssl \
    libprotobuf-dev \
    protobuf-compiler \
    clang 

## get git repository sui
sudo mkdir -p /data
sudo chown -R ubuntu:ubuntu /data
cd /data
git clone https://github.com/MystenLabs/sui.git
cd /data/sui
git checkout mainnet

## setting up mainnet sui full node
cp crates/sui-config/data/fullnode-template.yaml fullnode.yaml
curl -fLJO https://github.com/MystenLabs/sui-genesis/raw/main/mainnet/genesis.blob
cat <<EOF >> fullnode.yaml
p2p-config:
  seed-peers:
    - address: /dns/icn-00.mainnet.sui.io/udp/8084
      peer-id: 303f1f35afc9a6f82f8d21724f44e1245f4d8eca0806713a07c525dadda95a66
    - address: /dns/icn-01.mainnet.sui.io/udp/8084
      peer-id: cb7ce193cf7a41e9cc2f99e65dd1487b6314a57c74be42cc8c9225b203301812
    - address: /dns/mel-00.mainnet.sui.io/udp/8084
      peer-id: d32b55bdf1737ec415df8c88b3bf91e194b59ee3127e3f38ea46fd88ba2e7849
    - address: /dns/mel-01.mainnet.sui.io/udp/8084
      peer-id: bbf3be337fc16614a1953da83db729abfdc40596e197f36fe408574f7c9b780e
    - address: /dns/ewr-00.mainnet.sui.io/udp/8084
      peer-id: c7bf6cb93ca8fdda655c47ebb85ace28e6931464564332bf63e27e90199c50ee
    - address: /dns/ewr-01.mainnet.sui.io/udp/8084
      peer-id: 3227f8a05f0faa1a197c075d31135a366a1c6f3d4872cb8af66c14dea3e0eb66
    - address: /dns/sjc-00.mainnet.sui.io/udp/8084
      peer-id: 6f0b25087cd6b2fd2e4329bcf308ac95a37c49277dd7286b72470c124809db5b
    - address: /dns/sjc-01.mainnet.sui.io/udp/8084
      peer-id: af1d5d8468b3612ac2b6ff3ca91e99a71390dbe5b83dea9f6ae2da708d689227
    - address: /dns/lhr-00.mainnet.sui.io/udp/8084
      peer-id: c619a5e0f8f36eac45118c1f8bda28f0f508e2839042781f1d4a9818043f732c
    - address: /dns/lhr-01.mainnet.sui.io/udp/8084
      peer-id: 53dcedf250f73b1ec83250614498947db00d17c0181020fcdb7b6db12afbc175
EOF

# starting services
cargo run --release --bin sui-node -- --config-path fullnode.yaml

