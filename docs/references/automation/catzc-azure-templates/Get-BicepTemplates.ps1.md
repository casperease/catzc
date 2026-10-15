---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
    kind: comment-page
    body_sha: "7dfaa6251051"
    adrs:
      - ADR-AZ-NAMING#2
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1

<!-- cspell:ignore etlco -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:12

Above `if ($null -eq...`.

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

## comment:13

Above `$script:bicepTemplatesCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:14

Above `$azure = Get-Config -Config azure`.

```text
A config lives at the configuration root (`<env>[-<slot>].yml` — the shared platform) or under a
configuration/<customer>/ subfolder (the folder is a customer key). The subscription is resolved
per config; both checks (subfolder is a defined customer key, the coordinate resolves to exactly
one subscription) run at discovery via the shared Get-BicepSubscriptionConfigViolations.
```

## comment:15

Above `foreach ($folderPath in...`.

```text
Enumerate with [System.IO.Directory] (sorted to keep output deterministic) rather than Get-ChildItem:
the cmdlet carries ~20ms of provider overhead PER CALL on Windows, and discovery makes dozens of these
calls — it was the dominant cost of a cold discovery (~0.8s of ~1.2s). The raw .NET enumerators are
~0.1ms. Same approach as Resolve-ConfigEntry.
```

## comment:16

Above `$environmentKind = if ($options.Contains('environment_kind')) {`.

```text
Env-class template classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): the env-class bit
(standard/subscription, default standard). Every config below must match it. The slot is a
per-config dimension, not a template bit — a template may mix slotted and non-slotted configs.
```

## comment:17

Above `$customerDeploymentOption = if ($options.Contains('customer_deployment')) {`.

```text
Customer-class bit
([ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)): whether this is a customer template. It
defaults to the have_customers repo variant (Test-HaveCustomers) unless options.yml sets it. An
explicit customer_deployment: true is only allowed when customers are enabled (the repo-level guard).
```

## comment:18

Above `$shortNameOverride = if ($options.Contains('short_name')) {`.

```text
short_name is the Azure id segment every resource name is built from. It is DERIVED from the folder
name by default; an options.yml `short_name` overrides it. BicepShortName owns the derivation +
format validation (a malformed override, or a folder that cannot yield a valid short_name without an
override, throws here — naming the template). See
[ADR-AZ-NAMING#2](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2).
```

## comment:19

Above `$configEntries = [System.Collections.Generic.List[object]]::new()`.

```text
Gather every config file with its customer (the subfolder; '' for a configuration-root config).
Root files first, then the customer subfolders — both sorted, so output stays deterministic.
```

## comment:20

Above `$slots = [System.Collections.Generic.List[object]]::new()`.

```text
Each config file is one slot (one resource group). The filename `<env>[-<slot>]` resolves to
its environment + slot via Resolve-BicepConfigName (`default.yml` is a reserved skip); the
subscription is resolved from the (customer?, env) coordinate — one config file ⟷ one
(customer?, env, slot) ⟷ one subscription ⟷ one RG.
```

## comment:21

Above `foreach ($key in @($options.Keys)) {`.

```text
Overlay the remaining deployment overrides. short_name is resolved via BicepShortName and
environment_kind / customer_deployment are already applied above, so all three are excluded here.
```
