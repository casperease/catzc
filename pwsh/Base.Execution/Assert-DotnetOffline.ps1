function Assert-DotnetOffline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/')
    $full = [System.IO.Path]::GetFullPath($(if ([System.IO.Path]::IsPathRooted($Path)) {
                $Path
            }
            else {
                Join-Path $root $Path
            }))
    $folder = if ([System.IO.Directory]::Exists($full)) {
        $full
    }
    else {
        [System.IO.Path]::GetDirectoryName($full)
    }
    $inside = $folder -eq $root -or $folder.StartsWith($root + [System.IO.Path]::DirectorySeparatorChar,
        [System.StringComparison]::OrdinalIgnoreCase)
    Assert-True $inside -ErrorText "Assert-DotnetOffline: '$Path' lies outside the repository '$root', where no generated nuget.config keeps dotnet offline."

    # NuGet reads these names in every folder up from the project; the root's one clears the user's and machine's.
    $names = 'nuget.config', 'NuGet.config', 'NuGet.Config'
    $config = Join-Path $root 'nuget.config'
    Assert-True ([System.IO.File]::Exists($config)) -ErrorText "Assert-DotnetOffline: $config is missing, so dotnet would restore from the user's package feeds. Run Build-RootConfig, which generates it."

    $document = [System.Xml.XmlDocument]::new()
    try {
        $document.LoadXml([System.IO.File]::ReadAllText($config))
    }
    catch {
        throw "Assert-DotnetOffline: $config is not readable XML ($($_.Exception.Message)), so it clears no package feed. Run Build-RootConfig, which generates it."
    }
    $sectionElements = {
        param([string] $Section)
        $node = $document.SelectSingleNode("/configuration/$Section")
        @(if ($node) {
                $node.ChildNodes | Where-Object { $_.NodeType -eq 'Element' }
            })
    }
    $packages = @(& $sectionElements 'packageSources')
    $oneSource = $packages.Count -eq 2 -and $packages[0].LocalName -eq 'clear' -and $packages[1].LocalName -eq 'add'
    Assert-True $oneSource -ErrorText "Assert-DotnetOffline: $config does not name exactly one package source after its clear, so another package feed stays visible to dotnet. Run Build-RootConfig, which generates it."
    $audit = @(& $sectionElements 'auditSources')
    Assert-True ($audit.Count -eq 1 -and $audit[0].LocalName -eq 'clear') -ErrorText "Assert-DotnetOffline: $config does not clear its auditSources, so a package feed stays visible to dotnet."

    $current = $folder
    while ($current -ne $root) {
        foreach ($name in $names) {
            $stray = Join-Path $current $name
            Assert-False ([System.IO.File]::Exists($stray)) -ErrorText "Assert-DotnetOffline: $stray sits between '$Path' and the repository root, so its package feeds reach dotnet. Remove it."
        }
        $current = [System.IO.Path]::GetDirectoryName($current)
    }
}
