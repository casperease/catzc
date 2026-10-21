<#
---
catzc:
  immutable:
    with_body_sha: "38fb0231a497"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FileMetaInputStamp.Tests.ps1
    docs: "[Get-FileMetaInputStamp.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-FileMetaInputStamp.ps1.md)"
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
    $commentPages = Get-Config -Config comment-pages
    $edgeKinds = @($Config.Imprint() | Where-Object { $_.settings.ContainsKey('relations') })
    $codeKind = @($Config.Imprint() | Where-Object { $_.id -ceq 'adr-codes' })
    $languages = Get-Config -Config languages
    $codesHash = $null
    $parts = [ordered]@{}
    foreach ($path in $File) {
        $full = [System.IO.Path]::GetFullPath($path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        $fileParts = [System.Collections.Generic.List[string]]::new()
        # The page's text is read for the cites; a relation's candidate counts by whether it is on disk.
        $page = Get-CommentPage -Path $relative -Config $commentPages
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
        # A file whose cites the adr-codes kind writes reads the registered codes, so a new or removed code rechecks it, and nothing else does.
        if ($codeKind.Count -eq 1) {
            $language = $languages.ForPath($relative)
            if ($Config.Selects($codeKind[0], (Get-FileKind $relative).Class, ($language ? $language.name : $null))) {
                if ($null -eq $codesHash) {
                    $codes = @((Get-DrsCitationMap -RepositoryRoot $root).Codes | Sort-Object -CaseSensitive) -join "`n"
                    $codesHash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($codes)))
                }
                $fileParts.Add("adr-codes:$codesHash")
            }
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
