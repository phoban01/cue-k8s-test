package main

import (
	"list"
	"encoding/yaml"
	"github.com/phoban01/cue-k8s-test/contraints"
)

list.Concat([#serviceAccounts, #deployments, [#cm], [#ns]])

#ns: contraints.#Namespace & {
	metadata: name: "demo-system"
}

#cm: contraints.#ConfigMap & {
	metadata: name:      "tenant-details"
	metadata: namespace: #ns.metadata.name
	data: {
		for i, tenant in #tenants {
			let tenantspec = {
				tenant_id:  i + 1
				tenant_key: "\(tenant.namespace)/\(tenant.name)"
			}
			"tenant_\(i+1)": yaml.Marshal(tenantspec)
		}
	}
}

#serviceAccounts: [ for _, tenant in #tenants {
	contraints.#ServiceAccount & {
		metadata: name:      tenant.name
		metadata: namespace: tenant.namespace
	}
}]

#deployments: [ for _, tenant in #tenants {
	contraints.#Deployment & {
		metadata: name:      tenant.name
		metadata: namespace: tenant.namespace
		spec: {
			replicas: 1
			selector: matchLabels: app: tenant.app_id
			template: {
				metadata: labels: app: tenant.app_id
				spec: {
					serviceAccountName: tenant.name
					containers: [{
						name:  tenant.app_id
						image: tenant.image
					}]
				}
			}
		}
	}
}]

#tenants: [
	{
		name:      "admin-account"
		namespace: #ns.metadata.name
		app_id:    "cache"
		image:     "redis:latest"
	},
	{
		name:      "editor-account"
		namespace: #ns.metadata.name
		app_id:    "server"
		image:     "nginx:latest"
	},
	// {
	//     name:      "viewer-account"
	//     namespace: #ns.metadata.name
	//     app_id:    "proxy"
	//     image:     "nginx:latest"
	// },
]
