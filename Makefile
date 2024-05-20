KUBE_NAMESPACE=logging
HELM_RELEASE_NAME=fluent-bit

diff:
	helm diff upgrade --install -n $(KUBE_NAMESPACE) $(HELM_RELEASE_NAME) .

install:
	helm upgrade --install -n $(KUBE_NAMESPACE) $(HELM_RELEASE_NAME) .
