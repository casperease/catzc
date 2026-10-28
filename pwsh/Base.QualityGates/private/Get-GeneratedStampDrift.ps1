function Get-GeneratedStampDrift {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Catzc.Base.Languages.FileCarrierResolver] $Resolver = [Catzc.Base.Languages.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $stampPattern = [regex] 'with_body_sha:\s*\\?"?(?<hash>[0-9a-f]{12})'
    # Only a stamp that is the hash of its body lets a file pass; anything else is a miss, which its writer's render decides.
    foreach ($file in $Path) {
        $relative = $file -replace '\\', '/'
        $carrier = $Resolver.For($relative)
        $full = Join-Path $root $relative
        if ($null -eq $carrier -or $carrier.carrier -in [Catzc.Base.Languages.CarrierKind]::None, [Catzc.Base.Languages.CarrierKind]::Banner -or
            -not [System.IO.File]::Exists($full)) {
            $relative
            continue
        }
        $hasHead = $false
        $bodyHash = $null
        # A png holds its head in a tEXt chunk, so it is read as bytes; a file that is no png has no chunk to read.
        if ($carrier.carrier -eq [Catzc.Base.Languages.CarrierKind]::PngText) {
            $bytes = [System.IO.File]::ReadAllBytes($full)
            if (-not [Catzc.Base.Languages.PngTextCarrier]::IsPng($bytes)) {
                $relative
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
        if (-not $hasHead -or -not $match.Success -or $match.Groups['hash'].Value -cne $bodyHash) {
            $relative
        }
    }
}
