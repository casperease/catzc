function ConvertFrom-BicepRuntimeSlotsJson {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # A pipeline's deploy-target list ([{ env, slot?, ... }]), as convertToJson writes it.
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Json
    )

    if ([string]::IsNullOrWhiteSpace($Json)) {
        return
    }
    $entries = @($Json | ConvertFrom-Json -AsHashtable)
    foreach ($entry in $entries) {
        if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('env')) {
            throw "Runtime slots JSON: every entry needs an env ($Json)"
        }
        # An entry with no slot is a base slot, built from its file; one with a slot is an ephemeral slot on that base.
        if ($entry.Contains('slot') -and -not [string]::IsNullOrEmpty("$($entry.slot)")) {
            "$($entry.env)-$($entry.slot)"
        }
    }
}
