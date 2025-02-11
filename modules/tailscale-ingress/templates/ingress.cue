package templates

import (
	networkingv1 "k8s.io/api/networking/v1"
)

#Ingress: networkingv1.#Ingress & {
	#config:    #Config
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata:   #config.metadata
	spec: {
		ingressClassName: "tailscale"
		defaultBackend: service: {
			name: #config.serviceName
			port: #config.servicePort
		}
		tls: [{
			hosts: [#config.host]
		}]
	}
}
