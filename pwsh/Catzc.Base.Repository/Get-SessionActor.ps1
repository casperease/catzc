<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-SessionActor.ps1
    name: get-session-actor
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
    docs: "[Get-SessionActor.ps1.md](docs/references/pwsh/catzc-base-repository/Get-SessionActor.ps1.md)"
    cites:
      - ADR-AUTO-TYPES-JANITORSBYCALLER
---
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
