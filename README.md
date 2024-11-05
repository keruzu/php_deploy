# Example CodeDeploy IaC

Caveats:
This is NOT for production use.
* There are hardcoded secrets
* Configuration should be managed in SSM Parameter Store or other areas
* No KMS controls (what????)
* No logging / monitoring of deploy

# Terraform Infrastructure Deployment
To deploy the infrastructure into an AWS account, assumes the following:
1. AWS account already created
1. Admin user with access key/secret acess key created
1. SSH key called `external_access` available in the account (adjustable via Terraform variable)
1. The `aws` CLI tool is installed

To create the infrastructure:
```shell
git clone git@github.com:keruzu/php_deploy.git
cd php_deploy/terraform
aws configure 
# add in your credentials here
terraform init
make
```

This will deploy a load balancer, two EC2 instances, IAM roles, and CodeDeploy infrastructure.

To remove everything:
```shell
cd php_deploy/terraform
make rm
```

# GitHub Actions
In the GitHub console, clone the repo (eg `github.com:keruzu/php_deploy.git`) so that you can
adjust secrets etc.

## Update Secrets
To update the secrets from your AWS account:
1. Click on `Settings` -> `Secrets and variables` -> `Actions`
1. Add your AWS credential information into variables called `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

## Clone onto your system
```shell
git clone git@github.com:xxxx/php_deploy.git
cd php_deploy
```
## Deploy changes
```
# Create your changes
git commit -m "My change" -a
git push
```

## View Deployment in GitHub
To view the ongoing deployment, click on the GitHub `Actions` menu and click on the deployment.

## View Deployment in AWS
To view the ongoing deployment, click on the Code Deploy console, click on the `demo-deployment-group` deployment group,
and then click on the latest deployment.


