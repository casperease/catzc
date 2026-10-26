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
    Assert-PathExist ([Catzc.Base.Git.GitWorkTree]::GitFolder($root))

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
        Assert-PathExist ([Catzc.Base.Git.GitWorkTree]::GitFolder($Source))
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
