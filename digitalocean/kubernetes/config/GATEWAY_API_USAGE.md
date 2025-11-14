# Gateway API Usage Guide

This cluster uses **Cilium Gateway API** (pre-installed by DigitalOcean) for all services.

## Cilium Gateway
- **GatewayClass**: `cilium` (managed by DigitalOcean)
- **Use for**: Everything - ArgoCD, Argo Rollouts, and all application microservices
- **Features**: Native DigitalOcean integration, high performance, eBPF-based networking
- **Installation**: Pre-installed on all DOKS clusters, no manual setup required

## Kong Gateway (Preserved but Disabled)
Kong code is preserved in the repository but commented out. To re-enable:
1. Uncomment `deploy_kong` in `homelab-infra/modules/k8s/cluster/main.tf`
2. Update dependencies in `helm_releases.tf`
3. Switch ArgoCD back to Kong ingress

## Example: Using Cilium for Applications

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-app-gateway
  namespace: my-app
spec:
  gatewayClassName: cilium  # Use Cilium for applications
  listeners:
  - name: http
    protocol: HTTP
    port: 80
  - name: https
    protocol: HTTPS
    port: 443
    tls:
      mode: Terminate
      certificateRefs:
      - name: my-app-tls
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-app-route
  namespace: my-app
spec:
  parentRefs:
  - name: my-app-gateway
  hostnames:
  - "myapp.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: my-app-service
      port: 8080
```

## Example: ArgoCD with Cilium Gateway

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: argocd-gateway
  namespace: argocd
spec:
  gatewayClassName: cilium
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: argocd.devopshomelab.live
    tls:
      mode: Terminate
      certificateRefs:
      - name: argocd-tls
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: argocd-route
  namespace: argocd
spec:
  parentRefs:
  - name: argocd-gateway
  hostnames:
  - argocd.devopshomelab.live
  rules:
  - backendRefs:
    - name: argo-cd-argocd-server
      port: 80
```

## Benefits of Cilium-Only Setup

- **Simplicity**: Single Gateway API implementation for everything
- **Performance**: eBPF-based networking for all services
- **Native Integration**: Uses DigitalOcean's pre-installed Cilium
- **Cost Effective**: No additional ingress controller overhead
- **Modern**: Pure Gateway API v1.0.0 implementation
