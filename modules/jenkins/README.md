# terraform-gcp-helm//modules/jenkins

Jenkins module inherits from `terraform-gcp-helm` in order to deploy jenkins to kubernestes cluster. This module uses `terraform_remote_state` to query information from a target environment. The module will also create a `external static ip` in order to bind it to Jenkins instance. The following information are queried from remote project,

* project_id - target project 
* zone - target project zone
* cluster_endpoint - target k8s cluster that Jenkins will deploy to
* cluster_ca_certificate - target k8s ca certificate for authentication

_note_: in order to access output values from other projects, they have to be defined at the root module.

## Usage

To deploy Jenkins to project in terraform `sandbox workspace`,

    # first generate a terraform plan
    terraform plan -var workspace=sandbox -var kube_config_context=gke_sanbox-ae730045_us-west2_bde -out /tmp/k8s-jenkins.plan

    # then apply the plan
    terraform apply /tmp/k8s-jenkins.plan

To destroy a Jenkins instance, add a `-destroy` flag to `terraform plan`

    # first generate a terraform plan
    terraform plan -destroy -var workspace=sandbox -var kube_config_context=gke_sanbox-ae730045_us-west2_bde -out /tmp/k8s-jenkins.plan

    # then apply the plan
    terraform apply /tmp/k8s-jenkins.plan

## Variables

|Name|Type|Default|Description|
|----|----|-------|-----------|
helm_chart|string|cloudbee-core|a helm chart this module try to install|
namespace|string|bde-jenkins|a kubernetes namespace this chart will install to|
values|list|null|a list of custom chart value.yaml files|
timeout|number|300|timeout value for chart installation, default 500s|
reuse_values|bool|false|When upgrading, reuse the last release's values and merge in any overrides. If 'reset_values' is specified, this is ignored. Defaults to false|
reset_values|bool|false|When upgrading, reset the values to the ones built into the chart. Defaults to false|
cleanup_on_fail|bool|false|Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false|
automic|type|bool|false|f set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false|
jenkins_version|string|3.13.0+899a413a0e8f|Specify the exact chart version to install. If this is not specified, the latest version is installed|
workspace|string|services-host-dev|a terraform workspace name that host the target environment|
kube_config_context|string|null|a kubectl context to set|


## Submodules
A list of submodules developed based on this main one,

[jenkins](./modules/jenkins/README.md)
