---
catzc:
  immutable:
    with_body_sha: e3acb8a92042
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-templates-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AZ-NAMING#2
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1

<!-- cspell:ignore etlco -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($null -eq...`, written with `#`.

```text
Filesystem-derived information is cached for the session, lazily on first use, keyed on the discovery
root + the output root — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md). The on-disk file set is fixed at importer time
(pipeline: static checkout; devbox: re-run the importer after editing files), so re-running the
importer is the only invalidation. Keying on the root lets tests redirect discovery to a fixture
tree (Mock Get-BicepTemplatesRoot) or the build output to a folder of their own (Mock
Get-BicepTemplatesOutputRoot) without colliding with the real cache entry. Callers must
treat the result as read-only (the same object is returned every call).
```

## comment:2

Above `$script:bicepTemplatesCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:3

Above `$azure = Get-Config -Config azure`, written with `#`.

```text
A config lives at the configuration root (`<env>[-<slot>].yml` — the shared platform) or under a
configuration/<customer>/ subfolder (the folder is a customer key). The subscription is resolved
per config; both checks (subfolder is a defined customer key, the coordinate resolves to exactly
one subscription) run at discovery via the shared Get-BicepSubscriptionConfigViolations.
```

## comment:4

Above `foreach ($folderPath in...`, written with `#`.

```text
Enumerate with [System.IO.Directory] (sorted to keep output deterministic) rather than Get-ChildItem:
the cmdlet carries ~20ms of provider overhead PER CALL on Windows, and discovery makes dozens of these
calls — it was the dominant cost of a cold discovery (~0.8s of ~1.2s). The raw .NET enumerators are
~0.1ms. Same approach as Resolve-ConfigEntry.
```

## comment:5

Above `$environmentKind = if ($options.Contains('environment_kind')) {`, written with `#`.

```text
Env-class template classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): the env-class bit
(standard/subscription, default standard). Every config below must match it. The slot is a
per-config dimension, not a template bit — a template may mix slotted and non-slotted configs.
```

## comment:6

Above `$customerDeploymentOption = if ($options.Contains('customer_deployment')) {`, written with `#`.

```text
Customer-class bit
([ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)): whether this is a customer template. It
defaults to the have_customers repo variant (Test-HaveCustomers) unless options.yml sets it. An
explicit customer_deployment: true is only allowed when customers are enabled (the repo-level guard).
```

## comment:7

Above `$shortNameOverride = if ($options.Contains('short_name')) {`, written with `#`.

```text
short_name is the Azure id segment every resource name is built from. It is DERIVED from the folder
name by default; an options.yml `short_name` overrides it. BicepShortName owns the derivation +
format validation (a malformed override, or a folder that cannot yield a valid short_name without an
override, throws here — naming the template). See
[ADR-AZ-NAMING#2](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2).
```

## comment:8

Above `$configEntries = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Gather every config file with its customer (the subfolder; '' for a configuration-root config).
Root files first, then the customer subfolders — both sorted, so output stays deterministic.
```

## comment:9

Above `$slots = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Each config file is one slot (one resource group). The filename `<env>[-<slot>]` resolves to
its environment + slot via Resolve-BicepConfigName (`default.yml` is a reserved skip); the
subscription is resolved from the (customer?, env) coordinate — one config file ⟷ one
(customer?, env, slot) ⟷ one subscription ⟷ one RG.
```

## comment:10

Above `foreach ($key in @($options.Keys)) {`, written with `#`.

```text
Overlay the remaining deployment overrides. short_name is resolved via BicepShortName and
environment_kind / customer_deployment are already applied above, so all three are excluded here.
```
