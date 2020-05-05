# terraform-gcp-helm//modules/jenkins

Jenkins module inherits from `terraform-gcp-helm` in order to deploy jenkins to kubernestes cluster. This module uses `terraform_remote_state` to query information from a target environment. The module will also create a `external static ip` in order to bind it to Jenkins instance. The following information are queried from remote project,

* project_id - target project 
* region - target project region
* zone - target project zone
* dns_name - a CloudDNS manged zone dns name
* vpc_private_subnet_self_link - a vpc private subnet link
* cluster_endpoint - target k8s cluster that Jenkins will deploy to
* cluster_ca_certificate - target k8s ca certificate for authentication

_note_: in order to access output values from other projects, they have to be defined at the root module.

## Usage

### To deploy Jenkins to project in terraform `sandbox workspace`,

    # first generate a terraform plan
    terraform -var workspace=services-host-dev -var kube_config_context=gke_services-host-dev-5babb4e8_us-west2_bde -var ip_address=10.0.16.32 -var skip_crds=true -var timeout=500 -out /tmp/k8s-jenkins.plan

    # then apply the plan
    terraform apply /tmp/k8s-jenkins.plan

### To destroy a Jenkins instance, add a `-destroy` flag to `terraform plan`

    # first generate a terraform plan
    terraform -var workspace=services-host-dev -var kube_config_context=gke_services-host-dev-5babb4e8_us-west2_bde -var ip_address=10.0.16.32 -var skip_crds=true -var timeout=500 -out /tmp/k8s-jenkins.plan

    # then apply the plan
    terraform apply /tmp/k8s-jenkins.plan

_Note:_ The above terraform command assumes the following

* a remote bucket `services-host-dev` exists
* a `gke_services-host-dev-5babb4e8_us-west2_bde` kubectl context exists

you can obtain kubernetes current context by running this command,

    kubectl config current-context

## Variables

|Name|Type|Default|Description|
|----|----|-------|-----------|
automic|type|bool|false|f set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false|
cleanup_on_fail|bool|false|Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false|
helm_chart|string|cloudbee-core|a helm chart this module try to install|
helm_repo_url|string|null|a helm repo url|
helm_repo|string|null|a helm repo|
ip_address|string|null|an ip address to create, the address has to a valid ip for a given vpc subnet range|
jenkins_version|string|null|Specify the exact chart version to install. If this is not specified, the latest version is installed|
kube_config_context|string|null|a kubectl context to set|
kube_config_context|string|null|a kubectl context to set|
namespace|string|bde-jenkins|a kubernetes namespace this chart will install to|
reset_values|bool|false|When upgrading, reset the values to the ones built into the chart. Defaults to false|
reuse_values|bool|false|When upgrading, reuse the last release's values and merge in any overrides. If 'reset_values' is specified, this is ignored. Defaults to false|
skip_crds|bool|false|(Optional) If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to false|
timeout|number|300|timeout value for chart installation, default 500s|
values|list|null|a list of custom chart value.yaml files|
workspace|string|services-host-dev|a terraform workspace name that host the target environment|
