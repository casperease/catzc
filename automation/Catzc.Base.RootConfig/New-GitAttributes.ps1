<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/New-GitAttributes.ps1
    name: new-git-attributes
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.RootConfig/tests/New-GitAttributes.Tests.ps1
  config:
    synopsis: |-
      Renders the repository-root .gitattributes content from the file-kinds registry — the generator behind the
      managed .gitattributes target.
    description: |-
      Reads the template (assets/root/.gitattributes) and replaces its one `{{file-kind-attributes}}` line with a
      block per file-kinds entry that declares `gitAttributes` (configs/file-kinds.yml of Catzc.Base.Globs, via
      Get-Config -Config file-kinds; each kind's subkinds first, then the kind): a `# catzc:` comment wrapping the
      entry's `gitWhy` to the line width, then one `<glob> <attributes>` line per file glob of the entry. After the
      kinds, one block per track whose track type declares `gitAttributes` (configs/track-types.yml of
      Catzc.Base.Variants): the type's `gitWhy`, then one `<place>/** <attributes>` line per place of the track. A
      template that holds the placeholder line zero or several times throws.

      This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config
      registry names for the .gitattributes target, and Build-RootConfig owns the write (through the same
      idempotent Write-FileIfChanged path as every managed file; see
      [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
    outputs: '[string] The rendered .gitattributes content (LF-joined; the writer canonicalises).'
---
#>

function New-GitAttributes {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $placeholder = '{{file-kind-attributes}}'
    $width = 118

    $templatePath = Get-CatzcModuleRoot 'assets/root/.gitattributes'
    Assert-PathExist $templatePath
    $template = [System.IO.File]::ReadAllText($templatePath) -replace "`r`n", "`n"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    if ($placeholderLines.Count -ne 1) {
        throw "The .gitattributes template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $templatePath"
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    $addBlock = {
        param([string] $Why, [string[]] $Globs, [string[]] $Attributes)
        $lines = [System.Collections.Generic.List[string]]::new()
        $current = '# catzc:'
        foreach ($word in ($Why -split '\s+' | Where-Object { $_ })) {
            if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
                $lines.Add($current)
                $current = '#'
            }
            $current += " $word"
        }
        $lines.Add($current)
        foreach ($glob in $Globs) {
            $lines.Add("$glob $($Attributes -join ' ')")
        }
        $blocks.Add($lines -join "`n")
    }
    foreach ($kind in (Get-Config -Config file-kinds).kinds) {
        foreach ($entry in @($kind.subkinds) + $kind) {
            if (@($entry.gitAttributes).Count -gt 0) {
                & $addBlock $entry.gitWhy @($entry.files) @($entry.gitAttributes)
            }
        }
    }
    # A track type that declares attributes gives them to every file under each place of each track of that type.
    $trackTypes = Get-Config -Config track-types
    foreach ($track in @(Get-Track)) {
        $type = $trackTypes.TypeOf($track.type)
        if ($type -and @($type.gitAttributes).Count -gt 0) {
            & $addBlock $type.gitWhy @($track.places | ForEach-Object { "$_/**" }) @($type.gitAttributes)
        }
    }

    $template.Replace($placeholder, ($blocks -join "`n`n"))
}
