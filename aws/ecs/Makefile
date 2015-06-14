STACK_NAME = ecs-cluster-default
TEMPLATE = file://${CURDIR}/ecs-setup.template

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
