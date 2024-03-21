package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
	"encoding/json"
)

#ConfigMap: timoniv1.#ImmutableConfig & {
	#config: #Config
	#Kind:   timoniv1.#ConfigMapKind
	#Meta:   #config.metadata
	#Data: "config.json": json.Marshal(#config.ztrConfig)
}
