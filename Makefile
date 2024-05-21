KUBE_NAMESPACE=logging
HELM_RELEASE_NAME=fluent-bit
ENVIRONMENT=prod

diff:
	helm diff upgrade --install \
		-f values.yaml \
		-f values/$(ENVIRONMENT).yaml \
		-n $(KUBE_NAMESPACE) \
		$(HELM_RELEASE_NAME) \
		.

install:
	helm upgrade --install \
		-f values.yaml \
		-f values/$(ENVIRONMENT).yaml \
		-n $(KUBE_NAMESPACE) \
		$(HELM_RELEASE_NAME) \
		.
