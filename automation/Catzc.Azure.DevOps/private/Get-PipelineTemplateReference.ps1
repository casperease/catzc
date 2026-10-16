<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1
    adrs:
      - ADR-PIPE-NAME#4
  config:
    synopsis: |-
      Extracts the template references (`template:` values) from a pipeline YAML file — the paths a
      naming/placement quality gate checks for absoluteness.
    description: |-
      Reads the file and returns each `template:` mapping value, whether written as a `steps`/`jobs`/… include
      (`- template: /pipelines/steps/x.yaml`) or inside an `extends:` block (`template: /pipelines/extends/…`).
      It is a line scan, not a YAML parse, so it is robust to the template expressions ADO YAML carries.

      Only genuine file references are returned: a value that is a template EXPRESSION (`${{ … }}`) or carries
      a runtime variable (`$( … )`) is skipped (its target is not statically known), and a value that does not
      end in `.yaml` is ignored (it is not a template path). Comment lines (`#`) never match.
    parameters:
      Path: The pipeline YAML file to scan.
    outputs: '[string[]] The referenced template paths, verbatim (quotes stripped). Empty when the file has none.'
---
#>

function Get-PipelineTemplateReference {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $refs = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Get-Content -Path $Path)) {
        # A `template:` key at a mapping position, optionally the first entry of a list item (`- template:`).
        if ($line -notmatch '^\s*(?:-\s*)?template:\s*(.+?)\s*$') {
            continue
        }
        $value = $matches[1].Trim().Trim('"', "'")

        # Skip template expressions / runtime variables — their target is not a static path.
        if ($value -match '\$\{\{' -or $value -match '\$\(') {
            continue
        }
        # Only actual template file paths (.yaml); anything else is not a reference we validate.
        if ($value -notmatch '\.yaml$') {
            continue
        }
        $refs.Add($value)
    }
    $refs.ToArray()
}
