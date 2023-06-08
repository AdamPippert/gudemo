gudemo - a Grand Unified Demo environment for intelligent application and infrastructure automation

What is this, exactly?

This is a demo environment I built for my own personal use.  Today, this environment relies on a platform at Red Hat available for partners and employees that carves out a VPC in AWS and deploys an OpenShift cluster automatically.  This repo contains an Ansible collection that utilizes that pre-built environment and deploys the Ansible Automation Platform operator, an Ansible Automation Controller in the aap namespace, and an Ansible Automation Hub instance with S3 storage.  Future work on this project will include deploying Red Hat Open Data Science and Ansible Event Driven Automation (the EDA Controller component) as EDA becomes generally available.

Requirements:
- An OpenShift cluster provisioned on AWS
- an AWS access key and secret access key
- a top level Route53 domain

Pre-flight Tasks:
- create a flie called creds.yml that contains the following:

aws_access_key_id: <AWS_ACCESS_KEY_ID>
aws_secret_access_key: <AWS_SECRET_ACCESS_KEY>
tld: <top level route53 domain>
ocp_user: <administrator user for OpenShift cluster>
ocp_pass: <password for user listed above>

- run "ansible-vault encrypt creds.yml" with a vault password of your choice
- run the playbook with the command "ansible-playbook -i inventory initialize.yml --ask-vault-pass" and enter that vault password when prompted

initialize.yml will ensure the creds file exists, log into the cluster, and start up the AAP operator.

A Containerfile (in context/Containerfile) for building an Execution Environment specific to this demo setup is also in the repository.  The EE is also published publicly at quay.io/repository/adampippert/gudemo-ee for use in your own controller for demos.  It contains the following collections:

- awx.awx
- amazon.aws
- infra.aap_utilities
- infra.ee_utilities
- containers.podman 

NOTE: This is a work in progress, and highly unlikely that it will work for your specific scenario unless you work for Red Hat or an affiliated partner and have access to our internal platform.  This code MAY be used and modified as you see fit for your own deployments, but I will not work on pull requests that are not relevant to my own use cases.  Fork it and do it yourself.
