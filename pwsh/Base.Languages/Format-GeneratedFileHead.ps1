function Format-GeneratedFileHead {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Path,

        [string] $Carrier,

        [Catzc.Base.Languages.FileCarriersConfig] $Carriers = (Get-Config -Config file-carriers),

        [Catzc.Base.Languages.LanguagesConfig] $Languages = (Get-Config -Config languages),

        [Catzc.Base.Languages.GeneratedHeadConfig] $Head = (Get-Config -Config generated-head)
    )

    $relative = $Path -replace '\\', '/'
    $language = $Languages.ForPath($relative)
    $id = $Carrier
    if (-not $id) {
        Assert-NotNull $language -ErrorText "Format-GeneratedFileHead: '$relative' has no file language, so name its carrier (a file-carriers.yml id) with -Carrier."
        $id = $language.name
    }
    $entry = $Carriers.Find($id)
    Assert-NotNull $entry -ErrorText "Format-GeneratedFileHead: '$relative' names the carrier '$id', which file-carriers.yml does not declare."

    # A banner is the language's own one-line marker: it replaces a banner already there and holds no body hash, so it suits an untracked file only.
    if ($entry.carrier -eq [Catzc.Base.Languages.CarrierKind]::Banner) {
        Assert-True (@(Get-GitTrackedPath $relative) -notcontains $relative) -ErrorText "Format-GeneratedFileHead: '$relative' is tracked, and its banner carrier '$id' holds no body hash; give it a carrier with a meta block."
        $body = $Text -replace '\r\n', "`n"
        if ($body.StartsWith("$($entry.banner)`n", [System.StringComparison]::Ordinal)) {
            $body = $body.Substring($entry.banner.Length + 1).TrimStart("`n")
        }
        return "$($entry.banner)`n`n$body"
    }

    # The head says what not to touch; every other fact about the file is derived on demand.
    $values = @{ warning = $Head.warning }
    # A tracked file's head also carries its body's hash; an untracked one carries the warning only.
    $tracked = @(Get-GitTrackedPath $relative) -contains $relative
    if ($tracked) {
        # The body below the carrier's head, so a second run over the written file finds the same hash.
        $body = switch ($entry.carrier) {
            ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
                $state = Get-CodeMetaState -Text $Text -Form $entry.Form()
                if ($state.HasHead) {
                    $state.Rest
                }
                else {
                    $Text
                }
            }
            ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
                (Get-MarkdownMetaState -Text $Text -Key $entry.key).Body
            }
            ([Catzc.Base.Languages.CarrierKind]::Property) {
                Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Immutable ([ordered]@{})
            }
            default {
                $Text
            }
        }
        $values['with_body_sha'] = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($body)
    }
    $facts = [ordered]@{}
    foreach ($key in $Head.order) {
        if ($values.ContainsKey($key)) {
            $facts[$key] = $values[$key]
        }
    }
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
        default {
            throw "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), and only front matter, a comment head or a property can be written into generated content."
        }
    }
}
