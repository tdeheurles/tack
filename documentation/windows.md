# Run on Windows

## Prerequisites
* [AWS Command Line Interface](http://aws.amazon.com/documentation/cli/)
* [CFSSL and CFSSLJSON](https://pkg.cfssl.org/)
* [jq](https://stedolan.github.io/jq/)
* [kubectl](http://kubernetes.io/v1.1/docs/user-guide/kubectl-overview.html)
  - Download [here](https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/windows/amd64/kubectl.exe) by updating the version in the url
* [Terraform](https://www.terraform.io/)
* [Make](http://gnuwin32.sourceforge.net/packages/make.htm)

All this tools must be accessible from the PATH

Tested with prerequisite versions:

```bash
$ aws --version
aws-cli/1.10.28 Python/2.7.9 Windows/7 botocore/1.4.19

$ cfssl version
Version: 1.2.0
Revision: dev
Runtime: go1.6

$ jq --version
jq-1.5rc2

$ kubectl.exe version
Client Version: version.Info{Major:"1", Minor:"2", GitVersion:"v1.2.4", GitCommit:"3eed1e3be6848b877ff80a93da3785d9034d0a4f", GitTreeState:"clean"}

$ terraform --version
Terraform v0.6.16
```
