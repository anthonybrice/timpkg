# tailscale-ingress

A [timoni.sh](http://timoni.sh) module for deploying [Tailscale ingress resources](https://tailscale.com/kb/1439/kubernetes-operator-cluster-ingress) to Kubernetes clusters.

## Install

To create an instance using the default values:

```shell
timoni -n default apply tailscale-ingress oci://ghcr.io/anthonybrice/modules/tailscale-ingress
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	serviceName: "nginx"
	servicePort: name: "http"
	host: "nginx"
}
```

And apply the values with:

```shell
timoni -n default apply tailscale-ingress oci://ghcr.io/anthonybrice/modules/tailscale-ingress \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete tailscale-ingress
```

## Configuration

| Key                      | Type                 | Default        | Description                            |
| ------------------------ | -------------------- | -------------- | -------------------------------------- |
| `metadata: labels:`      | `{[string]: string}` | `{}`           | Common labels for all resources        |
| `metadata: annotations:` | `{[string]: string}` | `{}`           | Common annotations for all resources   |
| `serviceName:`           | `string`             | `""`           | Backend Kubernetes Service             |
| `servicePort:`           | `ServiceBackendPort` | `{number: 80}` | Port of the referenced service         |
| `host:`                  | `string`             | `""`           | Desired hostname of the Tailscale node |

By default, the Ingress exposes the beackend service to your tailnet only. [To expose the service to the public internet](https://tailscale.com/kb/1439/kubernetes-operator-cluster-ingress#exposing-a-service-to-the-public-internet-using-ingress-and-tailscale-funnel), add the `tailscale.com/funnel: "true"` annotation.
