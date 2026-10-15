<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepParameterEntryViolations.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns the violations of one parameters-file entry against its declaration in the template's compiled
    main.json.
.DESCRIPTION
    A reference is checked for shape alone, whatever the declared type, since it resolves only at deploy time.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepParameterEntryViolations.ps1.md#comment1)
.PARAMETER Parameter
    The parameter's declaration, from Get-BicepParameterModel.
.PARAMETER Entry
    The parameters-file entry for that parameter.
.OUTPUTS
    [string[]] the violations; empty when the entry conforms.
#>
function Get-BicepParameterEntryViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)] [Catzc.Azure.Templates.BicepParameter] $Parameter,
        [Parameter(Mandatory)] [System.Text.Json.JsonElement] $Entry
    )

    if ($Entry.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
        return "is not an object holding a 'value' or a 'reference'"
    }

    $value = [System.Text.Json.JsonElement]::new()
    $reference = [System.Text.Json.JsonElement]::new()
    $hasValue = $Entry.TryGetProperty('value', [ref] $value)
    $hasReference = $Entry.TryGetProperty('reference', [ref] $reference)
    if ($hasValue -and $hasReference) {
        return "sets both a 'value' and a 'reference'"
    }
    if (-not ($hasValue -or $hasReference)) {
        return "sets neither a 'value' nor a 'reference'"
    }

    if ($hasReference) {
        return Get-BicepKeyVaultReferenceViolations -Reference $reference
    }

    # A literal here is a secret in the repository, so the message never echoes the value.
    # [comment:2](/docs/references/automation/catzc-azure-templates/private/Get-BicepParameterEntryViolations.ps1.md#comment2)
    if ($Parameter.IsSecure) {
        return "is a $($Parameter.Type) parameter set to a literal value — it takes only a Key Vault reference"
    }

    $kind = $value.ValueKind
    if ($kind -eq [System.Text.Json.JsonValueKind]::Null) {
        if ($Parameter.Nullable) {
            return
        }
        return "is null, but main.json declares it $($Parameter.Type) and not nullable"
    }

    $isInteger = $false
    if ($kind -eq [System.Text.Json.JsonValueKind]::Number) {
        $integer = [long] 0
        $isInteger = $value.TryGetInt64([ref] $integer)
    }
    $matchesType = switch ($Parameter.Type) {
        'string' {
            $kind -eq [System.Text.Json.JsonValueKind]::String
        }
        'int' {
            $isInteger
        }
        'bool' {
            $kind -in [System.Text.Json.JsonValueKind]::True, [System.Text.Json.JsonValueKind]::False
        }
        'object' {
            $kind -eq [System.Text.Json.JsonValueKind]::Object
        }
        'array' {
            $kind -eq [System.Text.Json.JsonValueKind]::Array
        }
    }
    if (-not $matchesType) {
        $actual = if ($isInteger) {
            'an integer'
        }
        elseif ($kind -eq [System.Text.Json.JsonValueKind]::Number) {
            'a non-integer number'
        }
        elseif ($kind -in [System.Text.Json.JsonValueKind]::True, [System.Text.Json.JsonValueKind]::False) {
            'a boolean'
        }
        else {
            "a JSON $("$kind".ToLowerInvariant())"
        }
        return "is $actual, but main.json declares it $($Parameter.Type)"
    }

    $violations = [System.Collections.Generic.List[string]]::new()

    if ($Parameter.AllowedValues.Count -gt 0) {
        $candidates = if ($kind -eq [System.Text.Json.JsonValueKind]::Array) {
            @($value.EnumerateArray())
        }
        else {
            @($value)
        }
        foreach ($candidate in $candidates) {
            $comparable = [Catzc.Azure.Templates.BicepParameter]::ToComparable($candidate)
            $isAllowed = $false
            foreach ($allowedValue in $Parameter.AllowedValues) {
                if ($comparable -is [string] -and $allowedValue -is [string]) {
                    $isAllowed = [string]::Equals($comparable, $allowedValue, [System.StringComparison]::OrdinalIgnoreCase)
                }
                elseif ($null -eq $comparable -or $null -eq $allowedValue) {
                    $isAllowed = $null -eq $comparable -and $null -eq $allowedValue
                }
                else {
                    $isAllowed = $comparable.GetType() -eq $allowedValue.GetType() -and $comparable -eq $allowedValue
                }
                if ($isAllowed) {
                    break
                }
            }
            if (-not $isAllowed) {
                $verb = if ($kind -eq [System.Text.Json.JsonValueKind]::Array) {
                    'contains'
                }
                else {
                    'is'
                }
                $violations.Add("$verb $($candidate.GetRawText()), which is not one of the @allowed values ($(@($Parameter.AllowedValues | ForEach-Object { if ($null -eq $_) { 'null' } else { "$_" } }) -join ', '))")
            }
        }
    }

    if ($isInteger) {
        if ($null -ne $Parameter.MinValue -and $integer -lt $Parameter.MinValue) {
            $violations.Add("is $integer, below @minValue $($Parameter.MinValue)")
        }
        if ($null -ne $Parameter.MaxValue -and $integer -gt $Parameter.MaxValue) {
            $violations.Add("is $integer, above @maxValue $($Parameter.MaxValue)")
        }
    }

    $length = $null
    if ($kind -eq [System.Text.Json.JsonValueKind]::String) {
        $length = $value.GetString().Length
    }
    elseif ($kind -eq [System.Text.Json.JsonValueKind]::Array) {
        $length = $value.GetArrayLength()
    }
    if ($null -ne $length) {
        if ($null -ne $Parameter.MinLength -and $length -lt $Parameter.MinLength) {
            $violations.Add("has length $length, below @minLength $($Parameter.MinLength)")
        }
        if ($null -ne $Parameter.MaxLength -and $length -gt $Parameter.MaxLength) {
            $violations.Add("has length $length, above @maxLength $($Parameter.MaxLength)")
        }
    }

    $violations
}
