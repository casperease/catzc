<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
    name: import-repository-with-history
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-FAILFAST#3
      - ADR-DSGN-TRACK#17
  config:
    synopsis: Imports an outside repository with its full history at one landing address under the unordered track.
    description: |-
      An import ([ADR-DSGN-TRACK#17](/docs/adr/design/tracks.md#rule-adr-dsgn-track17)): every commit of the source ref
      becomes part of this repository's history, and the source's files land at the landing address `<unordered>/<name>`,
      where `<unordered>` is the place of the track of type `unordered`. Nothing outside the address changes; sorting the
      files into their modules is a later `git mv`, one file or folder at a time.

      The name resolves once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): -Name
      when given, else the source's folder or repository name in kebab case. A name that is not a short kebab word fails, a
      taken address fails, and no suffix is ever added. Every precondition is asserted before anything is written
      ([ADR-AUTO-FAILFAST#3](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3)): git is present, the
      target has nothing staged, and a source given as a path is a git repository with a clean working tree.

      The history is joined by a subtree merge in core git: the source ref is fetched, its tree is read in under the address,
      and one merge commit records both parents, so `git log` reaches every source commit.
    parameters:
      Source: The repository to import, a local path or a URL.
      Name: 'The landing name, a short kebab word. Default: the source''s folder or repository name in kebab case.'
      Ref: 'The source ref to import. Default: the source''s default branch (its HEAD).'
      RepositoryRoot: 'The repository the import lands in. Default: the loaded repository root.'
      DryRun: Resolve and check everything, report the landing address, and write nothing.
    outputs: '[pscustomobject] @{ Name; Address; Source; Ref; Commits } — Commits is $null with -DryRun.'
    examples:
      - Import-RepositoryWithHistory -Source C:\projects\widget-tools
      - Import-RepositoryWithHistory -Source https://example.com/gadget.git -Name gadget -Ref release
      - Import-RepositoryWithHistory -Source C:\projects\widget-tools -DryRun
---
#>

function Import-RepositoryWithHistory {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Source,

        [string] $Name,

        [string] $Ref,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun
    )

    Assert-Command git
    $root = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/')
    Assert-PathExist (Join-Path $root '.git')

    $isLocal = Test-Path -LiteralPath $Source -PathType Container
    if ($isLocal) {
        $Source = [System.IO.Path]::GetFullPath($Source).TrimEnd('\', '/')
    }

    # One resolution order: an explicit -Name is taken as given; otherwise the source's last segment in kebab case.
    if (-not $Name) {
        $leaf = ($Source.TrimEnd('\', '/') -split '[\\/:]')[-1] -replace '\.git$', ''
        $Name = (($leaf -creplace '([a-z0-9])([A-Z])', '$1-$2').ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    }
    Assert-True ($Name -cmatch '^[a-z][a-z0-9]*(-[a-z0-9]+)*$') -ErrorText ('Import-RepositoryWithHistory: the landing name ' +
        "'$Name' is not a short kebab word (lowercase letters and digits, joined by single hyphens).")

    $unordered = @(Get-Track | Where-Object { $_.type -ceq 'unordered' })
    Assert-True ($unordered.Count -eq 1) -ErrorText 'Import-RepositoryWithHistory: the variants declare no single track of type unordered.'
    $address = "$($unordered[0].places[0])/$Name"
    $target = Join-Path $root $address
    Assert-True (-not (Test-Path -LiteralPath $target)) `
        -ErrorText "Import-RepositoryWithHistory: the landing address '$address' is taken; name the import with -Name."

    $staged = (Invoke-Executable "git -C `"$root`" diff --cached --name-only" -PassThru -Silent).Output.Trim()
    Assert-True (-not $staged) -ErrorText "Import-RepositoryWithHistory: '$root' has staged changes; the import commit would carry them."
    if ($isLocal) {
        Assert-PathExist (Join-Path $Source '.git')
        $dirty = (Invoke-Executable "git -C `"$Source`" status --porcelain" -PassThru -Silent).Output.Trim()
        Assert-True (-not $dirty) -ErrorText ("Import-RepositoryWithHistory: the source '$Source' has uncommitted changes; " +
            'commit or discard them first.')
    }

    $sourceRef = if ($Ref) {
        $Ref
    }
    else {
        'HEAD'
    }
    if ($DryRun) {
        Write-Message "Dry run: '$Source' ($sourceRef) would land at '$address'."
        return [pscustomobject]@{ Name = $Name; Address = $address; Source = $Source; Ref = $sourceRef; Commits = $null }
    }

    # The history move: fetch the source ref, read its tree in under the address, and record one merge commit with both parents.
    $git = "git -C `"$root`""
    Invoke-Executable "$git fetch --quiet --no-tags `"$Source`" `"$sourceRef`"" -PassThru -Silent | Out-Null
    $fetched = (Invoke-Executable "$git rev-parse FETCH_HEAD" -PassThru -Silent).Output.Trim()
    Invoke-Executable "$git merge --quiet --strategy ours --allow-unrelated-histories --no-commit $fetched" -PassThru -Silent | Out-Null
    Invoke-Executable "$git read-tree --prefix=`"$address/`" -u $fetched" -PassThru -Silent | Out-Null
    Invoke-Executable "$git commit --quiet --no-verify -m `"Import $Source ($sourceRef) at $address`"" -PassThru -Silent | Out-Null
    $commits = [int] (Invoke-Executable "$git rev-list --count $fetched" -PassThru -Silent).Output.Trim()

    Write-Message "Imported '$Source' ($sourceRef): $commits commit(s) at '$address'."
    [pscustomobject]@{ Name = $Name; Address = $address; Source = $Source; Ref = $sourceRef; Commits = $commits }
}
