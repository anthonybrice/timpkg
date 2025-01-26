package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// The kubeVersion is a required field, set at apply-time
	// via timoni.cue by querying the user's Kubernetes API.
	kubeVersion!: string
	// Using the kubeVersion you can enforce a minimum Kubernetes minor version.
	// By default, the minimum Kubernetes version is set to 1.20.
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}

	// The moduleVersion is set from the user-supplied module version.
	// This field is used for the `app.kubernetes.io/version` label.
	moduleVersion!: string

	// The Kubernetes metadata common to all resources.
	// The `metadata.name` and `metadata.namespace` fields are
	// set from the user-supplied instance name and namespace.
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// The labels allows adding `metadata.labels` to all resources.
	// The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels
	// are automatically generated and can't be overwritten.
	metadata: labels: timoniv1.#Labels

	// The annotations allows adding `metadata.annotations` to all resources.
	metadata: annotations?: timoniv1.#Annotations

	// The selector allows adding label selectors to Deployments and Services.
	// The `app.kubernetes.io/name` label selector is automatically generated
	// from the instance name and can't be overwritten.
	selector: timoniv1.#Selector & {#Name: metadata.name}

	// The image allows setting the container image repository,
	// tag, digest and pull policy.
	image: timoniv1.#Image & {
		repository: *"docker.io/internetsystemsconsortium/bind9" | string
		tag:        *"9.20" | string
		digest:     *"sha256:caae52f6529ba4352035f6586cae29332834a06e8140de4bd1487571df6ff75d" | string
	}

	// The pod allows setting the Kubernetes Pod annotations, image pull secrets,
	// affinity and anti-affinity rules. By default, pods are scheduled on Linux nodes.
	pod: {
		annotations?: timoniv1.#Annotations

		affinity: *{
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{
					key:      corev1.#LabelOSStable
					operator: "In"
					values: ["linux"]
				}]
			}]
		} | corev1.#Affinity

		imagePullSecrets?: [...timoniv1.#ObjectReference]
	}

	// The resources allows setting the container resource requirements.
	// By default, the container requests 10m CPU and 32Mi memory.
	resources: timoniv1.#ResourceRequirements & {
		requests: {
			cpu:    *"10m" | timoniv1.#CPUQuantity
			memory: *"32Mi" | timoniv1.#MemoryQuantity
		}
	}

	// The number of pods replicas.
	// By default, the number of replicas is 1.
	replicas: *1 | int & >0

	// The securityContext allows setting the container security context.
	// By default, the container is denied privilege escalation.
	securityContext: corev1.#SecurityContext & {
		allowPrivilegeEscalation: *false | true
		privileged:               *false | true
		capabilities:
		{
			drop: *["ALL"] | [string]
			add: *["CHOWN", "NET_BIND_SERVICE", "SETGID", "SETUID"] | [string]
		}
	}

	// The service allows setting the Kubernetes Service annotations and port.
	// By default, the port is 53.
	service: {
		annotations?: timoniv1.#Annotations

		// By default, the type is load balancer so that devices outside the cluster can access the service.
		type: *corev1.#ServiceTypeLoadBalancer | corev1.#ServiceType

		port: *53 | int & >0 & <=65535
	}

	// A default configuration that defines the working directory and logs to stdout.
	// The bind9 container will fail to start without at least specifying the working directory.
	namedConf: string | *"""
		options {
		  directory "/var/cache/bind";
		};

		logging {
		  channel default_log {
		    stderr;
		    severity info;
		    print-time yes;
		    print-severity yes;
		    print-category yes;
		  };

		  category default {
		    default_log;
		  };

		  category queries {
		    default_log;
		  };
		};
		"""

	zones: *{} | {[string]: string}
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		deploy: #Deployment & {
			#config:      config
			#bindConfig:  bindConfig.metadata.name
			#zonesConfig: zonesConfig.metadata.name
		}
		service: #Service & {#config: config}
		bindConfig: #BindConfig & {#config: config}
		zonesConfig: #ZonesConfig & {#config: config}
	}
}
