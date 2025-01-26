package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
)

#BindConfig: timoniv1.#ImmutableConfig & {
	#config: #Config
	#Kind:   timoniv1.#ConfigMapKind
	#Meta:   #config.metadata
	#Data: "named.conf": #config.namedConf
}

#ZonesConfig: timoniv1.#ImmutableConfig & {
	#config: #Config
	#Kind:   timoniv1.#ConfigMapKind
	#Meta:   #config.metadata
	#Data:   #config.zones
}
