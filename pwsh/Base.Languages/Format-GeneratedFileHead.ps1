function Format-GeneratedFileHead {
    [CmdletBinding(DefaultParameterSetName = 'Text')]
    [OutputType([string], ParameterSetName = 'Text')]
    [OutputType([byte[]], ParameterSetName = 'Bytes')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Text')]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory, ParameterSetName = 'Bytes')]
        [byte[]] $Bytes,

        [Parameter(Mandatory)]
        [string] $Path,

        [string] $Carrier,

        [string] $Writer,

        [Catzc.Base.Languages.FileCarriersConfig] $Carriers = (Get-Config -Config file-carriers),

        [Catzc.Base.Languages.LanguagesConfig] $Languages = (Get-Config -Config languages),

        [Catzc.Base.Languages.GeneratedHeadConfig] $Head = (Get-Config -Config generated-head)
    )

    $relative = $Path -replace '\\', '/'
    # A named carrier wins; otherwise the entry whose globs take the path, then the entry of its file language.
    if ($Carrier) {
        $entry = $Carriers.Find($Carrier)
        Assert-NotNull $entry -ErrorText "Format-GeneratedFileHead: '$relative' names the carrier '$Carrier', which file-carriers.yml does not declare."
    }
    else {
        $entry = [Catzc.Base.Languages.FileCarrierResolver]::new($Carriers, $Languages).For($relative)
        Assert-NotNull $entry -ErrorText "Format-GeneratedFileHead: '$relative' matches no file-carriers.yml entry, by glob or by file language, so it has no carrier to stamp."
    }
    $id = $entry.id
    # A png is bytes and every other carrier is text, so the content comes by the parameter its carrier reads.
    $binary = $entry.carrier -eq [Catzc.Base.Languages.CarrierKind]::PngText
    $takes = if ($binary) {
        'Bytes'
    }
    else {
        'Text'
    }
    Assert-True ($PSCmdlet.ParameterSetName -eq $takes) -ErrorText "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), which takes its content by -$takes."

    # A banner is the language's own one-line marker: it replaces a banner already there and holds no body hash, so it suits an untracked file only.
    if ($entry.carrier -eq [Catzc.Base.Languages.CarrierKind]::Banner) {
        Assert-True (@(Get-GitTrackedPath $relative) -notcontains $relative) -ErrorText "Format-GeneratedFileHead: '$relative' is tracked, and its banner carrier '$id' holds no body hash; give it a carrier with a meta block."
        $body = $Text -replace '\r\n', "`n"
        if ($body.StartsWith("$($entry.banner)`n", [System.StringComparison]::Ordinal)) {
            $body = $body.Substring($entry.banner.Length + 1).TrimStart("`n")
        }
        return "$($entry.banner)`n`n$body"
    }

    # The head says what not to touch; a tracked file's head also says how it is rendered again, and its body's hash.
    $values = @{ warning = $Head.warning }
    $tracked = @(Get-GitTrackedPath $relative) -contains $relative
    if ($tracked -and $Writer) {
        $row = Get-GeneratedWriterRow -Name $Writer
        $regenerate = if ($row.regenerate) {
            $row.regenerate
        }
        else {
            $Head.regenerate
        }
        $values['regenerate'] = $regenerate.Replace('{writer}', $row.name).Replace('{path}', $relative).Replace('{paths}', $relative)
    }
    if ($tracked) {
        # The body below the carrier's head, so a second run over the written file finds the same hash.
        $values['with_body_sha'] = switch ($entry.carrier) {
            ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
                $state = Get-CodeMetaState -Text $Text -Form $entry.Form()
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($(if ($state.HasHead) {
                            $state.Rest
                        }
                        else {
                            $Text
                        }))
            }
            ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf((Get-MarkdownMetaState -Text $Text -Key $entry.key).Body)
            }
            ([Catzc.Base.Languages.CarrierKind]::Property) {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf((Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Immutable ([ordered]@{})))
            }
            ([Catzc.Base.Languages.CarrierKind]::PngText) {
                [Catzc.Base.Languages.PngTextCarrier]::HashOf([Catzc.Base.Languages.PngTextCarrier]::Body($Bytes))
            }
            ([Catzc.Base.Languages.CarrierKind]::Metadata) {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf([Catzc.Base.Languages.SvgMetadataCarrier]::Body($Text))
            }
            ([Catzc.Base.Languages.CarrierKind]::ProcessingInstruction) {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf([Catzc.Base.Languages.XmlInstructionCarrier]::Body($Text))
            }
            default {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($Text)
            }
        }
    }
    $facts = [ordered]@{}
    foreach ($key in $Head.order) {
        if ($values.ContainsKey($key)) {
            $facts[$key] = $values[$key]
        }
    }
    # The png, svg and xml stamps hold the same block a text head holds, rendered by the one block renderer.
    $block = [string]::Join("`n", [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, $null, $null))
    switch ($entry.carrier) {
        ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
            Format-CodeMetaHead -Text $Text -Form $entry.Form() -Immutable $facts
        }
        ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
            Format-MarkdownMetaBlock -Text $Text -Immutable $facts -Key $entry.key
        }
        ([Catzc.Base.Languages.CarrierKind]::Property) {
            Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Immutable $facts
        }
        ([Catzc.Base.Languages.CarrierKind]::PngText) {
            , [Catzc.Base.Languages.PngTextCarrier]::With($Bytes, $block)
        }
        ([Catzc.Base.Languages.CarrierKind]::Metadata) {
            [Catzc.Base.Languages.SvgMetadataCarrier]::With($Text, $block)
        }
        ([Catzc.Base.Languages.CarrierKind]::ProcessingInstruction) {
            [Catzc.Base.Languages.XmlInstructionCarrier]::With($Text, $block)
        }
        default {
            throw "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), which holds no head a writer can stamp."
        }
    }
}
