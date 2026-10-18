<#
---
catzc:
  immutable:
    repo_status: clean
    path: ".claude/drawio/minimaps/stamp.ps1"
    folder: drawio/minimaps
    name: stamp
    filetype: ps1
    kind: drawio-kit
    language: powershell
    track: ".claude-kits"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  config:
    synopsis: 'The minimap head step: writes the generated meta head on every sister .md render.py wrote under -Target.'
    description: |-
      render.py (describe.py) writes each minimap's sister page as a body only; this step, run after it, gives every
      <view>/<stem>.<view>.md under -Target (views chain, grid and tree) the generated head through the one head function,
      Format-GeneratedFileHead, so the head opens with the hash of the body below it (ADR-REPO-FILEMETA#7). The page's source
      is the slide it describes, <Target>/<stem>.drawio.png, when that slide exists. A page whose text is already current is
      left as it is, so a second run writes nothing.
    parameters:
      Target: The slides folder the minimaps were rendered into, repository-relative or absolute.
    examples:
      - pwsh -NoProfile -File .claude/drawio/minimaps/stamp.ps1 -Target docs/explanation/.assets
---
#>

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
