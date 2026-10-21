<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1
    folder: private
    name: get-file-meta-input-stamp
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-FileMetaInputStamp.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-FileMetaInputStamp.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
---
#>

function Get-FileMetaInputStamp {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Catzc.Base.QualityGates.FileMetaConfig] $Config = (Get-Config -Config file-meta)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $edgeKinds = @($Config.Imprint() | Where-Object { $_.settings.ContainsKey('relations') })
    $parts = [ordered]@{}
    foreach ($path in $File) {
        $full = [System.IO.Path]::GetFullPath($path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        $fileParts = [System.Collections.Generic.List[string]]::new()
        # The page's text is read for the cites; a relation's candidate counts by whether it is on disk.
        $page = Get-CommentPage -Path $relative
        if ($page) {
            $pagePath = [System.IO.Path]::Combine($root, $page)
            $pageHash = if ([System.IO.File]::Exists($pagePath)) {
                [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($pagePath)))
            }
            else {
                'missing'
            }
            $fileParts.Add("page:${page}:$pageHash")
        }
        $parts[$relative] = @($full, $fileParts)
    }
    foreach ($kind in $edgeKinds) {
        foreach ($entry in @(Get-RelativeEdgeCandidate -Path ([string[]] @($parts.Keys)) -Kind $kind)) {
            foreach ($candidate in $entry.Paths) {
                $parts[$entry.Path][1].Add("$($entry.Relation['name']):${candidate}:$([System.IO.File]::Exists([System.IO.Path]::Combine($root, $candidate)))")
            }
        }
    }
    $stamps = @{}
    foreach ($pair in $parts.Values) {
        $stamps[$pair[0]] = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($pair[1] -join "`n")))
    }
    $stamps
}
