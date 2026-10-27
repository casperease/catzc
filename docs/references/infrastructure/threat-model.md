# threat-model

The threat model of the three templates and the pipeline that deploys them, by trust boundary and STRIDE category: what each boundary holds
against, and what it does not yet hold. Each holding names the template, module, policy or gate that carries it. The design rules behind it
are the [Azure ADRs](../../drs/azure/).

## Boundaries

- **The repository to the pipeline.** A change reaches Azure only by a merge to `main` and a pipeline run.
- **The pipeline to Azure.** A deploy runs through one service connection per subscription, pinned to that subscription on every call.
- **`foundation`.** The once-per-subscription baseline: the Log Analytics workspace and the Key Vault.
- **`discovery`.** The landing zone per subscription: the hub or spoke network, the policy assignments and the budget.
- **`expedition`.** The workload: storage and SQL behind private endpoints.

## Spoofing

- Holds: a deploy is pinned to its subscription by `-SubscriptionIdAssertIs`, so a service connection pointed at the wrong subscription
  stops before it deploys. SQL accepts Entra ID authentication only (`entraOnlyAuthentication`), and storage refuses shared keys
  (`allowSharedKeyAccess` off).
- Open: no conditional access or workload-identity federation is declared for the service connections; they are configured in Azure DevOps,
  outside the tree.

## Tampering

- Holds: every resource is declared in Bicep under version control, so a change is a reviewed commit; the Bicep linter and the API-version
  quality gate check every template and module (`Test-BicepLint`, `Test-BicepApiVersions`); each deploy tags its target with the commit, the build
  id and the branch, so drift from the tree can be traced.
- Open: no what-if runs before a pipeline deploy, so a deploy's effect is not shown before it applies.

## Repudiation

- Holds: the subscription's activity log goes to the Log Analytics workspace (`subscription-diagnostic-setting.bicep`), and the data
  resources send their logs and metrics there (`diagnostic-setting.bicep`).

## Information disclosure

- Holds: a secure parameter is a Key Vault reference, never a literal, and the parameter contract is checked on every rendered parameters
  file; the vault, the storage account and the SQL server have public network access off and are reached through private endpoints; the
  `discovery` policies deny storage and SQL with public network access and a public IP on a network interface; the secret-scan quality gate
  (`Test-SecretScan`) fails a change that carries a key, a private key or a connection string with a password.
- Open: no dependency scan checks the pinned tools and lock files against advisories.

## Denial of service

- Holds: the budget alerts the subscription's owners at its thresholds (`budget.bicep`), so runaway cost is seen. SQL backups are
  geo-redundant and storage is zone-redundant by default.
- Open: no DDoS protection plan is declared on the hub network.

## Elevation of privilege

- Holds: the Key Vault authorizes by role assignment only, with no access policies, and purge protection is always on; a policy that
  remediates is granted only the roles it lists (`policy-assignment.bicep`).
- Open: no required-reviewer policy is configured on the deploy pipelines; the approvals are Azure DevOps checks, outside the tree.
