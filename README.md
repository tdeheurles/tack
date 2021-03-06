# terraform-aws-coreos-kubernetes

[![Gitter](https://badges.gitter.im/kz8s/tack.svg)](https://gitter.im/kz8s/tack?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Circle CI](https://circleci.com/gh/kz8s/tack.svg?style=svg)](https://circleci.com/gh/kz8s/tack)

Opinionated Terraform module for creating a Highly Available Kubernetes cluster running on
CoreOS (any channel) in an AWS VPC. With prerequisites installed `make all` will simply spin up a default cluster; and, since it is based on Terraform, customization is much easier
than Cloud Formation.

The default configuration includes Kubernetes addons: DNS, Dashboard and UI.

## tl;dr
```bash
# prereqs
$ brew update && brew install awscli cfssl jq kubernetes-cli terraform

# build artifacts and deploy cluster
$ make all

# nodes
$ kubectl get nodes

# addons
$ kubectl get pods --namespace=kube-system

# verify dns - run after addons have fully loaded
$ kubectl exec busybox -- nslookup kubernetes

# open dashboard
$ make dashboard

# obliterate the cluster and all artifacts
$ make clean
```

## Features
* TLS certificate generation

### AWS
* EC2 Key Pair creation
* AWS VPC Public and Private subnets
* IAM protected S3 bucket for asset (TLS and manifests) distribution
* Bastion Host
* Multi-AZ Auto-Scaling Worker Nodes
* [NAT Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html)

### CoreOS (899.17.0)
* etcd DNS Discovery Bootstrap

### Kubernetes (v1.2.4)
* [Highly Available ApiServer Configuration](http://kubernetes.io/v1.1/docs/admin/high-availability.html)
* Service accounts enabled
* SkyDNS utilizing cluster's etcd

### Terraform (v0.6.16)
* CoreOS AMI sourcing
* Terraform Pattern Modules

## Prerequisites
* [AWS Command Line Interface](http://aws.amazon.com/documentation/cli/)
* [CFSSL: CloudFlare's PKI and TLS toolkit](https://cfssl.org/)
* [jq](https://stedolan.github.io/jq/)
* [kubectl](http://kubernetes.io/v1.1/docs/user-guide/kubectl-overview.html)
* [Terraform](https://www.terraform.io/)

Quick install prerequisites on Mac OS X with [Homebrew](http://brew.sh/):

```bash
$ brew update && brew install awscli cfssl jq kubernetes-cli terraform
```

Tested with prerequisite versions:

```bash
$ aws --version
aws-cli/1.10.26 Python/2.7.10 Darwin/15.4.0 botocore/1.4.15

$ cfssl version
Version: 1.2.0
Revision: dev
Runtime: go1.6

$ jq --version
jq-1.5

$ kubectl version --client
Client Version: version.Info{Major:"1", Minor:"2", GitVersion:"v1.2.4+3eed1e3", GitCommit:"3eed1e3be6848b877ff80a93da3785d9034d0a4f", GitTreeState:"not a git tree"}

$ terraform --version
Terraform v0.6.16
```

## Launch Cluster

`make all` will create:
- AWS Key Pair (PEM file)
- client and server TLS assets
- s3 bucket for TLS assets (secured by IAM roles for master and worker nodes)
- AWS VPC with private and public subnets
- Route 53 internal zone for VPC
- Etcd cluster bootstrapped from Route 53
- High Availability Kubernetes configuration (masters running on etcd nodes)
- Autoscaling worker node group across subnets in selected region
- kube-system namespace and addons: DNS, UI, Dashboard

```bash
$ make all
```

To open dashboard:

```bash
$ make dashboard
```

To destroy, remove and generally undo everything:

```
$ make clean
```

`make all` and `make clean` should be idempotent - should an error occur simply try running
the command again and things should recover from that point.

## How Tack works

### Tack Phases

Tack works in three phases:

1. Pre-Terraform
2. Terraform
3. Post-Terraform

#### Pre-Terraform
The purpose of this phase is to prep the environment for Terraform execution. Some tasks are
hard or messy to do in Terraform - a little prep work can go a long way here. Determining
the CoreOS AMI for a given region, channel and VM Type for instance is easy enough to do
with a simple shell script.

#### Terraform
Terraform does the heavy lifting of resource creation and sequencing. Tack uses local
modules to partition the work in a logical way. Although it is of course possible to do all
of the Terraform work in a single `.tf` file or collection of `.tf` files, it becomes
unwieldy quickly and impossible to debug. Breaking the work into local modules makes the
flow much easier to follow and provides the basis for composing variable solutions down the track - for example converting the worker Auto Scaling Group to use spot instances.

#### Post-Terraform
Once the infrastructure has been configured and instantiated it will take some type for it
to settle. Waiting for the 'master' ELB to become healthy is an example of this.  

### Components

Like many great tools, _tack_ has started out as a collection of scripts, makefiles and other tools. As _tack_ matures and patterns crystalize it will evolve to a Terraform plugin and perhaps a Go-based cli tool for 'init-ing' new cluster configurations. The tooling will compose Terraform modules into a solution based on user preferences - think `npm init` or better yet [yeoman](http://yeoman.io/).

#### ElasticSearch and Kibana

To access Elasticseach and Kibana first start `kubectl proxy`.

```bash
$ kubectl proxy
Starting to serve on localhost:8001
```

* http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging  * http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/kibana-logging

## Inspiration
* [Code examples to create CoreOS cluster on AWS with Terraform](https://github.com/xuwang/aws-terraform) by [xuwang](https://github.com/xuwang)
* [kaws: tool for deploying multiple Kubernetes clusters](https://github.com/InQuicker/kaws)
* [Kubernetes on CoreOS](https://github.com/coreos/coreos-kubernetes)
* [Terraform Infrastructure Design Patterns](https://www.opencredo.com/2015/09/14/terraform-infrastructure-design-patterns/) by [Bart Spaans](https://www.opencredo.com/author/bart/)
* [The infrastructure that runs Brandform](https://github.com/brandfolder/infrastructure)

## Other Terraform Projects
* [bakins/kubernetes-coreos-terraform](https://github.com/bakins/kubernetes-coreos-terraform)
* [bobtfish/terraform-aws-coreos-kubernates-cluster](https://github.com/bobtfish/terraform-aws-coreos-kubernates-cluster)
* [chiefy/tf-aws-kubernetes](https://github.com/chiefy/tf-aws-kubernetes)
* [cihangir/terraform-aws-kubernetes](https://github.com/cihangir/terraform-aws-kubernetes)
* [ericandrewlewis/kubernetes-via-terraform](https://github.com/ericandrewlewis/kubernetes-via-terraform)
* [funkymonkeymonk/terraform-demo](https://github.com/funkymonkeymonk/terraform-demo)
* [samsung-cnct/kraken](https://github.com/samsung-cnct/kraken)
* [wearemakery/kubestack-aws](https://github.com/wearemakery/kubestack-aws)
* [xuwang/aws-terraform](https://github.com/xuwang/aws-terraform)

## References
* [CFSSL: CloudFlare's PKI and TLS toolkit](https://cfssl.org/)
* [etcd dns discovery bootstrap](https://coreos.com/etcd/docs/latest/clustering.html#dns-discovery)
* [Generate EC2 Key Pair](https://github.com/xuwang/aws-terraform/blob/master/scripts/aws-keypair.sh)
* [Makefile `help` target](https://gist.github.com/rcmachado/af3db315e31383502660)
* [Self documenting Makefile](https://gist.github.com/prwhite/8168133)
* [ssl artifact generation](https://github.com/coreos/coreos-kubernetes/tree/master/lib)
