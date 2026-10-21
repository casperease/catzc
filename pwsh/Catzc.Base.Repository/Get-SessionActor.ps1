<#
---
catzc:
  immutable:
    with_body_sha: "96713ba2d7d0"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
    docs: "[Get-SessionActor.ps1.md](docs/references/pwsh/catzc-base-repository/Get-SessionActor.ps1.md)"
    cites:
      - ADR-BCL-TYPES-JANITORSBYCALLER
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
