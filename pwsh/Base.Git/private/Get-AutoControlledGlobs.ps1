<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md"
  header: "generated"
---
#>

function Get-AutoControlledGlobs {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $ret = [System.Collections.Generic.List[string]]::new()

    # The managed, gitignored root-config targets — the registry names them (generated-root-configs).
    $rootConfig = Get-Config -Config rootconfig
    foreach ($entry in $rootConfig.files) {
        if ($entry.optIn -and -not $entry.committed) {
            $ret.Add($entry.target)
        }
    }

    # The gitignored members whose writer is a generator: a glob as written, a folder glob as its folder and its contents.
    $targets = @(Get-GeneratedTarget)
    foreach ($member in @(Get-TrackMember -Committed $false)) {
        $written = $member.generated -or @($targets | Where-Object {
                [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($_.path), [string[]] @($member.path)).Count -gt 0
            }).Count -gt 0
        if (-not $written) {
            continue
        }
        # A folder member, written as a '/**' glob or as a folder on disk such as the out track's out, is the folder and its content.
        $folder = if ($member.path.EndsWith('/**', [System.StringComparison]::Ordinal)) {
            $member.path.Substring(0, $member.path.Length - 3)
        }
        elseif ([System.IO.Directory]::Exists((Join-Path (Get-RepositoryRoot) $member.path))) {
            $member.path
        }
        if ($folder) {
            $ret.Add($folder)
            $ret.Add("$folder/*")
        }
        else {
            # Generated members, module manifests among them; vendored .psd1 are committed, so never clean candidates.
            $ret.Add($member.path)
        }
    }

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    # Generated cspell dictionaries, regenerated at the importer tail.
    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # out/ comes from the out track's member above; the plans parked in it stay out of a clean.
    $ret.Add('!out/plan-*.md')

    # The generated .vscode editor config (generated-root-configs); clean may list the whole folder.
    $ret.Add('.vscode')
    $ret.Add('.vscode/*')

    # The drawio autosave shadow lies in any folder, so it is no one track's member.
    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
