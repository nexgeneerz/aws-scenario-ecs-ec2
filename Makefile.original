########################################################################################################################
## Change values to fit your setup
########################################################################################################################

## Service DNS name including subdomain, something like service.example.com. The TLD needs to be on AWS and you
## need to know the Hosted Zone ID.
export TF_VAR_domain_name = <ADD_SERVICE_DNS_NAME>

## Hosted Zone ID of the TLD domain of the service
export TF_VAR_tld_zone_id = <ADD_HOSTED_ZONE_ID>

## AWS_ACCESS_KEY_ID for the user that has permissions to create resources
export TF_VAR_aws_access_key_id = <ADD_AWS_ACCESS_KEY_ID>

## AWS_SECRET_ACCESS_KEY for the user that is used by Terraform
export TF_VAR_aws_secret_access_key = <ADD_AWS_SECRET_ACCESS_KEY>

## The public SSH key that is used to connect with your private key to the EC2 instances
export TF_VAR_public_ec2_key = <ADD_PUBLIC_SSH_KEY>

## Optional: default AWS region for all resources except the CloudFront certificate
export TF_VAR_region = eu-central-1

########################################################################################################################
## Predefined environment variables (DO NOT CHANGE)
########################################################################################################################

export TF_VAR_service_name = scenario-aws-ecs-ec2
export AWS_ACCESS_KEY_ID = $(TF_VAR_aws_access_key_id)
export AWS_SECRET_ACCESS_KEY = $(TF_VAR_aws_secret_access_key)
export AWS_DEFAULT_REGION = $(TF_VAR_region)

########################################################################################################################
## Terraform commands
########################################################################################################################

deploy: ## Deploy all infrastructure including a new ECS Task version (we simulate a versioning system here)
	$(eval HASH := $(shell openssl rand -hex 12))
	make init
	make plan hash=$(HASH)
	make apply
	$(eval REPOSITORY_URL := $(shell cd infra && terraform output -raw ecr_repository_url))
	make push hash=$(HASH) repository_url=$(REPOSITORY_URL)
	make info hash=$(HASH)


init: ## Run Terraform init
	cd infra && terraform init

plan: ## Run Terraform plan
	cd infra && terraform plan -var hash=$(hash) -out=infrastructure.tf.plan

apply: ## Run Terraform apply
	cd infra && terraform apply -auto-approve infrastructure.tf.plan
	rm -rf infra/infrastructure.tf.plan

destroy: ## Run Terraform destroy
	cd infra && terraform destroy -var hash=null -auto-approve

push: ## Push Docker application image
	$(eval BASE_URL := $(shell sed -r 's#([^/])/[^/].*#\1#' <<< $(repository_url)))
	aws ecr get-login-password --region eu-central-1 | \
		docker login --username AWS --password-stdin $(BASE_URL)
	docker build --platform linux/amd64 -t nexgeneerz/$(TF_VAR_service_name) app
	docker tag nexgeneerz/$(TF_VAR_service_name):latest $(repository_url):latest
	docker tag nexgeneerz/$(TF_VAR_service_name):latest $(repository_url):$(hash)
	docker push $(repository_url):latest
	docker push $(repository_url):$(hash)

info: ## Print success info message after deployment including latest ECS task version number
	$(info )
	$(info *************   DEPLOYMENT SUCCESSFUL   *************)
	$(info *                                                   *)
	$(info *     ECS Task version: $(hash)    *)
	$(info *                                                   *)
	$(info *****************************************************)
	$(info )

clean: ## Remove all generated Terraform files except state files
	rm -rf infra/.terraform
	rm -rf infra/.terraform.lock.hcl
	rm -rf infra/infrastructure.tf.plan
