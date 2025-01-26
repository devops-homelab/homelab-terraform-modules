# Homelab Terraform Modules

This repository contains a collection of Terraform modules for managing infrastructure in a homelab environment. The modules are designed to work with various cloud providers, including DigitalOcean and AWS.

## Modules

### DigitalOcean

- **Kubernetes**: Module for creating and managing a Kubernetes cluster on DigitalOcean.
  - `main.tf`: Defines the resources for the Kubernetes cluster.
  - `variables.tf`: Defines the input variables for the module.
  - `outputs.tf`: Defines the outputs for the module.
  - `versions.tf`: Specifies the required Terraform and provider versions.

- **VPC**: Module for creating and managing a Virtual Private Cloud (VPC) on DigitalOcean.
  - `main.tf`: Defines the resources for the VPC.
  - `variables.tf`: Defines the input variables for the module.
  - `outputs.tf`: Defines the outputs for the module.
  - `versions.tf`: Specifies the required Terraform and provider versions.

### AWS

- **Kubernetes**: Module for creating and managing a Kubernetes cluster on AWS.
  - `main.tf`: Defines the resources for the Kubernetes cluster.
  - `variables.tf`: Defines the input variables for the module.
  - `outputs.tf`: Defines the outputs for the module.
  - `versions.tf`: Specifies the required Terraform and provider versions.

- **VPC**: Module for creating and managing a Virtual Private Cloud (VPC) on AWS.
  - `main.tf`: Defines the resources for the VPC.
  - `variables.tf`: Defines the input variables for the module.
  - `outputs.tf`: Defines the outputs for the module.
  - `versions.tf`: Specifies the required Terraform and provider versions.

## Usage

To use these modules, include them in your Terraform configuration files. For example, to use the DigitalOcean Kubernetes module:

```hcl
module "digitalocean_kubernetes" {
  source          = "github.com/devops-homelab/homelab-terraform-modules.git//digitalocean/kubernetes/?ref=main"
  name            = var.name
  environment     = var.environment
  region          = var.region
  cluster_version = var.cluster_version
  vpc_uuid        = var.vpc_uuid

  infra_node_pool = var.infra_node_pool
  app_node_pool   = var.app_node_pool
}
```

## Inputs

Each module has its own set of input variables defined in the \`variables.tf\` file. Refer to the specific module\'s \`variables.tf\` file for details on the required and optional inputs.

## Outputs

Each module has its own set of outputs defined in the \`outputs.tf\` file. Refer to the specific module\'s \`outputs.tf\` file for details on the available outputs.

## Requirements

- Terraform >= 1.4.6
- DigitalOcean Provider >= 2.28.1 (for DigitalOcean modules)
- AWS Provider >= 3.0.0 (for AWS modules)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.' > README.md