// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.40.0/strimzi-crds-0.40.0.yaml

package v1alpha1

import "strings"

#KafkaUser: {
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
	kind: "KafkaUser"
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

	// The specification of the user.
	spec!: #KafkaUserSpec
}

// The specification of the user.
#KafkaUserSpec: {
	// Authentication mechanism enabled for this Kafka user. The
	// supported authentication mechanisms are `scram-sha-512`,
	// `tls`, and `tls-external`.
	//
	// * `scram-sha-512` generates a secret with SASL SCRAM-SHA-512
	// credentials.
	// * `tls` generates a secret with user certificate for mutual TLS
	// authentication.
	// * `tls-external` does not generate a user certificate. But
	// prepares the user for using mutual TLS authentication using a
	// user certificate generated outside the User Operator.
	// ACLs and quotas set for this user are configured in the
	// `CN=<username>` format.
	//
	// Authentication is optional. If authentication is not
	// configured, no credentials are generated. ACLs and quotas set
	// for the user are configured in the `<username>` format
	// suitable for SASL authentication.
	authentication?: {
		password?: {
			valueFrom: {
				// Selects a key of a Secret in the resource's namespace.
				secretKeyRef?: {
					key?:      string
					name?:     string
					optional?: bool
				}
			}
		}

		// Authentication type.
		type: "tls" | "tls-external" | "scram-sha-512"
	}

	// Authorization rules for this Kafka user.
	authorization?: {
		// List of ACL rules which should be applied to this user.
		acls: [...{
			// The host from which the action described in the ACL rule is
			// allowed or denied.
			host?: string

			// Operation which will be allowed or denied. Supported operations
			// are: Read, Write, Create, Delete, Alter, Describe,
			// ClusterAction, AlterConfigs, DescribeConfigs, IdempotentWrite
			// and All.
			operation?: "Read" | "Write" | "Create" | "Delete" | "Alter" | "Describe" | "ClusterAction" | "AlterConfigs" | "DescribeConfigs" | "IdempotentWrite" | "All"

			// List of operations which will be allowed or denied. Supported
			// operations are: Read, Write, Create, Delete, Alter, Describe,
			// ClusterAction, AlterConfigs, DescribeConfigs, IdempotentWrite
			// and All.
			operations?: [..."Read" | "Write" | "Create" | "Delete" | "Alter" | "Describe" | "ClusterAction" | "AlterConfigs" | "DescribeConfigs" | "IdempotentWrite" | "All"]

			// Indicates the resource for which given ACL rule applies.
			resource: {
				// Name of resource for which given ACL rule applies. Can be
				// combined with `patternType` field to use prefix pattern.
				name?: string

				// Describes the pattern used in the resource field. The supported
				// types are `literal` and `prefix`. With `literal` pattern type,
				// the resource field will be used as a definition of a full
				// name. With `prefix` pattern type, the resource name will be
				// used only as a prefix. Default value is `literal`.
				patternType?: "literal" | "prefix"

				// Resource type. The available resource types are `topic`,
				// `group`, `cluster`, and `transactionalId`.
				type: "topic" | "group" | "cluster" | "transactionalId"
			}

			// The type of the rule. Currently the only supported type is
			// `allow`. ACL rules with type `allow` are used to allow user to
			// execute the specified operations. Default value is `allow`.
			type?: "allow" | "deny"
		}]

		// Authorization type. Currently the only supported type is
		// `simple`. `simple` authorization type uses the Kafka Admin API
		// for managing the ACL rules.
		type: "simple"
	}

	// Quotas on requests to control the broker resources used by
	// clients. Network bandwidth and request rate quotas can be
	// enforced.Kafka documentation for Kafka User quotas can be
	// found at http://kafka.apache.org/documentation/#design_quotas.
	quotas?: {
		// A quota on the maximum bytes per-second that each client group
		// can fetch from a broker before the clients in the group are
		// throttled. Defined on a per-broker basis.
		consumerByteRate?: >=0 & int

		// A quota on the rate at which mutations are accepted for the
		// create topics request, the create partitions request and the
		// delete topics request. The rate is accumulated by the number
		// of partitions created or deleted.
		controllerMutationRate?: >=0

		// A quota on the maximum bytes per-second that each client group
		// can publish to a broker before the clients in the group are
		// throttled. Defined on a per-broker basis.
		producerByteRate?: >=0 & int

		// A quota on the maximum CPU utilization of each client group as
		// a percentage of network and I/O threads.
		requestPercentage?: >=0 & int
	}
	template?: {
		secret?: {
			// Metadata applied to the resource.
			metadata?: {
				// Annotations added to the Kubernetes resource.
				annotations?: {
					[string]: string
				}

				// Labels added to the Kubernetes resource.
				labels?: {
					[string]: string
				}
			}
		}
	}
}