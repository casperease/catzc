function Assert-BicepParamSibling {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $File,

        [Parameter(Mandatory)]
        [string] $Template
    )

    $name = [System.IO.Path]::GetFileName($File)
    $content = [System.IO.File]::ReadAllText($File) | ConvertFrom-Yaml -Ordered
    if ($null -eq $content) {
        return
    }
    if ($content -isnot [System.Collections.IDictionary]) {
        throw "Template '$Template': $name sits beside a bicepparam slot, so it may hold only a top-level ResourceGroup."
    }
    foreach ($key in @($content.Keys)) {
        if ($key -ne 'ResourceGroup') {
            throw "Template '$Template': $name sits beside a bicepparam slot, so it may hold only ResourceGroup, not '$key'."
        }
    }
}
