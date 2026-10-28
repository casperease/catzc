function Get-GeneratedStampDrift {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [switch] $Changed,

        [Catzc.Base.Languages.FileCarrierResolver] $Resolver = [Catzc.Base.Languages.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    # -Changed reads only the files git reports changed against HEAD, so the check costs the changed set, not the tree.
    $changedSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($Changed) {
        $changedSet.UnionWith([string[]] @(Get-GitChangedPath))
    }
    # @() around the whole if: an empty list must stay an array (.Count under strict mode).
    $generated = @(if ($PSBoundParameters.ContainsKey('Path')) {
            $Path | Where-Object { -not $Changed -or $changedSet.Contains(($_ -replace '\\', '/')) }
        }
        else {
            $tracked = [string[]] @(Get-GitTrackedPath '.' | Where-Object { -not $Changed -or $changedSet.Contains($_) })
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
        # A carrier of kind none holds no head, and a banner holds no body hash.
        if ($null -eq $carrier -or $carrier.carrier -in [Catzc.Base.Languages.CarrierKind]::None, [Catzc.Base.Languages.CarrierKind]::Banner) {
            continue
        }
        $full = Join-Path $root $relative
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        $hasHead = $false
        $bodyHash = $null
        # A png holds its head in a tEXt chunk, so it is read as bytes; a file that is no png has no chunk to read and is skipped.
        if ($carrier.carrier -eq [Catzc.Base.Languages.CarrierKind]::PngText) {
            $bytes = [System.IO.File]::ReadAllBytes($full)
            if (-not [Catzc.Base.Languages.PngTextCarrier]::IsPng($bytes)) {
                continue
            }
            $headText = [Catzc.Base.Languages.PngTextCarrier]::Text($bytes)
            $hasHead = $null -ne $headText
            $bodyHash = [Catzc.Base.Languages.PngTextCarrier]::HashOf([Catzc.Base.Languages.PngTextCarrier]::Body($bytes))
        }
        else {
            $text = [System.IO.File]::ReadAllText($full)
            $headText = $text
        }
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
            # An svg and an xml file hold the head in one element their carrier type strips, so the stripped text is the body.
            ([Catzc.Base.Languages.CarrierKind]::Metadata) {
                $body = [Catzc.Base.Languages.SvgMetadataCarrier]::Body($text)
                $hasHead = $body -cne $text
                $bodyHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($body)
            }
            ([Catzc.Base.Languages.CarrierKind]::ProcessingInstruction) {
                $body = [Catzc.Base.Languages.XmlInstructionCarrier]::Body($text)
                $hasHead = $body -cne $text
                $bodyHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($body)
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
