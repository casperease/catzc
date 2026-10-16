---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: deploy-bicep-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5df2510ace91"
    adrs:
      - ADR-PWSH-ERROR#8
---

# automation/Catzc.Azure.Templates/Deploy-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:2

Above `if ((Test-IsRunningInPipeline) -and...`, written with `#`.

```text
In a pipeline the target MUST be pinned explicitly — the session (the service connection) selects
it, and the assert guard is the pipeline's declared expectation, so a re-wired service connection
can never silently retarget an existing pipeline's deploy. Fail fast at the call site instead.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```

## comment:3

Above `` $context = Get-BicepDeploymentContext ` ``, written with `#`.

```text
The session determines the target; the context resolves and guards it (Get-AzCliSessionSubscription
+ -SubscriptionIdAssertIs), and everything downstream reads the one resolved identity off the
context so config, artifacts, and tags all agree.
```

## comment:4

Above `$preDeployHook = $null`, written with `#`.

```text
A template MAY ship infrastructure/templates/<name>/PrePost.psm1 exporting Invoke-BicepPreDeploy /
Invoke-BicepPostDeploy. Resolve whichever it exports; absent hooks are no-ops. The
assets/PrePost.psm1 starter is never loaded — it exists only to be copied into a template.
```

## comment:5

Above `. $prepostModule { Set-StrictMode -Version Latest }`, written with `#`.

```text
The template's hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8)).
```

## comment:6

Above `$deployInvocation = [ordered]@{`, written with `#`.

```text
The deploy invocation — the arguments this deploy is acting on (incl. Mode). DryRun is passed
as its own first-class parameter to PreDeploy (it's the side-effect kill switch — too special
to hide in a bag). Computed descriptor objects stay separate.
See [ADR-PWSH-PREPOST](/docs/adr/pwsh/prepost-extension-modules.md).
```

## comment:7

Above `if ($preDeployHook) {`, written with `#`.

```text
PreDeploy runs before the --what-if branch, so it gets -DryRun and must honor it. PostDeploy
only runs after a real deploy, so it never receives DryRun.
```

## comment:8

Above `$templateFile = $context.artifacts.template_file`, written with `#`.

```text
The artifact paths are repo-relative where possible (absolute for external pipeline artifacts).
az runs from the repo root (Invoke-Executable's WorkingDirectory), so a repo-relative path
resolves there and an absolute one is honored as-is — either way independent of the shell's $PWD.
Quoted in case a path contains spaces.
```

## comment:9

Above `if ($DryRun) {`, written with `#`.

```text
-NoAssert on the az deployment calls: a non-zero exit throws WITH context (the deployment name,
the exact az command, az's stderr/stdout) from here, instead of the generic exit-code assertion
buried in Invoke-Executable. az's stderr is where the cause lives — a policy denial, an invalid
template, a quota/auth error — so it must travel in the thrown error, not just the console stream.
```
