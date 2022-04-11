# Spinnaker local dev Makefile

# Make defaults
SHELL := /usr/bin/env bash -o errexit -o nounset -o pipefail -c
all: help

.PHONY: create
create: ## Create KinD cluster
	kind create cluster --name spinnaker --config kind.yml

.PHONY: build
build: ## Build Kubernetes configuration via kustomize
	kubectl kustomize -o spinnaker.yaml

.PHONY: apply
apply: ## Apply Kubernetes configuration via kustomize
	kubectl apply -k .

.PHONY: delete
delete: ## Delete KinD cluster
	kind delete cluster --name spinnaker

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


