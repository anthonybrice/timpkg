package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:    #Config
	#bindConfig: string
	#zonesConfig: string
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   #config.metadata
	spec: appsv1.#DeploymentSpec & {
		replicas: #config.replicas
		selector: matchLabels: #config.selector.labels
		template: {
			metadata: {
				labels: #config.selector.labels
				if #config.pod.annotations != _|_ {
					annotations: #config.pod.annotations
				}
			}
			spec: corev1.#PodSpec & {
				containers: [
					{
						name:            #config.metadata.name
						image:           #config.image.reference
						imagePullPolicy: #config.image.pullPolicy
						// command: ["sleep", "infinity"]
						ports: [
							{
								name:          "http-udp"
								protocol:      "UDP"
								containerPort: 53
							},
							{
								name:          "http-tcp"
								protocol:      "TCP"
								containerPort: 53
							},
						]
						livenessProbe: {
							tcpSocket: {
								port: "http-tcp"
							}
							initialDelaySeconds: 5
							periodSeconds:       5
						}
						volumeMounts: [
							{
								name:      "config"
								mountPath: "/etc/bind"
							},
							{
								name:      "cache"
								mountPath: "/var/cache/bind"
							},
							{
								name: "zones"
								mountPath: "/var/lib/bind"
							}
						]
						if #config.resources != _|_ {
							resources: #config.resources
						}
						if #config.securityContext != _|_ {
							securityContext: #config.securityContext
						}
					},
				]
				volumes: [
					{
						name: "config"
						configMap: name: #bindConfig
					},
					{
						name: "cache"
						emptyDir: {}
					},
					{
						name: "zones"
						configMap: name: #zonesConfig
					}
				]
				if #config.pod.affinity != _|_ {
					affinity: #config.pod.affinity
				}
				if #config.pod.imagePullSecrets != _|_ {
					imagePullSecrets: #config.pod.imagePullSecrets
				}
			}
		}
	}
}
