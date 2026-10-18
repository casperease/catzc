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

        [string] $Generator,

        [string[]] $Source = @(),

        [string] $InputsSha,

        [Parameter(Mandatory)]
        [object] $FileKind,

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

    # A generated file is locked: its source is the truth, so the head says to edit that instead.
    $values = @{ repo_status = 'locked'; path = $relative; role = $FileKind.role }
    if ($FileKind.subkind) {
        $values['subkind'] = $FileKind.subkind
    }
    # A file no language lists, such as a dotfile, has none to name.
    if ($language) {
        $values['language'] = $language.name
    }
    $fileType = Get-PathFileType $relative
    if ($fileType) {
        $values['filetype'] = $fileType
    }
    # A root file is in no track, and a file outside pwsh/ is in no module.
    $track = Get-Track -Path $relative
    if ($track) {
        $values['track'] = $track.name
        $values['tracktype'] = $track.type
        if ($track.vendor) {
            $values['vendor'] = $track.vendor
        }
    }
    $module = Get-PathModule $relative
    if ($module) {
        $values['module'] = $module.name
        $values['moduletype'] = $module.type
    }
    if ($Generator) {
        $values['generator'] = Get-GeneratorPath $Generator
    }
    if ($Source.Count -eq 1) {
        $values['source'] = $Source[0]
    }
    elseif ($Source.Count -gt 1) {
        $values['source'] = [string[]] $Source
    }
    # The body is what sits below the head the carrier holds, so a second run over the written file finds the same hash.
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
    if ($InputsSha) {
        $values['with_inputs_sha'] = $InputsSha
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
