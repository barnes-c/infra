# MetalLB - Load Balancer

MetalLB is a load-balancer implementation for bare metal [Kubernetes](https://kubernetes.io/) clusters, using standard routing protocols.

## Why?

Kubernetes does not offer an implementation of network load balancers ([Services of type LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/)) for bare-metal clusters. The implementations of network load balancers that Kubernetes does ship with are all glue code that calls out to various IaaS platforms (GCP, AWS, Azure…). If you’re not running on a supported IaaS platform (GCP, AWS, Azure…), LoadBalancers will remain in the “pending” state indefinitely when created.

Bare-metal cluster operators are left with two lesser tools to bring user traffic into their clusters, “NodePort” and “externalIPs” services. Both of these options have significant downsides for production use, which makes bare-metal clusters second-class citizens in the Kubernetes ecosystem.

MetalLB aims to redress this imbalance by offering a network load balancer implementation that integrates with standard network equipment, so that external services on bare-metal clusters also “just work” as much as possible.

## Usage

```bash
kubectl apply -f load-balancer/namespace.yaml
kubectl apply -f load-balancer/manifest.yaml
```

This will deploy MetalLB to your cluster, under the `metallb-system` namespace. The components in the manifest are:

- The `metallb-system/controller` deployment. This is the cluster-wide controller that handles IP address assignments.
- The `metallb-system/speaker` daemonSet. This is the component that speaks the protocol(s) of your choice to make the services reachable.
- Service accounts for the controller and speaker, along with the RBAC permissions that the components need to function.
- The `metallb-system/metallb` configMap.

## Configuration

MetalLB remains idle until configured. This is accomplished by creating and deploying a config map into the same namespace (metallb-system) as the deployment. We just need this little config below. For a full config check [this](https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/example-config.yaml) out.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
	namespace: metallb-system
	name: config
data:
	config: |
	address-pools:
	- name: default
			protocol: layer2
			addresses:
				- 192.168.1.240-192.168.1.250
```

<aside>
💡 If we are running metalLB with helm the config file has to be named metallb.yaml.

</aside>

> Sources:
>
> [https://metallb.universe.tf](https://metallb.universe.tf/)
>
> [https://metallb.universe.tf/installation/](https://metallb.universe.tf/installation/)
>
> [https://metallb.universe.tf/configuration/](https://metallb.universe.tf/configuration/)
