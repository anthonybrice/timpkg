// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.40.0/strimzi-crds-0.40.0.yaml

package v1alpha1

import "strings"

#KafkaTopic: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "kafka.strimzi.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "KafkaTopic"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// The specification of the topic.
	spec!: #KafkaTopicSpec
}

// The specification of the topic.
#KafkaTopicSpec: {
	// The topic configuration.
	config?: {
		...
	}

	// The number of partitions the topic should have. This cannot be
	// decreased after topic creation. It can be increased after
	// topic creation, but it is important to understand the
	// consequences that has, especially for topics with semantic
	// partitioning. When absent this will default to the broker
	// configuration for `num.partitions`.
	partitions?: >=1 & int

	// The number of replicas the topic should have. When absent this
	// will default to the broker configuration for
	// `default.replication.factor`.
	replicas?: int16 & >=1

	// The name of the topic. When absent this will default to the
	// metadata.name of the topic. It is recommended to not set this
	// unless the topic name is not a valid Kubernetes resource name.
	topicName?: string
}
