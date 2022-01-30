package main

import (
	"list"
	"encoding/yaml"
	"github.com/phoban01/cuelang-test/contraints"
)

list.Concat([#serviceAccounts, [#cm], [#ns]])

#ns: contraints.#Namespace & {
	metadata: name: "demo-system"
}

#cm: contraints.#ConfigMap & {
	metadata: name:      "tenant-details"
	metadata: namespace: "default"
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

#tenants: [
	{
		name:      "admin-account"
		namespace: #ns.metadata.name
	},
	{
		name:      "editor-account"
		namespace: #ns.metadata.name
	},
	{
		name:      "viewer-account"
		namespace: #ns.metadata.name
	},
]
