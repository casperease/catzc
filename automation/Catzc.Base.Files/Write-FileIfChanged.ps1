<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Write-FileIfChanged.ps1
    name: write-file-if-changed
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md
    test: automation/Catzc.Base.Files/tests/Write-FileIfChanged.Tests.ps1
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-DRYRUN
      - ADR-PRIN-ONELIVE
  config:
    synopsis: |-
      Writes canonical text to a file only when its content actually changed — the shared primitive behind
      every idempotent "keep this generated file current" writer.
    description: |-
      Canonicalises the given content (LF endings, exactly one trailing newline) and compares it to what is on
      disk, ignoring line endings (CR stripped) — so a CRLF working tree (git core.autocrlf, an editor's
      format-on-save) never triggers a spurious rewrite (mirrors the compiled-type cache guard — see
      [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). Only on a real content difference is the file written, as UTF-8
      without
      BOM; a missing parent directory is created. Returns whether the file changed (or would change under
      -DryRun), so a caller can drive its own status line.

      A changed write is delete-then-write, never in-place: writing through a symbolic or hard link at the
      target path would tunnel the composed content into the link's source of truth (a Set-FileLink target that
      an entry stopped declaring), so the write always produces a fresh, independent file.

      This is the write tail every generated-artifact builder shares (Build-RootConfig, Build-GitKeep, …) —
      one living copy of the canonicalise/compare/write logic instead of one per builder (see
      [ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)). It is a pure primitive: no console output — callers
      own
      their reporting.
    parameters:
      Path: Path of the target file to write.
      Content: |-
        The full intended content. Canonicalised before compare and write: CR stripped, trailing newlines
        collapsed to exactly one.
      DryRun: |-
        Report whether the file would change without writing it. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
    outputs: '[bool] $true when the file was written (or would be, under -DryRun); $false when already current.'
    examples:
      - Write-FileIfChanged -Path $readmePath -Content $composed
      - Write-FileIfChanged -Path $settingsPath -Content $composed -DryRun
---
#>

function Write-FileIfChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyString()]
        [string] $Content,

        [switch] $DryRun
    )

    # Canonical text: LF endings, exactly one trailing newline.
    $canonical = (($Content -replace "`r", '').TrimEnd("`n")) + "`n"

    # EOL-insensitive compare against what is on disk: strip CR so a CRLF/LF flip never counts as a change.
    $existing = if ([System.IO.File]::Exists($Path)) {
        [System.IO.File]::ReadAllText($Path) -replace "`r", ''
    }
    else {
        $null
    }
    $changed = $canonical -cne $existing

    if ($changed -and -not $DryRun) {
        $directory = [System.IO.Path]::GetDirectoryName($Path)
        if ($directory) {
            [System.IO.Directory]::CreateDirectory($directory) | Out-Null
        }
        if ([System.IO.File]::Exists($Path)) {
            [System.IO.File]::Delete($Path)
        }
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Path, $canonical, $utf8NoBom)
    }

    $changed
}
