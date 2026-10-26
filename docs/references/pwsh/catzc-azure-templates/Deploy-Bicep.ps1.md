# pwsh/Azure.Templates/Deploy-Bicep.ps1

The command that deploys a bicep template to Azure. It resolves the deployment context, runs the template's hooks, calls az and sets the
tracking tags. It is a state-changing command that previews with `-DryRun` rather than `ShouldProcess`
([ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md)).

## help

### synopsis

Deploys a bicep template to Azure (resolves context, runs hooks, calls az, sets tags).

### description

The deploy target is the az session's subscription — in a pipeline, exactly what the service connection logged into — reverse-resolved
against azure.yml (Get-AzCliSessionSubscription). The session's customer picks the slot: a customer subscription deploys the template's
`configuration/<customer>/` config, a non-customer subscription the configuration-root one. The -SubscriptionIdAssertIs guard pins the
target explicitly and is MANDATORY in a pipeline ([ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)).

Flow:

1. Get-BicepDeploymentContext (resolves the session target, applies the assert guard; devbox auto-runs Build-Bicep; pipeline uses
   ArtifactsFolder). Returns $null if mode is DoNotRun without -OverrideDoNotRunAndRun → skip.
2. Import the template's own PrePost.psm1 from artifacts (if it ships one); resolve the hooks it exports.
3. Run the template's Invoke-BicepPreDeploy hook if it exports one (else no-op).
4. ResourceGroup target: Deploy-AzureResourceGroup (idempotent).
5. az deployment {group|sub} create — passes ABSOLUTE --template-file / --parameters paths so the call never depends on the process working
   directory. -DryRun appends `--what-if` and stops here.
6. Assert provisioningState = Succeeded.
7. Run the template's Invoke-BicepPostDeploy hook if it exports one (gets the parsed output).
8. Set-BicepTrackingTagSet.

Pass -DryRun to preview: it runs `az deployment ... create --what-if` (Azure's server-side preview) and skips the real deploy, the
post-deploy hook, and tag-setting. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Environment`

Environment shortname.

### parameter `Template`

Template name.

### parameter `Slot`

Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Selects the slot to deploy; omitted -> the env's base /
index-0 slot.

### parameter `SubscriptionIdAssertIs`

Guard — the subscription GUID the az session is expected to target; throws on a mismatch (a mis-wired service connection). MANDATORY in a
pipeline: a pipeline deploy must pin its target explicitly, so a session change can never silently retarget it. Optional on a devbox. Never
a selector — the session always determines the target.

### parameter `ArtifactsFolder`

Required in a pipeline. Devbox callers can pass it with -DoNotRebuild to skip the local build.

### parameter `DoNotRebuild`

Devbox-only. Reuse the existing build instead of rebuilding.

### parameter `OverrideDoNotRunAndRun`

Devbox-only. Bypass the template's DoNotRun mode.

### parameter `DryRun`

Preview only — runs the Azure `--what-if` deployment and skips the real deploy, post-deploy hook, and tag-setting.

### example 1

```powershell
Deploy-Bicep dev sample            # deploys into the az session's subscription
```

### example 2

```powershell
Deploy-Bicep dev sample -DryRun
```

### example 3

```powershell
Deploy-Bicep nsub foundation -SubscriptionIdAssertIs a0e00000-de00-50b0-0000-000000000000
```

## The target

In a pipeline the target must be pinned explicitly. The session (the service connection) selects the target, and the assert guard is the
pipeline's declared expectation, so a re-wired service connection can never silently retarget an existing pipeline's deploy. The command
fails fast at the call site instead ([ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)).

The session determines the target, and the deployment context resolves and guards it (`Get-AzCliSessionSubscription` and
`-SubscriptionIdAssertIs`). Everything downstream reads the one resolved identity off the context, so config, artifacts and tags all agree.

## The PrePost hooks

A template may ship `infrastructure/templates/<name>/PrePost.psm1` exporting `Invoke-BicepPreDeploy` and `Invoke-BicepPostDeploy`. The
command resolves whichever it exports, and an absent hook does nothing. The `assets/PrePost.psm1` starter is never loaded, since it exists
only to be copied into a template.

The hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR-STRICTCLEAN](../../../drs/automation/pwsh/error-handling.md#rule-adr-pwsh-error-strictclean)).

The deploy invocation is the bag of arguments this deploy is acting on, including the mode. `DryRun` is passed as its own first-class
parameter to the pre-deploy hook, because it is the side-effect kill switch and too special to hide in a bag. Computed descriptor objects
stay separate ([ADR-PWSH-PREPOST](../../../drs/automation/pwsh/prepost-extension-modules.md)).

Pre-deploy runs before the `--what-if` branch, so it gets `-DryRun` and must honor it. Post-deploy runs only after a real deploy, so it
never receives `DryRun`.

## Artifact paths

The artifact paths are repo-relative where possible and absolute for external pipeline artifacts. az runs from the repository root
(`Invoke-Executable`'s working directory), so a repo-relative path resolves there and an absolute one is honored as it is, either way
independent of the shell's `$PWD`. The paths are quoted in case one contains spaces.

## Failures

The az deployment calls pass `-NoAssert`, so a non-zero exit throws from the command with its context: the deployment name, the exact az
command and az's stderr and stdout. The cause lives in az's stderr, a policy denial, an invalid template or a quota or auth error, so it
must travel in the thrown error and not only the console stream, and the generic exit-code assertion in `Invoke-Executable` would hide it.
