<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Github/private/Assert-RemoteMatchesBranch.ps1
    kind: function
    module: Catzc.Tooling.Github
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a freshly pushed remote holds exactly the local branch — every ref it advertises points at the
    branch's commit.
.DESCRIPTION
    A ref at the local commit holds the same history, so a ref listing proves the remote without a mirror clone.
    [comment:1](/docs/references/automation/catzc-tooling-github/private/Assert-RemoteMatchesBranch.ps1.md#comment1)
.PARAMETER Url
    The remote to read, as a clone URL.
.PARAMETER Branch
    The local branch that was pushed.
.PARAMETER RepositoryPath
    The local clone the branch lives in.
.PARAMETER TimeoutSeconds
    How long the network read may run; the caller passes its own limit.
.OUTPUTS
    [string] The commit every remote ref points at.
#>
function Assert-RemoteMatchesBranch {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Url,

        [Parameter(Mandatory)]
        [string] $Branch,

        [Parameter(Mandatory)]
        [string] $RepositoryPath,

        [Parameter(Mandatory)]
        [int] $TimeoutSeconds
    )

    # The branch's commit, read from the local ref files in-process.
    $local = [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory($RepositoryPath), "refs/heads/$Branch")

    $listing = Invoke-Executable "git ls-remote $Url" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent -TimeoutSeconds $TimeoutSeconds
    if ($listing.ExitCode -ne 0) {
        throw "Post-verify ls-remote of '$Url' failed (the push may be fine — check GitHub): $($listing.Errors)"
    }

    # One '<commit>\t<ref>' line per advertised ref.
    $refs = @($listing.Output -split '\r?\n' | Where-Object { $_ } | ForEach-Object {
            $commit, $ref = $_ -split '\t', 2
            [pscustomobject]@{ Commit = $commit; Ref = $ref }
        })
    if (-not ($refs | Where-Object { $_.Ref -eq "refs/heads/$Branch" })) {
        throw "Post-verify: '$Url' does not advertise refs/heads/$Branch — the push did not land."
    }
    $foreign = @($refs | Where-Object { $_.Commit -ne $local })
    if ($foreign.Count -gt 0) {
        $named = ($foreign | ForEach-Object { "$($_.Ref) ($($_.Commit))" }) -join ', '
        throw "'$Url' holds history the local scan did not cover — $named against local $Branch ($local). DO NOT make it public. Investigate before continuing."
    }
    $local
}
