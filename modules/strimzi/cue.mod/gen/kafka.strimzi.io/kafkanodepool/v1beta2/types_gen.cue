// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.40.0/strimzi-crds-0.40.0.yaml

package v1beta2

import "strings"

#KafkaNodePool: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "kafka.strimzi.io/v1beta2"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "KafkaNodePool"
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

	// The specification of the KafkaNodePool.
	spec!: #KafkaNodePoolSpec
}

// The specification of the KafkaNodePool.
#KafkaNodePoolSpec: {
	// JVM Options for pods.
	jvmOptions?: {
		// A map of -XX options to the JVM.
		"-XX"?: {
			[string]: string
		}

		// -Xms option to to the JVM.
		"-Xms"?: =~"^[0-9]+[mMgG]?$"

		// -Xmx option to to the JVM.
		"-Xmx"?: =~"^[0-9]+[mMgG]?$"

		// Specifies whether the Garbage Collection logging is enabled.
		// The default is false.
		gcLoggingEnabled?: bool

		// A map of additional system properties which will be passed
		// using the `-D` option to the JVM.
		javaSystemProperties?: [...{
			// The system property name.
			name?: string

			// The system property value.
			value?: string
		}]
	}

	// The number of pods in the pool.
	replicas: >=0 & int

	// CPU and memory resources to reserve.
	resources?: {
		claims?: [...{
			name?: string
		}]
		limits?: {
			...
		}
		requests?: {
			...
		}
	}

	// The roles that the nodes in this pool will have when KRaft mode
	// is enabled. Supported values are 'broker' and 'controller'.
	// This field is required. When KRaft mode is disabled, the only
	// allowed value if `broker`.
	roles: [..."controller" | "broker"]

	// Storage configuration (disk). Cannot be updated.
	storage: {
		// The storage class to use for dynamic volume allocation.
		class?: string

		// Specifies if the persistent volume claim has to be deleted when
		// the cluster is un-deployed.
		deleteClaim?: bool

		// Storage identification number. It is mandatory only for storage
		// volumes defined in a storage of type 'jbod'.
		id?: >=0 & int

		// Overrides for individual brokers. The `overrides` field allows
		// to specify a different configuration for different brokers.
		overrides?: [...{
			// Id of the kafka broker (broker identifier).
			broker?: int

			// The storage class to use for dynamic volume allocation for this
			// broker.
			class?: string
		}]

		// Specifies a specific persistent volume to use. It contains
		// key:value pairs representing labels for selecting such a
		// volume.
		selector?: {
			[string]: string
		}

		// When `type=persistent-claim`, defines the size of the
		// persistent volume claim, such as 100Gi. Mandatory when
		// `type=persistent-claim`.
		size?: string

		// When type=ephemeral, defines the total amount of local storage
		// required for this EmptyDir volume (for example 1Gi).
		sizeLimit?: =~"^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"

		// Storage type, must be either 'ephemeral', 'persistent-claim',
		// or 'jbod'.
		type: "ephemeral" | "persistent-claim" | "jbod"

		// List of volumes as Storage objects representing the JBOD disks
		// array.
		volumes?: [...{
			// The storage class to use for dynamic volume allocation.
			class?: string

			// Specifies if the persistent volume claim has to be deleted when
			// the cluster is un-deployed.
			deleteClaim?: bool

			// Storage identification number. It is mandatory only for storage
			// volumes defined in a storage of type 'jbod'.
			id?: >=0 & int

			// Overrides for individual brokers. The `overrides` field allows
			// to specify a different configuration for different brokers.
			overrides?: [...{
				// Id of the kafka broker (broker identifier).
				broker?: int

				// The storage class to use for dynamic volume allocation for this
				// broker.
				class?: string
			}]

			// Specifies a specific persistent volume to use. It contains
			// key:value pairs representing labels for selecting such a
			// volume.
			selector?: {
				[string]: string
			}

			// When `type=persistent-claim`, defines the size of the
			// persistent volume claim, such as 100Gi. Mandatory when
			// `type=persistent-claim`.
			size?: string

			// When type=ephemeral, defines the total amount of local storage
			// required for this EmptyDir volume (for example 1Gi).
			sizeLimit?: =~"^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"

			// Storage type, must be either 'ephemeral' or 'persistent-claim'.
			type: "ephemeral" | "persistent-claim"
		}]
	}

	// Template for pool resources. The template allows users to
	// specify how the resources belonging to this pool are
	// generated.
	template?: {
		// Template for the Kafka init container.
		initContainer?: {
			// Environment variables which should be applied to the container.
			env?: [...{
				// The environment variable key.
				name?: string

				// The environment variable value.
				value?: string
			}]

			// Security context for the container.
			securityContext?: {
				allowPrivilegeEscalation?: bool
				capabilities?: {
					add?: [...string]
					drop?: [...string]
				}
				privileged?:             bool
				procMount?:              string
				readOnlyRootFilesystem?: bool
				runAsGroup?:             int
				runAsNonRoot?:           bool
				runAsUser?:              int
				seLinuxOptions?: {
					level?: string
					role?:  string
					type?:  string
					user?:  string
				}
				seccompProfile?: {
					localhostProfile?: string
					type?:             string
				}
				windowsOptions?: {
					gmsaCredentialSpec?:     string
					gmsaCredentialSpecName?: string
					hostProcess?:            bool
					runAsUserName?:          string
				}
			}
		}

		// Template for the Kafka broker container.
		kafkaContainer?: {
			// Environment variables which should be applied to the container.
			env?: [...{
				// The environment variable key.
				name?: string

				// The environment variable value.
				value?: string
			}]

			// Security context for the container.
			securityContext?: {
				allowPrivilegeEscalation?: bool
				capabilities?: {
					add?: [...string]
					drop?: [...string]
				}
				privileged?:             bool
				procMount?:              string
				readOnlyRootFilesystem?: bool
				runAsGroup?:             int
				runAsNonRoot?:           bool
				runAsUser?:              int
				seLinuxOptions?: {
					level?: string
					role?:  string
					type?:  string
					user?:  string
				}
				seccompProfile?: {
					localhostProfile?: string
					type?:             string
				}
				windowsOptions?: {
					gmsaCredentialSpec?:     string
					gmsaCredentialSpecName?: string
					hostProcess?:            bool
					runAsUserName?:          string
				}
			}
		}
		perPodIngress?: {
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
		perPodRoute?: {
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
		perPodService?: {
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
		persistentVolumeClaim?: {
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

		// Template for Kafka `Pods`.
		pod?: {
			// The pod's affinity rules.
			affinity?: {
				nodeAffinity?: {
					preferredDuringSchedulingIgnoredDuringExecution?: [...{
						preference?: {
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchFields?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
						}
						weight?: int
					}]
					requiredDuringSchedulingIgnoredDuringExecution?: {
						nodeSelectorTerms?: [...{
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchFields?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
						}]
					}
				}
				podAffinity?: {
					preferredDuringSchedulingIgnoredDuringExecution?: [...{
						podAffinityTerm?: {
							labelSelector?: {
								matchExpressions?: [...{
									key?:      string
									operator?: string
									values?: [...string]
								}]
								matchLabels?: {
									[string]: string
								}
							}
							matchLabelKeys?: [...string]
							mismatchLabelKeys?: [...string]
							namespaceSelector?: {
								matchExpressions?: [...{
									key?:      string
									operator?: string
									values?: [...string]
								}]
								matchLabels?: {
									[string]: string
								}
							}
							namespaces?: [...string]
							topologyKey?: string
						}
						weight?: int
					}]
					requiredDuringSchedulingIgnoredDuringExecution?: [...{
						labelSelector?: {
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchLabels?: {
								[string]: string
							}
						}
						matchLabelKeys?: [...string]
						mismatchLabelKeys?: [...string]
						namespaceSelector?: {
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchLabels?: {
								[string]: string
							}
						}
						namespaces?: [...string]
						topologyKey?: string
					}]
				}
				podAntiAffinity?: {
					preferredDuringSchedulingIgnoredDuringExecution?: [...{
						podAffinityTerm?: {
							labelSelector?: {
								matchExpressions?: [...{
									key?:      string
									operator?: string
									values?: [...string]
								}]
								matchLabels?: {
									[string]: string
								}
							}
							matchLabelKeys?: [...string]
							mismatchLabelKeys?: [...string]
							namespaceSelector?: {
								matchExpressions?: [...{
									key?:      string
									operator?: string
									values?: [...string]
								}]
								matchLabels?: {
									[string]: string
								}
							}
							namespaces?: [...string]
							topologyKey?: string
						}
						weight?: int
					}]
					requiredDuringSchedulingIgnoredDuringExecution?: [...{
						labelSelector?: {
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchLabels?: {
								[string]: string
							}
						}
						matchLabelKeys?: [...string]
						mismatchLabelKeys?: [...string]
						namespaceSelector?: {
							matchExpressions?: [...{
								key?:      string
								operator?: string
								values?: [...string]
							}]
							matchLabels?: {
								[string]: string
							}
						}
						namespaces?: [...string]
						topologyKey?: string
					}]
				}
			}

			// Indicates whether information about services should be injected
			// into Pod's environment variables.
			enableServiceLinks?: bool

			// The pod's HostAliases. HostAliases is an optional list of hosts
			// and IPs that will be injected into the Pod's hosts file if
			// specified.
			hostAliases?: [...{
				hostnames?: [...string]
				ip?: string
			}]

			// List of references to secrets in the same namespace to use for
			// pulling any of the images used by this Pod. When the
			// `STRIMZI_IMAGE_PULL_SECRETS` environment variable in Cluster
			// Operator and the `imagePullSecrets` option are specified, only
			// the `imagePullSecrets` variable is used and the
			// `STRIMZI_IMAGE_PULL_SECRETS` variable is ignored.
			imagePullSecrets?: [...{
				name?: string
			}]

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

			// The name of the priority class used to assign priority to the
			// pods.
			priorityClassName?: string

			// The name of the scheduler used to dispatch this `Pod`. If not
			// specified, the default scheduler will be used.
			schedulerName?: string

			// Configures pod-level security attributes and common container
			// settings.
			securityContext?: {
				fsGroup?:             int
				fsGroupChangePolicy?: string
				runAsGroup?:          int
				runAsNonRoot?:        bool
				runAsUser?:           int
				seLinuxOptions?: {
					level?: string
					role?:  string
					type?:  string
					user?:  string
				}
				seccompProfile?: {
					localhostProfile?: string
					type?:             string
				}
				supplementalGroups?: [...int]
				sysctls?: [...{
					name?:  string
					value?: string
				}]
				windowsOptions?: {
					gmsaCredentialSpec?:     string
					gmsaCredentialSpecName?: string
					hostProcess?:            bool
					runAsUserName?:          string
				}
			}

			// The grace period is the duration in seconds after the processes
			// running in the pod are sent a termination signal, and the time
			// when the processes are forcibly halted with a kill signal. Set
			// this value to longer than the expected cleanup time for your
			// process. Value must be a non-negative integer. A zero value
			// indicates delete immediately. You might need to increase the
			// grace period for very large Kafka clusters, so that the Kafka
			// brokers have enough time to transfer their work to another
			// broker before they are terminated. Defaults to 30 seconds.
			terminationGracePeriodSeconds?: >=0 & int

			// Defines the total amount (for example `1Gi`) of local storage
			// required for temporary EmptyDir volume (`/tmp`). Default value
			// is `5Mi`.
			tmpDirSizeLimit?: =~"^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"

			// The pod's tolerations.
			tolerations?: [...{
				effect?:            string
				key?:               string
				operator?:          string
				tolerationSeconds?: int
				value?:             string
			}]

			// The pod's topology spread constraints.
			topologySpreadConstraints?: [...{
				labelSelector?: {
					matchExpressions?: [...{
						key?:      string
						operator?: string
						values?: [...string]
					}]
					matchLabels?: {
						[string]: string
					}
				}
				matchLabelKeys?: [...string]
				maxSkew?:            int
				minDomains?:         int
				nodeAffinityPolicy?: string
				nodeTaintsPolicy?:   string
				topologyKey?:        string
				whenUnsatisfiable?:  string
			}]
		}
		podSet?: {
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
