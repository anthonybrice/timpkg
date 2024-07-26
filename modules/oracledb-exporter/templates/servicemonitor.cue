package templates

import (
	smv1 "monitoring.coreos.com/servicemonitor/v1"
)

#ServiceMonitor: smv1.#ServiceMonitor & {
	#config:    #Config
	apiVersion: "monitoring.coreos.com/v1"
	kind:       "ServiceMonitor"
	metadata:   #config.metadata
	spec: {
		selector: matchLabels: "app.kubernetes.io/name": #config.metadata.name
		namespaceSelector: matchNames: [#config.metadata.namespace]
		endpoints: [
			{
				port:     "http"
				path:     "/metrics"
				interval: "1s"
			},
		]
	}
}
