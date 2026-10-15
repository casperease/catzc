# Plan: CAF/WAF phase 2 — automation and templates

Phase 1 (done) recorded every WAF checklist item and CAF design-area recommendation as a rule in `docs/adr/azure/waf/` (5 ADRs) and
`docs/adr/azure/caf/` (12 ADRs), each with a status line. This plan turns the **planned (follow-up)** status lines into work, grouped so one
change closes many rules. Rule references are `ADR-AZ-<CODE>#n`. The decisions in §1 come first: several workstreams depend on them.

## 1. Decisions

**Decided by the user (2026-10-15):** every recommendation below is taken, except **D8: keep** `vm.bicep` and `data-factory.bicep` — W2
gives them the secure defaults (no public IP on `vm.bicep`, Bastion access; public network access off on Data Factory). D1–D4 were chosen
explicitly: a DEPLOY pipeline for production with a what-if step; one break-glass secret per configuration slot; a tenant check in
`Get-BicepDeploymentContext`; one service connection per environment plus a read-only one for `-DryRun`.

| #   | Question                                                                                                                                                           | Rules             | Recommendation                                                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------- | ---------------------------------------------------------------- |
| D1  | The CD pipelines deploy production in the same stage as non-production; ADR-FLOW-CD#5/#6 send prod through a DEPLOY pipeline. Fix the pipelines or accept the gap? | WAFOE, CAFDEVOPS  | Fix: a DEPLOY pipeline behind a manual gate, with a what-if step |
| D2  | One break-glass password per non-production subscription (dev/test share `exped-sql-admin-password`) — one per configuration slot?                                 | CAFSEC#26, CAFIAM | One per slot (secret name derived from the slot)                 |
| D3  | A deploy does not check the tenant. Add the check in `Get-BicepDeploymentContext`, or drop it?                                                                     | CAFBILL#41, #48   | Add it (azure.yml already knows the tenant)                      |
| D4  | One service connection per subscription, or per environment?                                                                                                       | CAFIAM#47, #54    | Per environment, plus a read-only one for `-DryRun`              |
| D5  | `discovery`'s `resourceGroupName` is hand-typed, against ADR-AZ-DATAMOD#5.                                                                                         | CAFNAME           | Derive it like every other resource-group name                   |
| D6  | Tracking-tag prefixes use the template folder name, against ADR-AZ-NAMING#2 (`short_name`).                                                                        | CAFNAME#14        | Use `short_name`, lowercase keys (a contract change)             |
| D7  | What the tracking tags record as the branch for a devbox deploy.                                                                                                   | CAFNAME           | `devbox` literal                                                 |
| D8  | `vm.bicep` and `data-factory.bicep` are unused (ADR-PRIN-ONELIVE). Keep or delete?                                                                                 | WAFRE, CAFNETCON  | Delete                                                           |
| D9  | Production database: provisioned (today) or serverless?                                                                                                            | WAFRE, WAFCO      | Keep provisioned                                                 |
| D10 | `/16` per network, or sized networks?                                                                                                                              | CAFNETTOP#32, #46 | Keep /16 until a range runs short                                |
| D11 | The shared platform's workload in the hub's `shared-services` subnet, or a minimal hub?                                                                            | CAFNETTOP#8       | Keep, recorded as a deviation                                    |
| D12 | Firewall SKU (Standard/Premium) as a per-hub config value?                                                                                                         | CAFNETCON#25      | Yes, default Standard                                            |
| D13 | More than one subscription per customer per environment class (ADR-AZ-DATAMOD#8 forbids it)?                                                                       | CAFRESORG         | Keep forbidden                                                   |
| D14 | Connectivity in its own subscription instead of `shared_*`?                                                                                                        | CAFRESORG#18      | Not now; rule 18 names the trigger                               |
| D15 | Audit redundancy and backup by policy, or by the build-time check (W1)?                                                                                            | CAFMGMT#10, #11   | Build-time check                                                 |
| D16 | Should the PE "not adopted" items (PE:01 targets, PE:04 alerts, PE:06 load tests) become planned?                                                                  | WAFPE             | PE:04 → planned (W4 covers it); the others stay                  |
| D17 | Allowed-SKU policy in `discovery`: firm, or planned?                                                                                                               | WAFCO#4           | Planned, after W1                                                |
| D18 | Repository visibility is a server setting; state a stance, or leave rule 19 "not adopted"?                                                                         | CAFDEVOPS#19      | Leave not adopted                                                |
| D19 | ADR-AZ-WAFSE#2 says CD deploys "non-production before production"; today they are jobs of one stage. Reword now, or let D1 make it true?                           | WAFSE#2           | Let D1 make it true; reword if D1 is declined                    |

## 2. Workstreams

### W1 — a gate over the compiled `main.json` (closes the most rules)

One quality gate reads every compiled template and asserts per resource: public network access off; TLS 1.2 minimum; the CAF tags; a
diagnostic setting for every resource kind that supports one; zone redundancy and geo-redundant backup in production configs; no public IP
address and default outbound access off; every `privateLinkServiceId` inside the same template; no preview API version. Rules:
WAFSE#1/6/8/10, WAFRE#5/#10, WAFCO#4/#8, WAFOE, CAFGOV#1/#10, CAFMGMT#16, CAFNETPRV, CAFNETCON#35, CAFPRIN#5. The checks are config entries
(one mechanism, one entry per check, ADR-AUTO-DEFAULT#6).

### W2 — secure defaults in the shared modules

- `key-vault.bicep`: purge protection on, public access off (keeping `enabledForTemplateDeployment`), diagnostics (WAFSE, CAFSEC, CAFMGMT).
- `virtual-network.bicep`: `defaultOutboundAccess: false` on subnets (CAFNETCON#35).
- `storage-account.bicep`: SKU, access tier, lifecycle policy as parameters (WAFCO#8, #10).
- `log-analytics.bicep`: pin resource-context access; `retentionInDays` per environment class from config (CAFIAM#38, CAFSEC).
- `sql-database.bicep`: maintenance window parameter; SQL auditing to the workspace (WAFPE, CAFIAM#29).
- `budget.bicep`: actual and forecast thresholds together (WAFCO#3).
- `vm.bicep` (kept, D8): no public IP, access through Bastion; `data-factory.bicep` (kept, D8): public network access off by default. Their
  status lines in WAFRE, CAFNETCON, and WAFSE move from "keep or delete" to these defaults.

### W3 — landing-zone additions (`discovery`, `foundation`)

- Azure Firewall per hub (`firewall.bicep`, SKU per D12), spoke default route, `allowForwardedTraffic`, `AzureFirewallManagementSubnet` in
  the required hub set (network.yml, NetworkConfig, ADR-AZ-NETWORK#5) (CAFNETCON#23/#24, WAFSE#6).
- Network Watcher, VNet flow logs with traffic analytics, flow-log storage in `foundation` (CAFNETTOP#26/#54, CAFNETCON#58/#59).
- NSG rules per subnet; built-in policy requiring an NSG per subnet, reserved subnets exempt (CAFNETTOP#50/#51/#53/#56).
- More built-in policies: public access off on storage and SQL, required diagnostic setting; MCSB initiative in audit mode (CAFPRIN#2,
  WAFSE).
- `lock.bicep` with `CanNotDelete` on the hub network and DNS zones (WAFRE, CAFMGMT).
- `privatelink.vaultcore.azure.net` zone in the hub, a vault private endpoint in `foundation` — this changes the deploy order (foundation
  then depends on discovery's network) (CAFSEC#21, CAFNETPRV).
- Defender plans (CAFSEC); cost export and anomaly alert (WAFCO#3, CAFGOV#9).

### W4 — alerting

`action-group.bicep` routed to the subscription's `Owner` role; Service Health and Resource Health alerts per subscription (discovery);
metric alerts on the production database (a new alert module, expedition) (WAFRE#10, CAFRESORG, CAFMGMT, WAFPE PE:04).

### W5 — identity as code

Standard role set (role ids in `guids.yml`, assigned to groups at subscription scope in `discovery`); data roles at the resource; a SQL
admin group per customer and environment; a break-glass secret per configuration slot (D2); a deploying identity per D4; workload identity
federation for every service connection, documented (CAFIAM#45/#47/#54/#57).

### W6 — deploy path (PowerShell)

- Tenant check in `Get-BicepDeploymentContext` (D3).
- CAF tags on the resource groups `Deploy-AzureResourceGroup` creates (CAFGOV#10, CAFNAME#21, WAFCO#3).
- Derived `discovery` resource-group name (D5); tracking-tag prefix fix (D6, D7).
- Orphan check: deployed resource groups versus the configuration tree (WAFCO#7).
- A tag schema declared once in `azure.yml` / `AzureConfig`, checked against every template config (CAFNAME#11/#12/#14).
- A name check: every config name parameter equals `Get-BicepResourceName`'s render (CAFNAME#2).
- A private-range check in `NetworkConfig`/`NetworkCidr` rejecting reserved and public ranges (CAFNETTOP#29/#30/#34).

### W7 — pipelines and repository

DEPLOY pipeline for production with a what-if step (D1); secret-scanning step in `ci-infrastructure`/`ci-automation`;
`infrastructure/bicepconfig.json` with linter rules at error; required reviewers (WAFOE, CAFDEVOPS).

From ADR-AZ-CAFDEVOPS:

- #1, #33: service connections, Azure DevOps environments, and their checks declared as code (a config plus a sync function beside
  `Catzc.Azure.DevOps.BuildValidation`).
- #3, #25, #26: reviewer, vote-reset, comment-resolution, and squash merge-type policies in `build-validation.yml`, applied by
  `Sync-AdoBuildValidations` (ADR-FLOW-CD-GLOBS#9 assumes squash merge; nothing sets it).
- #6: encode the spoke rollout order across `cd-shared.yaml` and the customer CD.
- #16: collect the DORA metrics from deploy runs or tracking tags.
- #32: an on-demand environment with system tests in CD (= W9).
- #34: `Deploy-Bicep -DryRun` before each pipeline deploy.
- #35: a DEPLOY pipeline that redeploys an earlier artifact; cleanup of resources removed from a template (deploy mode).

### W8 — documentation

Cost model and RPO/RTO per environment class in `docs/references/infrastructure/<template>.md` (WAFCO#2, WAFRE#4); a DR plan; how-tos for
seeding `exped-sql-admin-password`, the hub→spoke→hub rollout (ADR-AZ-LZ#7), and emergency changes; billing-meter notes per module.

### W9 — L3 tests

Deploy tests to an on-demand special slot (`Catzc.Azure.Templates/tests`), asserting the deployed state the W1 gate asserts at build time
(WAFSE, WAFOE).

## 3. Order

D1–D17 → W6 and W1 (no Azure needed; gates first) → W2 → W3 and W4 → W5 → W7 → W8 → W9. Each rule's status line moves from **planned
(follow-up)** to **realised** in the same change that realises it.

## 4. Open from the landing-zone change

ADO "validate YAML" on cd-apex/cd-flux; seed `exped-sql-admin-password` in each foundation vault; move the budget `startDate` (2026-11-01)
forward before the first deploy; typed config records serialise a stray `Keys` array (harmless). Also: `Get-ConfigValue` unrolls a 0/1-item
list; `policy_enforcement` is a dictionary, not a record type (ADR-AUTO-TYPES#9 could argue for one); ADR-AZ-LZ#7's hub → spokes → hub
rollout is manual today: encode it as one rollout pipeline, or as a pre-deploy guard that fails a hub listing a missing spoke (a decision
for the user).
