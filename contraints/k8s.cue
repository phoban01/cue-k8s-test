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

#Deployment: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   _metadata
	spec: {
		replicas: int
		selector: matchLabels: app: string
		template: {
			metadata: labels: app: string
			spec: {
				serviceAccountName: string
				containers: [{
					name:  string
					image: string
				}]
			}
		}
	}
}
