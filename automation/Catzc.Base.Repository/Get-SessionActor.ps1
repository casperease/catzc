<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-SessionActor.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns who is running this session: Pipeline, Agent, or Person.
.DESCRIPTION
    A pipeline wins over an agent, since an agent's run inside a pipeline is still a pipeline run.
    [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-SessionActor.ps1.md#comment1)
.PARAMETER ActorAssertIs
    The guard only verifies the detected actor and never selects one, so a mismatch throws.
    [comment:2](/docs/references/automation/catzc-base-repository/Get-SessionActor.ps1.md#comment2)
.OUTPUTS
    [string] 'Pipeline', 'Agent', or 'Person'.
.EXAMPLE
    Get-SessionActor
.EXAMPLE
    if ((Get-SessionActor) -eq 'Person') { Sync-GeneratedFile }
.EXAMPLE
    $null = Get-SessionActor -ActorAssertIs Pipeline
#>
function Get-SessionActor {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateSet('Pipeline', 'Agent', 'Person')]
        [string] $ActorAssertIs
    )

    $actor = if (Test-IsRunningInPipeline) {
        'Pipeline'
    }
    elseif (Test-IsRunningAsAgent) {
        'Agent'
    }
    else {
        'Person'
    }
    if ($ActorAssertIs -and $actor -ne $ActorAssertIs) {
        throw "Session actor is '$actor', but -ActorAssertIs expects '$ActorAssertIs'"
    }
    $actor
}
