# Spinnaker Kustomize

Kustomize based installation method for Spinnaker as an alternative to
[https://github.com/spinnaker/halyard](halyard).
This repository was inspired by https://github.com/spinnaker/kustomization-base
and differs in the following ways:

1. Optimize for deployment of a basic Spinnaker installation with one command.
1. No Halyard, kleat or other tools for configuration. Use the services default
   configuration (eg: `clouddriver.yml`) and leverage Spring Profile's for
   customization (eg: `clouddriver-local.yml`).

### Prerequisites

Before you start, you will need:

- A Kubernetes cluster and `kubectl` configured to communicate with that
  cluster or for testing you can use the provided example `kind` cluster.

## Quick start

If required, start a local [https://kind.sigs.k8s.io/](KinD) cluster:

```
make create

# kind create cluster --name spinnaker --config kind.yml
```

Generate Kubernetes yaml:

```
make build

# kubectl kustomize -o ./spinnaker.yaml
```

Check what Kubernetes cluster are pointing to:

```
kubectl config current-context
```

Install Spinnaker into the cluster:

```
make apply

# kubectl apply -f ./spinnaker.yaml
```

## Production ready Spinnaker

Production workloads require higher reliability and peformance than the default
configuration enables.

For each of the following areas choose an alternative implementation or supply
your own settings as required.

### Configuration

You can find the default configuration file for each service in the services
git repository. Check out the branch related to the version you are running.
For release 1.27.0 check out branch `release-1.27.x`.

For Deck, see: https://github.com/spinnaker/deck/blob/master/halconfig/settings.js

For Java services, look in the `<service>-web/config` directory. For example:
https://github.com/spinnaker/clouddriver/blob/master/clouddriver-web/config/clouddriver.yml

The Java services leverage Spring Boot framework so some configuration is
defined via Spring Boot [common application properties](https://docs.spring.io/spring-boot/docs/2.2.13.RELEASE/reference/html/appendix-application-properties.html#common-application-properties).

Configuration sources merge per Spring Boot [external configuration](https://docs.spring.io/spring-boot/docs/2.2.13.RELEASE/reference/html/spring-boot-features.html#boot-features-external-config).

Note both of the above Spring Boot links are subject to change as Spinnaker
upgrades Spring Boot versions. See: [Spinnaker Dependency
Versions](https://github.com/spinnaker/kork/blob/master/spinnaker-dependencies/spinnaker-dependencies.gradle)

### Secrets

Secrets can be supplied in the following ways:

1. Environment variables, mounted via Kubernetes Secret
1. Files, mounted via Kubernetes Secret
1. [Secret Engines](https://spinnaker.io/docs/reference/halyard/secrets/#non-halyard-configuration)
   such as S3, GCS and potentially others.

### State management

Spinnaker supports a variety of backing data stores such as Redis and SQL.

The default `MariaDB` and `Redis` implementations will require changes to
support higher load and greater reliability.

Edit `./kustomize.yml` and comment out or delete:

```
- ./overlays/mariadb  # comment out or delete this line
- ./overlays/redis    # comment out or delete this line
```

Add your own overlay or edit an existing `./overlays/`:

```
- ./overlays/aws-aurora-mysql
- ./overlays/aws-elasticache-redis
- ./overlays/postgres
- ./overlays/redis-external
- /path/to/your/overlay
```

### Compute Resources

TODO:

- replica count
- anti-affinity
- resources.cpu|memory.limit|request
- JVM Xms & Xmx
