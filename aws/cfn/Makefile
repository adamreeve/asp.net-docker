STACK_NAME = aspnet-hello
TEMPLATE = file://${CURDIR}/aspnet-hello.template

create:
	aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body ${TEMPLATE} --parameters \
		ParameterKey=OperatorEMail,ParameterValue=adreeve@gmail.com \
		ParameterKey=KeyName,ParameterValue=fedora-docker-host

update:
	aws cloudformation update-stack --stack-name ${STACK_NAME} --template-body ${TEMPLATE} --parameters \
		ParameterKey=OperatorEMail,UsePreviousValue=true \
		ParameterKey=KeyName,UsePreviousValue=true

delete:
	aws cloudformation delete-stack --stack-name ${STACK_NAME}

events:
	aws cloudformation describe-stack-events --stack-name ${STACK_NAME}

validate:
	aws cloudformation validate-template --template-body ${TEMPLATE}
