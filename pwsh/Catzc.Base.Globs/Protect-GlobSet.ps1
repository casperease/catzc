<#
---
catzc:
  immutable:
    with_body_sha: "694a1e906e57"
  edges:
    docs: "[Protect-GlobSet.ps1.md](docs/references/pwsh/catzc-base-globs/Protect-GlobSet.ps1.md)"
    cites:
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-REPO-PROTGLOB
---
#>

function Protect-GlobSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Test,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [string] $Hash
    )

    if (Test-IsRunningInPipeline) {
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:protectedGlobSets')) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    $identity = $script:pendingGlobProtections[$key]
    if (-not $identity) {
        $identity = if ($Hash) {
            $Hash
        }
        else {
            Get-GlobSetHash -Name $Name
        }
    }
    $script:protectedGlobSets[$key] = $identity
    $script:pendingGlobProtections.Remove($key)
}
