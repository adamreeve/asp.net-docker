STACK_NAME = ecs-cluster-default
TEMPLATE = file://${CURDIR}/ecs-setup.template
TASKS_FILE = file://${CURDIR}/aspnet-hello-tasks.json

stack_description.json:
	aws cloudformation describe-stacks --stack-name ${STACK_NAME} > $@

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

create-service: stack_description.json
	# Use jq command to parse JSON and get the cluster name and load-balancer name from CloudFormation:
	$(eval CLUSTER_NAME := $(shell jq -r '.Stacks[0].Outputs | map(select(.OutputKey == "EcsCluster" ))[0].OutputValue' < stack_description.json))
	$(eval LOAD_BALANCER_NAME := $(shell jq -r '.Stacks[0].Outputs | map(select(.OutputKey == "LoadBalancer" ))[0].OutputValue' < stack_description.json))
	$(eval ECS_SERVICE_ROLE := $(shell jq -r '.Stacks[0].Outputs | map(select(.OutputKey == "EcsServiceRole" ))[0].OutputValue' < stack_description.json))

	aws ecs create-service --cluster ${CLUSTER_NAME} --service-name aspnet-hello --load-balancers loadBalancerName=${LOAD_BALANCER_NAME},containerName=aspnet-hello,containerPort=5004 --desired-count 1 --role ${ECS_SERVICE_ROLE} --task-definition aspnet-hello-app

run: stack_description.json
	# Use jq command to parse JSON and get the cluster name from CloudFormation:
	$(eval CLUSTER_NAME := $(shell jq -r '.Stacks[0].Outputs | map(select(.OutputKey == "EcsCluster" ))[0].OutputValue' < stack_description.json))
	aws ecs run-task --cluster ${CLUSTER_NAME} --task-definition aspnet-hello-app --count 1

.PHONY: create update delete events validate register-task run stack_description.json
