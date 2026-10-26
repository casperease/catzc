# Manual test plan — Azure

The shipped Azure configs and bicep templates. Part of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                                  |
| --- | ---- | -------------------------------------------------------------------------------------- |
| 1   | L0   | [integrity (shipped azure.yml)][c1]                                                    |
| 2   | L0   | [integrity (shipped network.yml)][c2]                                                  |
| 3   | L0   | [Shipped template integrity][c3]                                                       |
| 4   | L0   | [Shipped asset integrity][c4]                                                          |
| 5   | L0   | [integrity (shipped customer.yml)][c5]                                                 |
| 6   | L0   | [Azure network plan sync][c6]                                                          |
| 7   | L2   | [Shipped template parameter model][c7]                                                 |
| 8   | L1   | [Get-BicepTemplatesRoot — the real repository][c8]                                     |
| 9   | L2   | [BicepParamWriter — bicep format leaves the render unchanged][c9]                      |
| 10  | L2   | [ConvertTo-BicepParam — every shipped yml slot renders as bicep format leaves it][c10] |
| 11  | L2   | [Every slot compiles through the .bicepparam path to the same parameters][c11]         |

[c1]: #1-integrity-shipped-azureyml
[c2]: #2-integrity-shipped-networkyml
[c3]: #3-shipped-template-integrity
[c4]: #4-shipped-asset-integrity
[c5]: #5-integrity-shipped-customeryml
[c6]: #6-azure-network-plan-sync
[c7]: #7-shipped-template-parameter-model
[c8]: #8-get-biceptemplatesroot--the-real-repository
[c9]: #9-bicepparamwriter--bicep-format-leaves-the-render-unchanged
[c10]: #10-convertto-bicepparam--every-shipped-yml-slot-renders-as-bicep-format-leaves-it
[c11]: #11-every-slot-compiles-through-the-bicepparam-path-to-the-same-parameters

## Checks

### 1. integrity (shipped azure.yml)

**Test file:** `pwsh/Azure/tests/types/AzureConfig.Tests.ps1` (L0), block `integrity (shipped azure.yml)`.

**Guards:** the shipped `azure.yml` is schema-valid and internally consistent.

**Checks:**

- The shipped `azure.yml` loads through `Get-Config` as an `AzureConfig` (tenants, subscriptions, environments).
- Every shipped subscription's customer resolves in `customer.yml`, by key or shortcode.
- Every shipped customer — and the non-customer set — serves each environment through exactly one subscription.

### 2. integrity (shipped network.yml)

**Test file:** `pwsh/Azure/tests/types/NetworkConfig.Tests.ps1` (L0), block `integrity (shipped network.yml)`.

**Guards:** the shipped `network.yml` is valid on its own; its sync with `azure.yml` is row 6.

**Checks:**

- The shipped `network.yml` loads through `Get-Config` as a `NetworkConfig` (well-formed entries, valid CIDRs).

### 3. Shipped template integrity

**Test file:** `pwsh/Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` (L0), block `Shipped template integrity`.

**Guards:** every shipped bicep template is discoverable and structurally valid.

**Checks:**

- Discovery finds the templates; at least one exists.
- Every template declares a `short_name` in `options.yml`; `short_name`s are globally unique.
- Every template has a configuration slot and passes `Assert-BicepTemplate` (no build).

### 4. Shipped asset integrity

**Test file:** `pwsh/Azure.Templates/tests/Get-Config.Integrity.Tests.ps1` (L0), block `Shipped asset integrity`.

**Guards:** cross-asset referential integrity across `azure.yml`, `network.yml`, and templates.

**Checks:**

- `azure.yml` and `network.yml` load through their config types (`AzureConfig`, `NetworkConfig`).
- Every template slot references environments and customers defined in `azure.yml`.

### 5. integrity (shipped customer.yml)

**Test file:** `pwsh/Azure/tests/types/CustomerConfig.Tests.ps1` (L0), block `integrity (shipped customer.yml)`.

**Guards:** The shipped customer.yml loads through `CustomerConfig` — customer keys/shortcodes are well-formed, unique, and non-colliding.

### 6. Azure network plan sync

**Test file:** `pwsh/Azure/tests/Test-AzureNetworkPlan.Tests.ps1` (L0), block `Azure network plan sync`.

**Guards:** `Test-AzureNetworkPlan` reports 0 issues: the shipped `network.yml` and the `azure.yml` environments are in sync
(ADR-AZ-NETWORK-KEYEDBYENVIRONMENT).

### 7. Shipped template parameter model

**Test file:** `pwsh/Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` (L2), block `Shipped template parameter model`.

**Guards:** every shipped template's parameters files keep the contract its compiled `main.json` declares
(ADR-AZ-DATAMOD-PARAMETERCONTRACT).

**Checks:**

- Each template, discovered with `Get-BicepTemplateNames`, builds with the real `az bicep build` into the test's own output folder; without
  `az` the test skips (`tool_az_missing`).
- `Get-BicepParameterViolations` reports nothing for the rendered parameters files: every value has the declared type, lies within its
  `@allowed` values and bounds, and names a declared parameter; every parameter without a default is supplied; a secure parameter carries a
  well-formed Key Vault reference, never a literal.
- It runs with `Test-Automation -Suite infrastructure`, the `infrastructure` globset's verify scope (ADR-AUTO-TEST-TESTSUITE).

### 8. Get-BicepTemplatesRoot — the real repository

**Test file:** `pwsh/Azure.Templates/tests/Get-BicepTemplatesRoot.Tests.ps1` (L1), block
`Get-BicepTemplatesRoot — the real repository`.

**Guards:** `Get-BicepTemplatesRoot` resolves the folder that holds the shipped templates.

### 9. BicepParamWriter — bicep format leaves the render unchanged

**Test file:** `pwsh/Azure.Templates/tests/types/BicepParamWriter.Tests.ps1` (L2), block
`BicepParamWriter — bicep format leaves the render unchanged`.

**Guards:** A slot rendered by `BicepParamWriter` is left unchanged by `bicep format` at the pin.

### 10. ConvertTo-BicepParam — every shipped yml slot renders as bicep format leaves it

**Test file:** `pwsh/Azure.Templates/tests/ConvertTo-BicepParam.Tests.ps1` (L2), block
`ConvertTo-BicepParam — every shipped yml slot renders as bicep format leaves it`.

**Guards:** Every shipped yml slot, addresses resolved, renders as `bicep format` leaves it.

### 11. Every slot compiles through the .bicepparam path to the same parameters

**Test file:** `pwsh/Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` (L2), block
`Every slot compiles through the .bicepparam path to the same parameters`.

**Guards:** Every yml slot compiled through `bicep build-params` holds exactly the values of its `ConvertTo-Json` parameters file.
