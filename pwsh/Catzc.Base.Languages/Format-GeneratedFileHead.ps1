<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1
    name: format-generated-file-head
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1
    docs: "[Format-GeneratedFileHead.ps1.md](docs/references/pwsh/catzc-base-languages/Format-GeneratedFileHead.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-COMPOSEDFILES
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

        [Parameter(Mandatory)]
        [object] $FileKind,

        [Catzc.Base.Languages.FileCarriersConfig] $Carriers = (Get-Config -Config file-carriers),

        [Catzc.Base.Languages.LanguagesConfig] $Languages = (Get-Config -Config languages),

        [Catzc.Base.Languages.GeneratedHeadConfig] $Head = (Get-Config -Config generated-head),

        [Catzc.Base.CodeMeta.CommentPagesConfig] $Pages = (Get-Config -Config comment-pages)
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

    # The head says what not to touch and what to edit instead; every other fact about the file is derived on demand.
    $values = @{ warning = $Head.warning; role = $FileKind.role }
    # A root file is in no track.
    $track = Get-Track -Path $relative
    if ($track) {
        $values['track'] = $track.name
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
    $facts = [ordered]@{}
    foreach ($key in $Head.order) {
        if ($values.ContainsKey($key)) {
            $facts[$key] = $values[$key]
        }
    }
    # The relatives only: the comment page when it exists, as the relative-edges processor writes its docs relation.
    $edges = [ordered]@{}
    $page = Get-CommentPage -Path $relative -Config $Pages
    if ($page -and [System.IO.File]::Exists((Join-Path (Get-RepositoryRoot) $page))) {
        $edges['docs'] = "[$([System.IO.Path]::GetFileName($page))]($page)"
    }

    switch ($entry.carrier) {
        ([Catzc.Base.Languages.CarrierKind]::CommentHead) {
            Format-CodeMetaHead -Text $Text -Form $entry.Form() -Immutable $facts -Edges $edges
        }
        ([Catzc.Base.Languages.CarrierKind]::FrontMatter) {
            Format-MarkdownMetaBlock -Text $Text -Immutable $facts -Edges $edges -Key $entry.key
        }
        ([Catzc.Base.Languages.CarrierKind]::Property) {
            Format-PropertyMetaHead -Text $Text -Property $entry.property -Strip $entry.strip -Immutable $facts -Edges $edges
        }
        default {
            throw "Format-GeneratedFileHead: '$relative' uses the carrier '$id' of kind $($entry.carrier), and only front matter, a comment head or a property can be written into generated content."
        }
    }
}
