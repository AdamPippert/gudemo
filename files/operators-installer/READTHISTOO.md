This operator installer helm chart comes from: https://github.com/redhat-cop/helm-charts.

This operator installer is used to install the following operators:

- OpenShift Data Foundations (required for Ansible Automation Platform's Automation Hub feature)
- Red Hat OpenShift Data Science (a.k.a. OpenShift AI)

The ArgoCD installation is handled separately due to technical issues with the way ArgoCD handles health checks, see the source repo for more details.
