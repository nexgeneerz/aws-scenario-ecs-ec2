$(eval $(shell test -f .env  || touch .env))
include .env
$(eval export $(shell sed -ne 's/ *#.*$$//; /./ s/=.*$$// p' .env))

########################################################################################################################
## Config values from .env file
########################################################################################################################

export TF_VAR_domain_name = $(DOMAIN_NAME)
export TF_VAR_tld_zone_id = $(TLD_ZONE_ID)
export TF_VAR_aws_access_key_id = $(AWS_ACCESS_KEY_ID)
export TF_VAR_aws_secret_access_key = $(AWS_SECRET_ACCESS_KEY)
export TF_VAR_region = $(REGION)
export TF_VAR_public_ec2_key = $(PUBLIC_EC2_KEY)

########################################################################################################################
## Predefined environment variables (DO NOT CHANGE)
########################################################################################################################

export TF_VAR_ecs_task_desired_count = 2
export TF_VAR_service_name = scenario-aws-ecs-ec2
export AWS_DEFAULT_REGION = $(TF_VAR_region)

########################################################################################################################
## Terraform commands
########################################################################################################################

bootstrap: ## Create local config file
	cp .env.example .env
	$(info Enter your credentials and configuration in .env before continuing with 'make deploy'.)

deploy: ## Deploy all infrastructure including a new ECS Task version (we simulate a versioning system here)
	./deploy.sh $(TF_VAR_service_name)

destroy: ## Deregister running ECS Tasks and run Terraform destroy
	./destroy.sh

destroy.clean: ## Run Terraform destroy without deregistering ECS Tasks
	cd infra && terraform destroy -var hash=null -auto-approve

info: ## Print success info message after deployment including latest ECS task version number
	$(info )
	$(info *************   DEPLOYMENT SUCCESSFUL   *************)
	$(info *                                                   *)
	$(info *     ECS Task version: $(hash)    *)
	$(info *                                                   *)
	$(info *****************************************************)
	$(info )

clean: ## Remove generated Terraform files except state files
	rm -rf infra/.terraform
	rm -rf infra/.terraform.lock.hcl
	rm -rf infra/infrastructure.tf.plan

clean.all: ## Remove all generated  Terraform files (WILL ALSO REMOVE STATE FILES!)
	make clean
	rm -rf infra/terraform.tfstate*
