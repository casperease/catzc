# docs/how-to/automation/manual-test-plan/azure.md

`Manual test plan — Azure`

The shipped Azure configs and bicep templates. Part of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                              | FullNameFilter                   | Guards                                                                                                    |
| --- | ---- | ---------------------------------------------------------------------- | -------------------------------- | --------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/Catzc.Azure/tests/Assert-AzureConfig.Tests.ps1              | integrity (shipped azure.yml)    | The shipped `azure.yml` passes schema + cross-record validation.                                          |
| 2   | L0   | automation/Catzc.Azure/tests/Assert-NetworkConfig.Tests.ps1            | integrity (shipped network.yml)  | The shipped `network.yml` has valid CIDRs and env completeness.                                           |
| 3   | L0   | automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1 | Shipped template integrity       | Every shipped template is discoverable, well-formed, and structurally valid.                              |
| 4   | L0   | automation/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1  | Shipped asset integrity          | Templates reference only defined environments and customers.                                              |
| 5   | L0   | automation/Catzc.Azure/tests/Assert-CustomerConfig.Tests.ps1           | integrity (shipped customer.yml) | The shipped customer.yml validates — customer keys/shortcodes are well-formed, unique, and non-colliding. |

## Checks

### 1. integrity (shipped azure.yml)

**Guards:** the shipped `azure.yml` is schema-valid and internally consistent.

**Checks:**

- `Assert-AzureConfig` accepts the shipped `azure.yml` (tenants, subscriptions, environments, customers).

### 2. integrity (shipped network.yml)

**Guards:** the shipped `network.yml` is valid and complete relative to `azure.yml`.

**Checks:**

- `Assert-NetworkConfig` accepts the shipped `network.yml` (valid CIDRs, every standard env present).

### 3. Shipped template integrity

**Guards:** every shipped bicep template is discoverable and structurally valid.

**Checks:**

- Discovery finds the templates; at least one exists.
- Every template declares a `short_name` in `options.yml`; `short_name`s are globally unique.
- Every template has a configuration slot and passes `Assert-BicepTemplate` (no build).

### 4. Shipped asset integrity

**Guards:** cross-asset referential integrity across `azure.yml`, `network.yml`, and templates.

**Checks:**

- `azure.yml` and `network.yml` pass their validators.
- Every template slot references environments and customers defined in `azure.yml`.
