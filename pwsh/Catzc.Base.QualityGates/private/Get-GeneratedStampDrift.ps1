<#
---
catzc:
  immutable:
    with_body_sha: c9a0b503ef98
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-GeneratedStampDrift.Tests.ps1
    docs: "[Get-GeneratedStampDrift.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-GeneratedStampDrift.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---
#>

function Get-GeneratedStampDrift {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Catzc.Base.QualityGates.FileCarrierResolver] $Resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    # @() around the whole if: an empty list must stay an array (.Count under strict mode).
    $generated = @(if ($PSBoundParameters.ContainsKey('Path')) {
            $Path
        }
        else {
            $tracked = [string[]] @(Get-GitTrackedPath '.')
            if ($tracked.Count -gt 0) {
                $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $tracked -Attribute linguist-generated
                $tracked | Where-Object {
                    $classes = $attributes[$_]
                    $classes -and $classes['linguist-generated'] -in 'set', 'true'
                }
            }
        })

    $stamped = 0
    $unstamped = [System.Collections.Generic.List[string]]::new()
    $issues = [System.Collections.Generic.List[string]]::new()
    $stampPattern = [regex] 'with_body_sha:\s*\\?"?(?<hash>[0-9a-f]{12})'
    foreach ($file in $generated) {
        $relative = $file -replace '\\', '/'
        $carrier = $Resolver.For($relative)
        # A binary or a file whose head lives beside it has no head of its own to stamp.
        if ($null -eq $carrier -or $carrier.carrier -in @([Catzc.Base.Languages.CarrierKind]::None, [Catzc.Base.Languages.CarrierKind]::Sidecar)) {
            continue
        }
        $full = Join-Path $root $relative
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($full)
        $hasHead = $false
        $bodyHash = $null
        $headText = $text
        switch ($carrier.carrier) {
            ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
                $state = Get-MarkdownMetaState -Text $text -Key $carrier.key
                $hasHead = $state.HasMetaBlock
                $bodyHash = $state.BodyHash
                if ($state.Body -and $text.EndsWith($state.Body, [System.StringComparison]::Ordinal)) {
                    $headText = $text.Substring(0, $text.Length - $state.Body.Length)
                }
            }
            ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
                $state = Get-CodeMetaState -Text $text -Form $carrier.Form()
                $hasHead = $state.HasHead
                $bodyHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($state.Rest)
                if ($state.Rest -and $text.EndsWith($state.Rest, [System.StringComparison]::Ordinal)) {
                    $headText = $text.Substring(0, $text.Length - $state.Rest.Length)
                }
            }
            ([Catzc.Base.Languages.CarrierKind]::Property) {
                $state = Get-PropertyMetaState -Text $text -Property $carrier.property -Strip $carrier.strip
                $hasHead = $state.IsObject -and $state.HasHead
                if ($hasHead) {
                    $body = Format-PropertyMetaHead -Text $text -Property $carrier.property -Strip $carrier.strip -Immutable ([ordered]@{})
                    $bodyHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($body)
                }
            }
        }
        $match = if ($hasHead) {
            $stampPattern.Match($headText)
        }
        if (-not $hasHead -or -not $match.Success) {
            $unstamped.Add($relative)
            continue
        }
        $stamped++
        $written = $match.Groups['hash'].Value
        if ($written -cne $bodyHash) {
            $issues.Add("${relative}: stale — the head's with_body_sha $written is not the hash of the body, $bodyHash; regenerate the file with its writer")
        }
    }

    [pscustomobject]@{
        Stamped   = $stamped
        Unstamped = [string[]] @($unstamped)
        Issues    = [string[]] @($issues)
    }
}
