# cspell:ignore minimaps
function Update-MinimapPageHead {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Slides
    )

    $repo = Get-RepositoryRoot
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $slideList = (Get-Content -Raw -Encoding utf8 ([System.IO.Path]::GetFullPath($Slides, $repo)) | ConvertFrom-Json).slides
    $written = 0
    $current = 0
    # Each listed diagram folder holds its slide and the sister page of each minimap beside it.
    foreach ($slide in $slideList) {
        $folder = [System.IO.Path]::GetFullPath($slide.folder, $repo)
        $slidePath = Join-Path $folder 'diagram.drawio.png'
        $source = @(if ([System.IO.File]::Exists($slidePath)) {
                [System.IO.Path]::GetRelativePath($repo, $slidePath) -replace '\\', '/'
            })
        foreach ($view in 'chain', 'grid', 'tree') {
            $page = Join-Path $folder "$view.md"
            if (-not [System.IO.File]::Exists($page)) {
                continue
            }
            $relative = [System.IO.Path]::GetRelativePath($repo, $page) -replace '\\', '/'
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
}
