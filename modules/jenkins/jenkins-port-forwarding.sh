#!/usr/bin/env bash -
#===============================================================================
#
#          FILE: jenkins-port-forarding.sh
#
#         USAGE: ./jenkins-port-forarding.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/04/2020 18:34:46
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error
# gcloud container clusters get-credentials bde --region us-west2 --project services-host-dev-5babb4e8 \
# && kubectl port-forward --namespace bde-jenkins $(kubectl get pod --namespace bde-jenkins --selector="app.kubernetes.io/component=cjoc,com.cloudbees.cje.tenant=cjoc" --output jsonpath='{.items[0].metadata.name}') 8080:8080

# gcloud container clusters get-credentials bde --region us-west2 --project services-host-dev-5babb4e8 \
#  && kubectl port-forward --namespace bde-jenkins $(kubectl get pod --namespace bde-jenkins --selector="app.kubernetes.io/component=cloudbees-jenkins-distribution-master,app.kubernetes.io/instance=bde" --output jsonpath='{.items[0].metadata.name}') 8080:8080

gcloud container clusters get-credentials bde --region us-west2 --project services-host-dev-5babb4e8 \
 && kubectl port-forward --namespace bde-jenkins $(kubectl get pod --namespace bde-jenkins --selector="app.kubernetes.io/component=jenkins-master,app.kubernetes.io/instance=bde" --output jsonpath='{.items[0].metadata.name}') 8080:8080
