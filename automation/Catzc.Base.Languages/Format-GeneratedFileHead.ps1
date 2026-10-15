<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1
    kind: function
    module: Catzc.Base.Languages
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#7
---
#>

<#
.SYNOPSIS
    Returns the text of a generated file with the meta head that says which generator or source wrote it.
.DESCRIPTION
    A writer composes its content bare and this adds the one head, so no generator hand-words a banner.
    [comment:1](/docs/references/automation/catzc-base-languages/Format-GeneratedFileHead.ps1.md#comment1)
.PARAMETER Text
    The whole content the generator composed, without any head.
.PARAMETER Path
    The repository-relative path the content is written to. It names the file in the head and finds its language.
.PARAMETER Carrier
    The id of the file-carriers entry that says where the head goes. Default: the entry of the file language of Path.
.PARAMETER Generator
    The command that composed the content, when one did.
.PARAMETER Source
    The repository-relative authored file or files the content comes from, when it has any.
.PARAMETER Kind
    The kind written into the head. Default: generated-from-source.
.PARAMETER Carriers
    The carrier registry. Default: the shipped file-carriers.yml.
.PARAMETER Languages
    The file-language registry. Default: the shipped languages.yml.
.PARAMETER Head
    The head keys in writing order. Default: the shipped generated-head.yml.
.OUTPUTS
    [string] The text with the head written first.
.EXAMPLE
    Format-GeneratedFileHead -Text $content -Path .gitignore -Carrier dotfile -Generator New-GitIgnore
#>
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

        [string] $Kind = 'generated-from-source',

        [Catzc.Base.Languages.FileCarriersConfig] $Carriers = (Get-Config -Config file-carriers),

        [Catzc.Base.Languages.LanguagesConfig] $Languages = (Get-Config -Config languages),

        [Catzc.Base.Languages.GeneratedHeadConfig] $Head = (Get-Config -Config generated-head)
    )

    $relative = $Path -replace '\\', '/'
    $id = $Carrier
    if (-not $id) {
        $language = $Languages.ForPath($relative)
        Assert-NotNull $language -ErrorText "Format-GeneratedFileHead: '$relative' has no file language, so name its carrier (a file-carriers.yml id) with -Carrier."
        $id = $language.name
    }
    $entry = $Carriers.Find($id)
    Assert-NotNull $entry -ErrorText "Format-GeneratedFileHead: '$relative' names the carrier '$id', which file-carriers.yml does not declare."

    $values = @{ path = $relative; kind = $Kind }
    if ($Generator) {
        $values['generator'] = $Generator
    }
    if ($Source.Count -eq 1) {
        $values['source'] = $Source[0]
    }
    elseif ($Source.Count -gt 1) {
        $values['source'] = [string[]] $Source
    }
    $facts = [ordered]@{}
    foreach ($key in $Head.order) {
        if ($values.ContainsKey($key)) {
            $facts[$key] = $values[$key]
        }
    }

    switch ($entry.carrier) {
        ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
            Format-CodeMetaHead -Text $Text -Form $entry.Form() -Fact $facts
        }
        ([Catzc.Base.Languages.CarrierKind]::Property) {
            Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Fact $facts
        }
        default {
            throw "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), and only a comment head or a property can be written into generated content."
        }
    }
}
