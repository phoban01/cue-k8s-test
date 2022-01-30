package contraints

_metadata: {
	name:       string
	namespace?: string
	labels?: [string]: string
}

#ServiceAccount: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata:   _metadata
}

#ServiceAccount: {
	metadata: namespace: !~"kube-system"
}

#Namespace: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata:   _metadata
}

#Namespace: {
	metadata: name: !~"kube-system"
}

#ConfigMap: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata:   _metadata
	data: {
		[string]: string
	}
}
