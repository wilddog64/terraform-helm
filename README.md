# terraform-gcp-helm

This module a base module for developing any terraform module that will interface with [helm 3](https://helm.sh/blog/helm-3-released/) via [terraform helm provider](https://www.terraform.io/docs/providers/helm/index.html). As `helm` was designed to interact with `Kubernetes cluster`, these requirements have to be met

* [kubernetes cluster](https://redislabs.com/google/google-fully-managed-service/?utm_source=google&utm_medium=cpc&utm_term=google%20cloud%20kubernetes&utm_content=google-cloud-plus-redis&utm_campaign=search-gcm-plus-redis-all-na&gclid=Cj0KCQjw7qn1BRDqARIsAKMbHDbNQl5xS0iNA8Vnv2utoMf_6hKqk_5YLNoIOdG-ZQF6XCGORN34g9oaApz1EALw_wcB)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

The module use `google_client_config` to query access token from project's GKE cluster, and then use `kubernetes provider` to configure `helm provider`

In order to deploy a `helm chart`, one have to find the following information

## helm repository

In order to find a proper chart to deploy, first we have to query https://hub.helm.sh to find out the information for a give `chart` repo. Rning this oneliner can help,

    curl -s https://hub.helm.sh/api/chartsvc/v1/charts/search\?q=cloudbees | jq -r '.[][].attributes | { chart: .name, repo_name: .repo.name , repo_url: .repo.url }'

And you will get this output

    {
      "chart": "cloudbees-core",
      "repo_name": "cloudbees",
      "repo_url": "https://charts.cloudbees.com/public/cloudbees"
    }
    {
      "chart": "cloudbees-flow",
      "repo_name": "cloudbees",
      "repo_url": "https://charts.cloudbees.com/public/cloudbees"
    }
    ...

chart, repo_name, and repo_url are what you need in order to for the module to deploy any given `chart`

`terraform_gcp_helm` module `helm_repository` data source to query `hub.helm.sh` and download a chart you like to deploy

## namespace and release name
Different than helm 2, helm 3 does not support `kubernetes namespace`, but use `releaasename`. As a result, in this module we use `kubernetes_namespace` resource to create a proper namespace for a given `k8s` application

## overriding default settings

Generally speaking, it is often a good idea to provide a custom value to override default chart setting. `terraform_gcp_helm` module allows one to do by setting a value to `values` parameter.

## Usage

|name|type|default|description|
|----|----|-------|-----------|
|credential_file|string|null|an service account credential file
|region|string|string|us-west1|region of the project|
|zone|string|us-west1-a|a valid zone for a given region|
|gke_host_endpoint|string|null|The hostname (in form of URI) of Kubernetes master|
|gke_cluster_ca_certificate|null|null|PEM-encoded root certificates bundle for TLS authentication. Can be sourced from|
|helm_chart|string|null|a helm chart this module try to install|
|namespace|string|null|a kubernetes namespace this chart will install to|
|values|list|null|a list of custom chart value.yaml files|
|timeout|number|300|timeout value for chart installation, default 500s|

## Submodules
A list of submodules developed based on this main one,

[jenkins](./modules/jenkins/README.md)
