# Consul App Upgrade Demo

This code creates a demonstration environment to show the usage of Consul service mesh with an application upgrade. 

## 1. Prerequisite
- Any Kubernetes infra
    - The GKE provisioning contained in this repository is not required.
- kubectl cli

## 2. Setup
- Procedurally review the contents of `commands' in the hashicups directory.
- Vault configuration is optional. But if not configured, v2 payments-api throws an error.

