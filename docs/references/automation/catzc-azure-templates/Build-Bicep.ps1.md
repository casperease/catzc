---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md
    kind: comment-page
    body_sha: bbaa22ab485f
    adrs:
      - ADR-AZ-DATAMOD#10
      - ADR-PWSH-ERROR#8
---

# automation/Catzc.Azure.Templates/Build-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:12

Above `$targetSlots = @($templateDescriptor.slots)`.

```text
Build every slot by default; -Environments narrows by env, and -Customers/-Shared narrow by the
configuration axis (a customer's subfolder slots / the root slots), unioned when both are given.
```

## comment:13

Above `Assert-AzCliBicep`.

```text
Precondition: the Bicep CLI must be available before we wipe the output and render params, else
`az bicep build` can exit 0 while writing no main.json (e.g. a missing/blocked auto-install). This
also warms the install in its own call, separate from the build. See Assert-AzCliBicep.
```

## comment:14

Above `$prepareHook = $null`.

```text
A template MAY ship its own infrastructure/templates/<name>/PrePost.psm1 exporting a build-time
Invoke-BicepPrepareParameterSet hook. Resolve it once if present; absent -> the prepare step
is a no-op (the per-slot config is used unchanged). The assets/PrePost.psm1 starter is never
loaded here — it exists only to be copied into a template.
```

## comment:15

Above `. $prepostModule { Set-StrictMode -Version Latest }`.

```text
The template's hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8)).
```

## comment:16

Above `if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {`.

```text
The marker is a string: compared string-first and case-sensitively, so a boolean `true` (which -eq coerces to
equal any non-empty string) or a number never reads as undefined.
```

## comment:17

Above `if ($configurationDescriptor.Contains('ParametersFile') -and...`.

```text
A config-addressed parameter `{ address: global.<config>.<key>… }` renders as the value it addresses
([ADR-AZ-DATAMOD#10](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10)), before the PrePost hook,
so the hook and the parameters file see only ARM entries.
```

## comment:18

Above `$buildInvocation = [ordered]@{`.

```text
The build invocation for this slot — the arguments Build-Bicep is acting on. Hooks read what
they need from it (e.g. $BuildInvocation.Customer) rather than via raw params, so adding a
dimension never changes the hook signature.
See [ADR-PWSH-PREPOST](/docs/adr/pwsh/prepost-extension-modules.md).
```

## comment:19

Above `$mainJson = Join-Path $outputFolder 'main.json'`.

```text
az bicep build can exit 0 yet emit nothing. Assert the compiled template at the source so the
failure names the real culprit here, not later as a generic missing-file in
Get-BicepDeploymentContext. Assert-AzCliBicep already proved the Bicep CLI is available above, so a
missing main.json now is an unexpected build failure, not a not-installed one — say exactly that.
```
