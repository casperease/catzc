<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-FileKind.ps1
    name: get-file-kind
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#2
  config:
    synopsis: Returns the kind of a file by its role, and its subkind when it has one, from the file-kinds registry.
    description: |-
      The kind is the role of the file and never its language, track or module, which are keys of their own. The first kind of the
      file-kinds registry whose globs, or whose subkinds' globs, match the path names it, and a path no entry selects is `other`. The
      registry is local to catzc and global to every file, and a consumer extends it with a config fragment
      ([ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)).
    parameters:
      Path: A repository-relative path ('/' or '\' separated).
    outputs: '[Catzc.Base.Globs.FileKindMatch] The kind, the subkind (null when none), the kind''s definition, and Class, what a selector matches.'
    examples:
      - '(Get-FileKind ''automation/Catzc.Base.Variants/Test-GitWorkspace.ps1'')   # -> Class function/gate'
      - '(Get-FileKind ''elsewhere/notes.txt'').kind                                # -> other'
---
#>

function Get-FileKind {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.FileKindMatch])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    (Get-Config -Config file-kinds).Resolve(($Path -replace '\\', '/'))
}
