<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-SessionActor.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-TYPES#13
---
#>

<#
.SYNOPSIS
    Returns who is running this session: Pipeline, Agent, or Person.
.DESCRIPTION
    A pipeline wins over an agent, since an agent's run inside a pipeline is still a pipeline run.
.PARAMETER ActorAssertIs
    The guard only verifies the detected actor and never selects one, so a mismatch throws.
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
