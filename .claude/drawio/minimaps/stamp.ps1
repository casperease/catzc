# cspell:ignore minimaps
param(
    [Parameter(Mandatory)]
    [string] $Target
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repo = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
. (Join-Path $repo 'importer.ps1') *> $null

$utf8 = [System.Text.UTF8Encoding]::new($false)
$folder = [System.IO.Path]::GetFullPath($Target, $repo)
$written = 0
$current = 0
foreach ($view in 'chain', 'grid', 'tree') {
    $viewFolder = Join-Path $folder $view
    if (-not [System.IO.Directory]::Exists($viewFolder)) {
        continue
    }
    foreach ($page in [System.IO.Directory]::GetFiles($viewFolder, "*.$view.md")) {
        $relative = [System.IO.Path]::GetRelativePath($repo, $page) -replace '\\', '/'
        $stem = [System.IO.Path]::GetFileName($page) -replace "\.$view\.md$", ''
        $slide = Join-Path $folder "$stem.drawio.png"
        $source = @(if ([System.IO.File]::Exists($slide)) {
                [System.IO.Path]::GetRelativePath($repo, $slide) -replace '\\', '/'
            })
        $text = [System.IO.File]::ReadAllText($page)
        $stamped = Format-GeneratedFileHead -Text $text -Path $relative -Source $source -FileKind (Get-FileKind $relative)
        if ($stamped -ceq $text) {
            $current++
            continue
        }
        [System.IO.File]::WriteAllText($page, $stamped, $utf8)
        $written++
    }
}
"stamped written=$written current=$current"
