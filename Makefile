KUBE_NAMESPACE=logging
HELM_RELEASE_NAME=fluent-bit

diff:
	helm diff upgrade --install -f values.yaml -n $(KUBE_NAMESPACE) $(HELM_RELEASE_NAME) .

install:
	helm upgrade --install -f values.yaml -n $(KUBE_NAMESPACE) $(HELM_RELEASE_NAME) .
