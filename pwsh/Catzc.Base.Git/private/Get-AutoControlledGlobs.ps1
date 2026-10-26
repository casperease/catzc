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

    $targets = @(Get-GeneratedTarget)
    foreach ($member in @(Get-TrackMember -Committed $false)) {
        $written = $member.generated -or @($targets | Where-Object {
                [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($_.path), [string[]] @($member.path)).Count -gt 0
            }).Count -gt 0
        if (-not $written) {
            continue
        }
        if ($member.path.EndsWith('/**', [System.StringComparison]::Ordinal)) {
            $folder = $member.path.Substring(0, $member.path.Length - 3)
            $ret.Add($folder)
            $ret.Add("$folder/*")
        }
        else {
            $ret.Add($member.path)
        }
    }

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # out/ is written by hand until it is its own track's member (plan-track-model).
    $ret.Add('out')
    $ret.Add('out/*')
    $ret.Add('!out/plan-*.md')

    # The generated .vscode editor config (generated-root-configs); clean may list the whole folder.
    $ret.Add('.vscode')
    $ret.Add('.vscode/*')

    # The drawio autosave shadow lies in any folder, so it is no one track's member.
    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
