# docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md

`automation/Catzc.Azure.Templates/Deploy-Bicep.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The deploy target is the az session's subscription — in a pipeline, exactly what the service
connection logged into — reverse-resolved against azure.yml (Get-AzCliSessionSubscription). The
session's customer picks the slot: a customer subscription deploys the template's
configuration/<customer>/ config, a non-customer subscription the configuration-root one. The
-SubscriptionIdAssertIs guard pins the target explicitly and is MANDATORY in a pipeline
([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)).

Flow:
1. Get-BicepDeploymentContext           (resolves the session target, applies the assert guard;
   devbox auto-runs Build-Bicep; pipeline uses ArtifactsFolder).
   Returns $null if mode is DoNotRun without -OverrideDoNotRunAndRun → skip.
3. Import the template's own PrePost.psm1 from artifacts (if it ships one); resolve the hooks it exports.
4. Run the template's Invoke-BicepPreDeploy hook if it exports one (else no-op).
5. ResourceGroup target: Deploy-AzureResourceGroup (idempotent).
6. az deployment {group|sub} create — passes ABSOLUTE --template-file / --parameters paths so the
   call never depends on the process working directory. -DryRun appends `--what-if` and stops here.
7. Assert provisioningState = Succeeded.
8. Run the template's Invoke-BicepPostDeploy hook if it exports one (gets the parsed output).
9. Set-BicepTrackingTagSet.

Pass -DryRun to preview: it runs `az deployment ... create --what-if` (Azure's server-side preview)
and skips the real deploy, the post-deploy hook, and tag-setting. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:2

Section `.PARAMETER Slot` of the comment-based help.

```text
Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Selects the slot to
deploy; omitted -> the env's base / index-0 slot.
```

## comment:3

Section `.PARAMETER SubscriptionIdAssertIs` of the comment-based help.

```text
Guard — the subscription GUID the az session is expected to target; throws on a mismatch (a
mis-wired service connection). MANDATORY in a pipeline: a pipeline deploy must pin its target
explicitly, so a session change can never silently retarget it. Optional on a devbox. Never a
selector — the session always determines the target.
```

## comment:4

Section `.PARAMETER DryRun` of the comment-based help.

```text
Preview only — runs the Azure `--what-if` deployment and skips the real deploy, post-deploy hook,
and tag-setting.
```

## comment:5

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:6

Above `if ((Test-IsRunningInPipeline) -and...`.

```text
In a pipeline the target MUST be pinned explicitly — the session (the service connection) selects
it, and the assert guard is the pipeline's declared expectation, so a re-wired service connection
can never silently retarget an existing pipeline's deploy. Fail fast at the call site instead.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```

## comment:7

Above `` $context = Get-BicepDeploymentContext ` ``.

```text
The session determines the target; the context resolves and guards it (Get-AzCliSessionSubscription
+ -SubscriptionIdAssertIs), and everything downstream reads the one resolved identity off the
context so config, artifacts, and tags all agree.
```

## comment:8

Above `$preDeployHook = $null`.

```text
A template MAY ship infrastructure/templates/<name>/PrePost.psm1 exporting Invoke-BicepPreDeploy /
Invoke-BicepPostDeploy. Resolve whichever it exports; absent hooks are no-ops. The
assets/PrePost.psm1 starter is never loaded — it exists only to be copied into a template.
```

## comment:9

Above `. $prepostModule { Set-StrictMode -Version Latest }`.

```text
The template's hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8)).
```

## comment:10

Above `$deployInvocation = [ordered]@{`.

```text
The deploy invocation — the arguments this deploy is acting on (incl. Mode). DryRun is passed
as its own first-class parameter to PreDeploy (it's the side-effect kill switch — too special
to hide in a bag). Computed descriptor objects stay separate.
See [ADR-PWSH-PREPOST](/docs/adr/pwsh/prepost-extension-modules.md).
```

## comment:11

Above `if ($preDeployHook) {`.

```text
PreDeploy runs before the --what-if branch, so it gets -DryRun and must honor it. PostDeploy
only runs after a real deploy, so it never receives DryRun.
```

## comment:12

Above `$templateFile = $context.artifacts.template_file`.

```text
The artifact paths are repo-relative where possible (absolute for external pipeline artifacts).
az runs from the repo root (Invoke-Executable's WorkingDirectory), so a repo-relative path
resolves there and an absolute one is honored as-is — either way independent of the shell's $PWD.
Quoted in case a path contains spaces.
```

## comment:13

Above `if ($DryRun) {`.

```text
-NoAssert on the az deployment calls: a non-zero exit throws WITH context (the deployment name,
the exact az command, az's stderr/stdout) from here, instead of the generic exit-code assertion
buried in Invoke-Executable. az's stderr is where the cause lives — a policy denial, an invalid
template, a quota/auth error — so it must travel in the thrown error, not just the console stream.
```
