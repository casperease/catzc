<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1
    name: test-generated-file-current
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
    test: automation/Catzc.Base.Languages/tests/Test-GeneratedFileCurrent.Tests.ps1
    cites:
      - ADR-PRIN-ONELIVE
  config:
    synopsis: Tells whether a generated file was written from exactly the inputs a stamp describes.
    description: |-
      Reads the `with_inputs_sha` the file's head carries (Format-GeneratedFileHead -InputsSha) and compares it with the
      stamp of the inputs as they are now (Get-InputStamp). Equal means the generator would write the same file, so it
      can return without reading its inputs. A file that does not exist, has no head, or carries no inputs stamp is not
      current.

      Only the start of the file is read, however large it is, and the key is found by its name, so the one check holds
      for every carrier (front matter, a comment head, a property).
    parameters:
      Path: The generated file to check.
      InputsSha: The stamp of the inputs as they are now, from Get-InputStamp.
    outputs: '[bool] $true when the file exists and its with_inputs_sha equals -InputsSha; $false otherwise.'
    examples:
      - Test-GeneratedFileCurrent -Path (Resolve-RepoPath 'docs/adr/glossary.md') -InputsSha $stamp
---
#>

function Test-GeneratedFileCurrent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $InputsSha
    )

    if (-not [System.IO.File]::Exists($Path)) {
        return $false
    }

    # The head sits first in the file, so a bounded read is enough.
    $buffer = [char[]]::new(4096)
    $reader = [System.IO.StreamReader]::new($Path)
    try {
        $count = $reader.Read($buffer, 0, $buffer.Length)
    }
    finally {
        $reader.Dispose()
    }
    $start = [string]::new($buffer, 0, $count)

    $match = [regex]::Match($start, 'with_inputs_sha:\s*\\?"?([0-9a-f]{64})')
    $match.Success -and $match.Groups[1].Value -ceq $InputsSha
}
