---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
    kind: comment-page
    body_sha: "69724d2e06f0"
    adrs:
      - ADR-PWSH-ERROR#8
---

# automation/Catzc.Azure.Templates/Deploy-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:14

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:15

Above `if ((Test-IsRunningInPipeline) -and...`.

```text
In a pipeline the target MUST be pinned explicitly — the session (the service connection) selects
it, and the assert guard is the pipeline's declared expectation, so a re-wired service connection
can never silently retarget an existing pipeline's deploy. Fail fast at the call site instead.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```

## comment:16

Above `` $context = Get-BicepDeploymentContext ` ``.

```text
The session determines the target; the context resolves and guards it (Get-AzCliSessionSubscription
+ -SubscriptionIdAssertIs), and everything downstream reads the one resolved identity off the
context so config, artifacts, and tags all agree.
```

## comment:17

Above `$preDeployHook = $null`.

```text
A template MAY ship infrastructure/templates/<name>/PrePost.psm1 exporting Invoke-BicepPreDeploy /
Invoke-BicepPostDeploy. Resolve whichever it exports; absent hooks are no-ops. The
assets/PrePost.psm1 starter is never loaded — it exists only to be copied into a template.
```

## comment:18

Above `. $prepostModule { Set-StrictMode -Version Latest }`.

```text
The template's hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8)).
```

## comment:19

Above `$deployInvocation = [ordered]@{`.

```text
The deploy invocation — the arguments this deploy is acting on (incl. Mode). DryRun is passed
as its own first-class parameter to PreDeploy (it's the side-effect kill switch — too special
to hide in a bag). Computed descriptor objects stay separate.
See [ADR-PWSH-PREPOST](/docs/adr/pwsh/prepost-extension-modules.md).
```

## comment:20

Above `if ($preDeployHook) {`.

```text
PreDeploy runs before the --what-if branch, so it gets -DryRun and must honor it. PostDeploy
only runs after a real deploy, so it never receives DryRun.
```

## comment:21

Above `$templateFile = $context.artifacts.template_file`.

```text
The artifact paths are repo-relative where possible (absolute for external pipeline artifacts).
az runs from the repo root (Invoke-Executable's WorkingDirectory), so a repo-relative path
resolves there and an absolute one is honored as-is — either way independent of the shell's $PWD.
Quoted in case a path contains spaces.
```

## comment:22

Above `if ($DryRun) {`.

```text
-NoAssert on the az deployment calls: a non-zero exit throws WITH context (the deployment name,
the exact az command, az's stderr/stdout) from here, instead of the generic exit-code assertion
buried in Invoke-Executable. az's stderr is where the cause lives — a policy denial, an invalid
template, a quota/auth error — so it must travel in the thrown error, not just the console stream.
```
