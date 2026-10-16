<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1
    kind: function
    subkind: formatter
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Languages
    visibility: public
    relatives:
      test: automation/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#7
  config:
    synopsis: Returns the text of a generated file with the meta head that says which generator or source wrote it.
    description: |-
      The head is the one unified form of ADR-REPO-FILEMETA#7: kind generated-from-source, the file language, the track and the module when the file
      has them, and the generator and the source when the file has them. The generator is written as the path of the file its command is defined in. The carrier is named by id, or found from the
      file's language when no id is given.
    parameters:
      Text: The whole content the generator composed, without any head.
      Path: The repository-relative path the content is written to. It names the file in the head and finds its language.
      Carrier: 'The id of the file-carriers entry that says where the head goes. Default: the entry of the file language of Path.'
      Generator: The command that composed the content, when one did; the head names the path of its file.
      Source: The repository-relative authored file or files the content comes from, when it has any.
      Tracked: The file is tracked by git, so it gets the tracked kind of generated-head.yml instead of the plain generated kind.
      Carriers: 'The carrier registry. Default: the shipped file-carriers.yml.'
      Languages: 'The file-language registry. Default: the shipped languages.yml.'
      Head: 'The head keys in writing order. Default: the shipped generated-head.yml.'
    outputs: '[string] The text with the head written first.'
    examples:
      - Format-GeneratedFileHead -Text $content -Path .gitignore -Carrier dotfile -Generator New-GitIgnore
---
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

        [switch] $Tracked,

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

    $kind = if ($Tracked) {
        $Head.tracked_kind
    }
    else {
        $Head.kind
    }
    $values = @{ path = $relative; kind = $kind }
    # A file no language lists, such as a dotfile, has none to name.
    if ($language) {
        $values['language'] = $language.name
    }
    $fileKind = Get-PathFileKind $relative
    if ($fileKind) {
        $values['filekind'] = $fileKind
    }
    # A root file is in no track, and a file outside automation is in no module.
    $track = Get-Track -Path $relative
    if ($track) {
        $values['track'] = $track.name
    }
    $module = Get-PathModule $relative
    if ($module) {
        $values['module'] = $module
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
        ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
            Format-MarkdownMetaBlock -Text $Text -Fact $facts
        }
        ([Catzc.Base.Languages.CarrierKind]::Property) {
            Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Fact $facts
        }
        default {
            throw "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), and only front matter, a comment head or a property can be written into generated content."
        }
    }
}
