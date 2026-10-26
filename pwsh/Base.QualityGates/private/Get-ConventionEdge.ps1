function Get-ConventionEdge {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.LinkEdge[]])]
    param(
        # Repository-relative, '/'-separated tracked paths: the files the relations may join.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # Each relation is derived from its declaration on every call, never read from a file.
    $files = @($Path | ForEach-Object { $_.Replace('\', '/') } | Select-Object -Unique)
    $known = [System.Collections.Generic.HashSet[string]]::new([string[]] $files, [System.StringComparer]::Ordinal)
    $edges = [System.Collections.Generic.List[Catzc.Base.QualityGates.LinkEdge]]::new()
    $edge = { param([string] $From, [string] $To) $edges.Add([Catzc.Base.QualityGates.LinkEdge]::new($From, 0, 0,
                'Convention', $To, '')) }

    # A test points at the file of its unit, outside tests/, whose name without extension is the test's stem.
    $subjects = @{}
    foreach ($file in $files) {
        if ($file -match '/tests/' -or $file -match '^tests/') {
            continue
        }
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($file)
        if (-not $subjects.ContainsKey($stem)) {
            $subjects[$stem] = [System.Collections.Generic.List[string]]::new()
        }
        $subjects[$stem].Add($file)
    }
    foreach ($file in $files) {
        if ($file -notmatch '^(?<unit>.+?)/tests/(?:.+/)?(?<stem>[^/]+)\.Tests\.ps1$') {
            continue
        }
        $unit = $Matches['unit'] + '/'
        # Assigned in the branch: an `if` expression would turn an empty list into $null.
        $candidates = @()
        if ($subjects.ContainsKey($Matches['stem'])) {
            $candidates = @($subjects[$Matches['stem']].Where({ $_.StartsWith($unit,
                            [System.StringComparison]::Ordinal) }))
        }
        if ($candidates.Count -gt 0) {
            & $edge $file $candidates[0]
        }
    }

    # A file points at its tracked comment page; the config is read once and passed to every Get-CommentPage call.
    $commentPages = Get-Config -Config comment-pages
    foreach ($file in $files) {
        $page = Get-CommentPage -Path $file -Config $commentPages
        if ($page -and $known.Contains($page)) {
            & $edge $file $page
        }
    }

    # A module points at each dependency it declares, by its folder; a group name is no module.
    $modulesFolder = Get-CatzcModulesFolder
    $folders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        if ($file.StartsWith("$modulesFolder/", [System.StringComparison]::Ordinal)) {
            $rest = $file.Substring($modulesFolder.Length + 1)
            $slash = $rest.IndexOf('/')
            if ($slash -gt 0) {
                $null = $folders.Add("$modulesFolder/" + $rest.Substring(0, $slash))
            }
        }
    }
    foreach ($dependency in @(Get-ModuleDependencyEdges -Declared)) {
        $from = "$modulesFolder/$($dependency.From)"
        $to = "$modulesFolder/$($dependency.To)"
        if ($folders.Contains($from) -and $folders.Contains($to)) {
            & $edge $from $to
        }
    }
    $edges.ToArray()
}
