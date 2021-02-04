# Terrascan GitHub Action
This action runs Terrascan, a static code analyzer for infrastructure as code(IaC). Terrascan currently supports scanning of Terraform, Kubernetes, Helm, or Kustomize files for security best practices.

## Inputs
### `iac_type`
**Required** IaC type (helm, k8s, kustomize, terraform).

### `iac_dir`
Path to a directory containing one or more IaC files. Default `"."`.

### `iac_version`
IaC version (helm: v3, k8s: v1, kustomize: v3, terraform: v12, v14).

### `policy_path`
Policy path directory for custom policies.

### `policy_type`
Policy type (all, aws, azure, gcp, github, k8s). Default `all`.

### `skip_rules`
One or more rules to skip while scanning (example: "ruleID1,ruleID2").

### `config_path`
Config file path.

### `only_warn`
The action will only warn and not error when violations are found.

## Example usage

```yaml
on: [push]

jobs:
  terrascan_job:
    runs-on: ubuntu-latest
    name: terrascan-action
    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run Terrascan
      id: terrascan
      uses: accurics/terrascan-action@main
      with:
        iac_type: 'terraform'
        iac_version: 'v14'
        policy_type: 'aws'
        only_warn: true
        #iac_dir:
        #policy_path:
        #skip_rules:
        #config_path:
```
