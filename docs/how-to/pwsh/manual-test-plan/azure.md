# Manual test plan — Azure

The shipped Azure configs and bicep templates. Part of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                  | FullNameFilter                                                                  | Guards                                                                                                                                                                                                 |
| --- | ---- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L0   | pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1                         | integrity (shipped azure.yml)                                                   | The shipped `azure.yml` loads through `AzureConfig` (schema + cross-record validation), and its customer references resolve.                                                                           |
| 2   | L0   | pwsh/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1                       | integrity (shipped network.yml)                                                 | The shipped `network.yml` loads through `NetworkConfig`: well-formed entries with valid CIDRs.                                                                                                         |
| 3   | L0   | pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1           | Shipped template integrity                                                      | Every shipped template is discoverable, well-formed, and structurally valid.                                                                                                                           |
| 4   | L0   | pwsh/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1            | Shipped asset integrity                                                         | Templates reference only defined environments and customers.                                                                                                                                           |
| 5   | L0   | pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1                      | integrity (shipped customer.yml)                                                | The shipped customer.yml loads through `CustomerConfig` — customer keys/shortcodes are well-formed, unique, and non-colliding.                                                                         |
| 6   | L0   | pwsh/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1                     | Azure network plan sync                                                         | `Test-AzureNetworkPlan` reports 0 issues: the shipped `network.yml` and the `azure.yml` environments are in sync (ADR-AZ-NETWORK-KEYEDBYENVIRONMENT).                                                  |
| 7   | L2   | pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1 | Shipped template parameter model                                                | Every shipped template's rendered parameters files satisfy its compiled parameter model (ADR-AZ-DATAMOD-PARAMETERCONTRACT); `Test-Automation -Suite infrastructure` runs it (ADR-AUTO-TEST-TESTSUITE). |
| 8   | L1   | pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplatesRoot.Tests.ps1          | Get-BicepTemplatesRoot — the real repository                                    | `Get-BicepTemplatesRoot` resolves the folder that holds the shipped templates.                                                                                                                         |
| 9   | L2   | pwsh/Catzc.Azure.Templates/tests/types/BicepParamWriter.Tests.ps1          | BicepParamWriter — bicep format leaves the render unchanged                     | A slot rendered by `BicepParamWriter` is left unchanged by `bicep format` at the pin.                                                                                                          |
| 10  | L2   | pwsh/Catzc.Azure.Templates/tests/ConvertTo-BicepParam.Tests.ps1            | ConvertTo-BicepParam — every shipped yml slot renders as bicep format leaves it | Every shipped yml slot, addresses resolved, renders as `bicep format` leaves it.                                                                                                                       |
| 11  | L2   | pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1           | Every slot compiles through the .bicepparam path to the same parameters       | Every yml slot compiled through `bicep build-params` holds exactly the values of its `ConvertTo-Json` parameters file.                                                                         |

## Checks

### 1. integrity (shipped azure.yml)

**Guards:** the shipped `azure.yml` is schema-valid and internally consistent.

**Checks:**

- The shipped `azure.yml` loads through `Get-Config` as an `AzureConfig` (tenants, subscriptions, environments).
- Every shipped subscription's customer resolves in `customer.yml`, by key or shortcode.
- Every shipped customer — and the non-customer set — serves each environment through exactly one subscription.

### 2. integrity (shipped network.yml)

**Guards:** the shipped `network.yml` is valid on its own; its sync with `azure.yml` is row 6.

**Checks:**

- The shipped `network.yml` loads through `Get-Config` as a `NetworkConfig` (well-formed entries, valid CIDRs).

### 3. Shipped template integrity

**Guards:** every shipped bicep template is discoverable and structurally valid.

**Checks:**

- Discovery finds the templates; at least one exists.
- Every template declares a `short_name` in `options.yml`; `short_name`s are globally unique.
- Every template has a configuration slot and passes `Assert-BicepTemplate` (no build).

### 4. Shipped asset integrity

**Guards:** cross-asset referential integrity across `azure.yml`, `network.yml`, and templates.

**Checks:**

- `azure.yml` and `network.yml` load through their config types (`AzureConfig`, `NetworkConfig`).
- Every template slot references environments and customers defined in `azure.yml`.

### 7. Shipped template parameter model

**Guards:** every shipped template's parameters files keep the contract its compiled `main.json` declares
(ADR-AZ-DATAMOD-PARAMETERCONTRACT).

**Checks:**

- Each template, discovered with `Get-BicepTemplateNames`, builds with the real `az bicep build` into the test's own output folder; without
  `az` the test skips (`tool_az_missing`).
- `Get-BicepParameterViolations` reports nothing for the rendered parameters files: every value has the declared type, lies within its
  `@allowed` values and bounds, and names a declared parameter; every parameter without a default is supplied; a secure parameter carries a
  well-formed Key Vault reference, never a literal.
- It runs with `Test-Automation -Suite infrastructure`, the `infrastructure` globset's verify scope (ADR-AUTO-TEST-TESTSUITE).
