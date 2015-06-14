STACK_NAME = ecs-cluster-default
TEMPLATE = file://${CURDIR}/ecs-setup.template
TASKS_FILE = file://${CURDIR}/aspnet-hello-tasks.json

create:
	aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body ${TEMPLATE} \
		--capabilities CAPABILITY_IAM \
		--parameters ParameterKey=KeyName,ParameterValue=ecs-instance

update:
	aws cloudformation update-stack --stack-name ${STACK_NAME} --template-body ${TEMPLATE} \
		--capabilities CAPABILITY_IAM \
		--parameters ParameterKey=KeyName,UsePreviousValue=true

delete:
	aws cloudformation delete-stack --stack-name ${STACK_NAME}

events:
	aws cloudformation describe-stack-events --stack-name ${STACK_NAME}

validate:
	aws cloudformation validate-template --template-body ${TEMPLATE}

register-task:
	aws ecs register-task-definition --cli-input-json ${TASKS_FILE}

run:
	# Use jq command to parse JSON and get the cluster name from CloudFormation:
	$(eval CLUSTER_NAME := $(shell aws cloudformation describe-stacks --stack-name ${STACK_NAME} \
		| jq -r '.Stacks[0].Outputs | map(select(.OutputKey == "EcsCluster" ))[0].OutputValue'))
	aws ecs run-task --cluster ${CLUSTER_NAME} --task-definition aspnet-hello-app --count 1

.PHONY: create update delete events validate register-task run
