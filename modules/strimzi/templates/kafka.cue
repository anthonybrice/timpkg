package templates

import (
	k "kafka.strimzi.io/kafka/v1beta2"
	knp "kafka.strimzi.io/kafkanodepool/v1beta2"
)

#Broker: knp.#KafkaNodePool & {
	#config: #Config
	metadata: {
		name: "\(#config.metadata.name)-broker"
		namespace: #config.metadata.namespace
		labels: "strimzi.io/cluster": "\(#config.metadata.name)"
	}
	spec: {
		replicas: 5
		roles: ["broker"]
		storage: type: "ephemeral"
	}
}

#Controller: knp.#KafkaNodePool & {
	#config: #Config
	metadata: {
		name: "\(#config.metadata.name)-controller"
		namespace: #config.metadata.namespace
		labels: "strimzi.io/cluster": "\(#config.metadata.name)"
	}
	spec: {
		replicas: 3
		roles: ["controller"]
		storage: type: "ephemeral"
	}
}

#Kafka: k.#Kafka & {
	#config: #Config
	metadata: {
		name: #config.metadata.name
		namespace: #config.metadata.namespace
		annotations: {
			"strimzi.io/node-pools": "enabled"
			"strimzi.io/kraft": "enabled"
		}
	}
	spec: {
		kafka: {
			version: "3.7.0"
			metadataVersion: "3.7-IV4"
			listeners: [
				{
					name: "plain"
					port: 9092
					type: "internal"
					tls: false
				},
				{
					name: "tls"
					port: 9093
					type: "internal"
					tls: true
				}
			]
			config: {
				"offsets.topic.replication.factor": 3
				"transaction.state.log.replication.factor": 3
				"transaction.state.log.min.isr": 2
				"default.replication.factor": 3
				"min.insync.replicas": 2
			}
		}
		entityOperator: {
			topicOperator: {}
			userOperator: {}
		}
		cruiseControl: {}
	}
}
