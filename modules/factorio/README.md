# factorio

A [timoni.sh](http://timoni.sh) module for deploying factorio to Kubernetes clusters.

## Install

To create an instance using the default values:

```shell
timoni -n default apply factorio oci://anthonybrice/modules/factorio
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	resources: requests: {
		cpu:    "100m"
		memory: "128Mi"
	}
}
```

And apply the values with:

```shell
timoni -n default apply factorio oci://ghcr.io/anthonybrice/modules/factorio \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete factorio
```

## Configuration

No factorio configuration. Runs the game with a new save file and exposes a service at port 34197.
