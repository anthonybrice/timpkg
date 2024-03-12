package templates

import (
	batchv1 "k8s.io/api/batch/v1"
)

#CronJobList: batchv1.#CronJobList & {
	#config: #Config
	apiVersion: "batch/v1"
	kind: "CronJobList"
	items: [for i, #job in #config.crontab {
		batchv1.#CronJob & {
			apiVersion: "batch/v1"
			kind:       "CronJob"
			metadata:   {
				name: "\(#config.metadata.name)-\(i)"
				namespace: #config.metadata.namespace
			}
			spec: batchv1.#CronJobSpec & {
				timeZone: #config.timeZone
				schedule: #job.schedule
				jobTemplate: spec: template: spec: {
					serviceAccountName: #config.metadata.name
					containers: [{
						name:            #config.metadata.name
						image:           #config.image.reference
						imagePullPolicy: #config.image.pullPolicy
						command: #job.command
						args?: #job.args
						env: [for #k, #v in #config.env {
							name: #k
							value: #v
						}]
					}]
					restartPolicy: "OnFailure"
				}
				if #job.resources != _|_ {
					resources: #job.resources
				}
				if #job.securityContext != _|_ {
					securityContext: #job.securityContext
				}
				if #config.pod.imagePullSecrets != _|_ {
					imagePullSecrets: #config.pod.imagePullSecrets
				}
			}
		}
	}]
}
