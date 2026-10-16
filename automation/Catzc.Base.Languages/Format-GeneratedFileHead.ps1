<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1
    name: format-generated-file-head
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#7
  config:
    synopsis: Returns the text of a generated file with the meta head that says which generator or source wrote it.
    description: |-
      The head is the one unified form of ADR-REPO-FILEMETA#7: the kind of the file by its role, and its subkind when it has one, as the
      caller read them from the file-kinds registry; the file language, the file type (extension), the track and the module when the file
      has them; and the generator and the source when the file has them. The generator is written as the path of the file its command is
      defined in. The head opens with the hash of the body below it, read through the carrier so a head already in the text never moves
      it, and a tracked generated file of any language says which text its writer composed. The carrier is named by id, or found from the
      file's language when no id is given.
    parameters:
      Text: The whole content the generator composed, without any head.
      Path: The repository-relative path the content is written to. It names the file in the head and finds its language.
      Carrier: 'The id of the file-carriers entry that says where the head goes. Default: the entry of the file language of Path.'
      Generator: The command that composed the content, when one did; the head names the path of its file.
      Source: The repository-relative authored file or files the content comes from, when it has any.
      InputsSha: 'The stamp (Get-InputStamp) of every input the generator read, when it skips an unchanged build; the head carries it as with_inputs_sha, which Test-GeneratedFileCurrent compares. Default: none, and the key is left out.'
      FileKind: 'The kind of Path by its role: what Get-FileKind returns for it (kind, and subkind when it has one). The caller reads it, since the registry lives in a module this one cannot depend on.'
      Carriers: 'The carrier registry. Default: the shipped file-carriers.yml.'
      Languages: 'The file-language registry. Default: the shipped languages.yml.'
      Head: 'The head keys in writing order. Default: the shipped generated-head.yml.'
    outputs: '[string] The text with the head written first.'
    examples:
      - Format-GeneratedFileHead -Text $content -Path .gitignore -Carrier dotfile -Generator New-GitIgnore -FileKind (Get-FileKind .gitignore)
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
    $values = @{ repo_status = 'locked'; path = $relative; kind = $FileKind.kind }
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
    # A root file is in no track, and a file outside automation is in no module.
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
