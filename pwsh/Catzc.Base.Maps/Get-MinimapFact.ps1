<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Get-MinimapFact.ps1.md"
  header: "generated"
---
#>

function Get-MinimapFact {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # A file's place is read from where it sits, never from its head: its track, the module that holds it and its
    # language.
    $languages = Get-Config -Config languages
    $facts = @{}
    foreach ($file in @($Path | Sort-Object -Unique)) {
        $track = Get-Track -Path $file
        $module = Get-PathModule $file
        $language = $languages.ForPath($file)
        $facts[$file] = @{
            track      = if ($track) {
                $track.name
            }
            else {
                ''
            }
            tracktype  = if ($track) {
                $track.type
            }
            else {
                ''
            }
            vendor     = if ($track -and $track.vendor) {
                $track.vendor
            }
            else {
                ''
            }
            module     = if ($module) {
                $module.name
            }
            else {
                ''
            }
            moduletype = if ($module) {
                $module.type
            }
            else {
                ''
            }
            language   = if ($language) {
                $language.name
            }
            else {
                ''
            }
        }
    }
    $facts
}
