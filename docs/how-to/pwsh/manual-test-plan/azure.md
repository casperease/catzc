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
| 12  | L1   | [Catzc.Azure.RolesConfig — shipped roles.yml][c12]                                     |
| 13  | L1   | [Catzc.Azure.DevOps.ServiceConnectionsConfig — shipped service-connections.yml][c13]   |
| 14  | L1   | [Alerts: every compiled slot][c14]                                                     |
| 15  | L3   | [Deploy-Bicep to an ephemeral l3 slot (live Azure)][c15]                               |
| 16  | L1   | [discovery flow logs: every compiled slot][c16]                                        |
| 17  | L1   | [foundation PrePost: every compiled slot][c17]                                         |
| 18  | L1   | [Hub firewall and routes: every compiled discovery slot][c18]                          |
| 19  | L1   | [The break-glass rotation pipeline][c19]                                               |
| 20  | L1   | [CanNotDelete locks: every compiled slot][c20]                                         |
| 21  | L1   | [Monitoring views: every compiled foundation slot][c21]                                |
| 22  | L1   | [Security-group flows: the compiled discovery template][c22]                           |
| 23  | L1   | [Production database alerts: every compiled expedition and discovery slot][c23]        |
| 24  | L1   | [Test-BicepResourceNames (real templates)][c24]                                        |
| 25  | L1   | [Test-BicepTemplateCompliance (real templates)][c25]                                   |
| 26  | L1   | [Test-BicepApiVersions (real modules)][c26]                                            |

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
[c12]: #12-catzcazurerolesconfig--shipped-rolesyml
[c13]: #13-catzcazuredevopsserviceconnectionsconfig--shipped-service-connectionsyml
[c14]: #14-alerts-every-compiled-slot
[c15]: #15-deploy-bicep-to-an-ephemeral-l3-slot-live-azure
[c16]: #16-discovery-flow-logs-every-compiled-slot
[c17]: #17-foundation-prepost-every-compiled-slot
[c18]: #18-hub-firewall-and-routes-every-compiled-discovery-slot
[c19]: #19-the-break-glass-rotation-pipeline
[c20]: #20-cannotdelete-locks-every-compiled-slot
[c21]: #21-monitoring-views-every-compiled-foundation-slot
[c22]: #22-security-group-flows-the-compiled-discovery-template
[c23]: #23-production-database-alerts-every-compiled-expedition-and-discovery-slot
[c24]: #24-test-bicepresourcenames-real-templates
[c25]: #25-test-biceptemplatecompliance-real-templates
[c26]: #26-test-bicepapiversions-real-modules

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

- Each template, discovered with `Get-BicepTemplateNames`, builds with the real `bicep build` into the test's own output folder; without the
  pinned `bicep` the test skips (`tool_bicep_missing`).
- `Get-BicepParameterViolations` reports nothing for the rendered parameters files: every value has the declared type, lies within its
  `@allowed` values and bounds, and names a declared parameter; every parameter without a default is supplied; a secure parameter carries a
  well-formed Key Vault reference, never a literal.
- It runs with `Test-Automation -Suite infrastructure`, the `infrastructure` globset's verify scope (ADR-AUTO-TEST-TESTSUITE).

### 8. Get-BicepTemplatesRoot — the real repository

**Test file:** `pwsh/Azure.Templates/tests/Get-BicepTemplatesRoot.Tests.ps1` (L1), block `Get-BicepTemplatesRoot — the real repository`.

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

### 12. Catzc.Azure.RolesConfig — shipped roles.yml

**Test file:** `pwsh/Azure/tests/types/RolesConfig.Tests.ps1` (L1), block `Catzc.Azure.RolesConfig — shipped roles.yml`.

**Guards:** The shipped `roles.yml` loads and holds the Owner role the action group addresses.

### 13. Catzc.Azure.DevOps.ServiceConnectionsConfig — shipped service-connections.yml

**Test file:** `pwsh/Azure.DevOps/tests/Sync-AdoServiceConnections.Tests.ps1` (L1), block
`Catzc.Azure.DevOps.ServiceConnectionsConfig — shipped service-connections.yml`.

**Guards:** Every shipped service connection names a subscription configured in `azure.yml`.

### 14. Alerts: every compiled slot

**Test file:** `pwsh/Azure.Templates/tests/Alerts.Tests.ps1` (L1), block `Alerts: every compiled slot`.

**Guards:** The compiled templates deploy the alerting every slot needs.

**Checks:**

- Every foundation slot has one action group, addressed to the Owner role.
- Every expedition SQL server is audited into the workspace and alerts on any sign-in of its break-glass login.
- Every discovery slot has a Service Health and a Resource Health alert that notify the action group.

### 15. Deploy-Bicep to an ephemeral l3 slot (live Azure)

**Test file:** `pwsh/Azure.Templates/tests/Deploy-Bicep.L3.Tests.ps1` (L3), block `Deploy-Bicep to an ephemeral l3 slot (live Azure)`.

**Guards:** Each template deploys to a live l3 slot in the session's subscription; without a session the block skips.

**Checks:**

- Each template deploys, its resource group is tagged with where it came from, and no group is left behind.

### 16. discovery flow logs: every compiled slot

**Test file:** `pwsh/Azure.Templates/tests/Discovery.FlowLog.Tests.ps1` (L1), block `discovery flow logs: every compiled slot`.

**Guards:** Every discovery slot deploys a flow log on its virtual network, under the region's Network Watcher.

### 17. foundation PrePost: every compiled slot

**Test file:** `pwsh/Azure.Templates/tests/Foundation.PrePost.Tests.ps1` (L1), block `foundation PrePost: every compiled slot`.

**Guards:** The foundation Key Vault private endpoint is deployed exactly where the slot asks for it.

**Checks:**

- Every foundation slot deploys the vault's private endpoint under its derived name.
- The bootstrap pass, a slot that sets `deployKeyVaultPrivateEndpoint` to false, deploys no endpoint.

### 18. Hub firewall and routes: every compiled discovery slot

**Test file:** `pwsh/Azure.Templates/tests/HubFirewall.Tests.ps1` (L1), block `Hub firewall and routes: every compiled discovery slot`.

**Guards:** Hub egress goes through one firewall, and every spoke routes to it.

**Checks:**

- Each hub's firewall address is the first one Azure assigns in its `AzureFirewallSubnet`.
- Every hub deploys one firewall, its policy at the `network.yml` tier and its egress diagnostics; no spoke deploys one.
- Every spoke subnet routes its egress to its hub's firewall address.

### 19. The break-glass rotation pipeline

**Test file:** `pwsh/Azure.Templates/tests/Invoke-BreakGlassRotation.Tests.ps1` (L1), block `The break-glass rotation pipeline`.

**Guards:** The shipped `cron-break-glass-rotation.yaml` runs the rotation monthly, signed in through the deploy service connection.

### 20. CanNotDelete locks: every compiled slot

**Test file:** `pwsh/Azure.Templates/tests/Locks.Tests.ps1` (L1), block `CanNotDelete locks: every compiled slot`.

**Guards:** The compiled templates lock exactly the resources that must not be deleted.

**Checks:**

- The hub's virtual network and each of its private DNS zones are locked.
- Nothing in a spoke is locked.
- Foundation's Key Vault is locked in every slot.

### 21. Monitoring views: every compiled foundation slot

**Test file:** `pwsh/Azure.Templates/tests/MonitoringViews.Tests.ps1` (L1), block `Monitoring views: every compiled foundation slot`.

**Guards:** Every foundation slot deploys the capacity workbook, the saved-query pack and the dashboard, each under its derived name.

### 22. Security-group flows: the compiled discovery template

**Test file:** `pwsh/Azure.Templates/tests/NsgFlows.Tests.ps1` (L1), block `Security-group flows: the compiled discovery template`.

**Guards:** The discovery security groups allow only the declared flows.

**Checks:**

- Every slot gets the declared flows, no wider than the landing zone needs.
- The blanket virtual-network allow is replaced by the declared flows, then a deny of the network and the internet.

### 23. Production database alerts: every compiled expedition and discovery slot

**Test file:** `pwsh/Azure.Templates/tests/ProductionAlerts.Tests.ps1` (L1), block
`Production database alerts: every compiled expedition and discovery slot`.

**Guards:** Production slots carry the database alerts, and every alert is named through the namer.

**Checks:**

- The five database metric and capacity alerts deploy in every production slot and in no other.
- Each database alert, the break-glass login alert and the two discovery health alerts carry a derived `alrt` name.

### 24. Test-BicepResourceNames (real templates)

**Test file:** `pwsh/Azure.Templates/tests/Test-BicepResourceNames.Tests.ps1` (L1), block `Test-BicepResourceNames (real templates)`.

**Guards:** No shipped slot writes a name its template derives, and every declared name derives for every slot.

### 25. Test-BicepTemplateCompliance (real templates)

**Test file:** `pwsh/Azure.Templates/tests/Test-BicepTemplateCompliance.Tests.ps1` (L1), block
`Test-BicepTemplateCompliance (real templates)`.

**Guards:** Every compiled template slot holds to the compliance rules but for the known findings, and every known finding still occurs.

### 26. Test-BicepApiVersions (real modules)

**Test file:** `pwsh/Base.QualityGates/tests/Test-BicepApiVersions.Tests.ps1` (L1), block `Test-BicepApiVersions (real modules)`.

**Guards:** Every API version the shipped Bicep modules reference is current, stable or pinned.
