# Migration to Cilium Gateway API

## Overview
This migration moves from Kong to Cilium Gateway API while preserving all Kong code for potential future use.

## What Changed

### 1. Kong Disabled (Code Preserved)
- **File**: `homelab-infra/modules/k8s/cluster/main.tf`
- Kong deployment commented out
- All Kong code remains in repository

### 2. Cilium (Pre-installed by DigitalOcean)
- **No installation needed**: Cilium is pre-installed on all DOKS clusters
- **GatewayClass managed by DigitalOcean**: No need to create or manage it
- Simply use `gatewayClassName: cilium` in your Gateway resources

### 3. Gateway Classes
- **File**: `homelab-terraform-modules/digitalocean/kubernetes/config/gateway_classes.tf`
- Kong GatewayClass preserved but won't be created (no Kong deployment)
- Cilium GatewayClass is managed by DigitalOcean (no Terraform resource needed)

### 4. ArgoCD Configuration
- **File**: `homelab-terraform-modules/digitalocean/kubernetes/config/helm_values/argo_cd_values.yaml`
- Kong Ingress disabled (code commented out)
- **File**: `homelab-terraform-modules/digitalocean/kubernetes/config/gateway_manifests.tf`
- New Gateway API manifests for ArgoCD using Cilium

### 5. Dependencies Updated
- All Helm releases now depend on Cilium instead of Kong
- cert-manager, ArgoCD, Argo Rollouts updated

### 6. Ingress Class
- Changed from `kong` to `cilium` in issuer_type configuration

## How to Apply

1. **Commit changes** to homelab-terraform-modules repo
2. **Tag new version** (e.g., v3.10.0)
3. **Update homelab-infra** to use new module version
4. **Run Terraform**:
   ```bash
   cd homelab-infra/live/dev/k8s/cluster
   terragrunt plan
   terragrunt apply
   ```

## What Gets Created

### Cilium Resources
- **Nothing** - Cilium and GatewayClass are pre-installed and managed by DigitalOcean

### ArgoCD Gateway API Resources
- Gateway: `argocd-gateway` in `argocd` namespace
- HTTPRoute: `argocd-route` in `argocd` namespace
- Certificate: `argocd-tls` in `argocd` namespace

## Rollback Plan

To rollback to Kong:

1. **Uncomment Kong deployment** in `homelab-infra/modules/k8s/cluster/main.tf`:
   ```hcl
   deploy_kong = {
     kong = {
       version             = "2.52.0"
       gateway_api_enabled = true
     }
   }
   ```

2. **Restore ArgoCD Ingress** in `argo_cd_values.yaml`:
   - Uncomment Kong ingress configuration
   - Set `ingress.enabled: true`

3. **Update dependencies** in `helm_releases.tf`:
   - Add back `helm_release.kong` dependencies
   - Add back `kubectl_manifest.kong_gatewayclass` dependencies

4. **Update issuer_type**:
   ```hcl
   ingress_class = "kong"
   ```

## Benefits of Cilium

- **Native DigitalOcean Integration**: Uses pre-installed Cilium
- **Performance**: eBPF-based networking
- **Simplicity**: Single Gateway API implementation
- **Cost**: No additional ingress controller overhead
- **Modern**: Gateway API v1.0.0 standard

## Testing

After applying:

1. **Verify Cilium is running** (pre-installed by DigitalOcean):
   ```bash
   kubectl get pods -n kube-system -l k8s-app=cilium
   ```

2. **Verify GatewayClass** (managed by DigitalOcean):
   ```bash
   kubectl get gatewayclass
   ```

3. **Check ArgoCD Gateway**:
   ```bash
   kubectl get gateway -n argocd
   kubectl get httproute -n argocd
   ```

4. **Test ArgoCD access**:
   ```bash
   curl -I https://argocd.devopshomelab.live
   ```
