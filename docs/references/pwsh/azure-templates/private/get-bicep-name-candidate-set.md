# pwsh/Azure.Templates/private/Get-BicepNameCandidateSet.ps1

The private function that gathers the known value of each name part, the candidate sets the name matcher renders.

## help

### synopsis

Returns the candidate sets of the name matcher: environments, slots, regions, the org, short names and customers.

### description

`env` maps each environment of `azure.yml` to its shortcode and `customer` each customer of `customer.yml` to its shortcode; `region` holds
the environments' region codes, `org` the one org, and `short_name` and `slot` the short name and the special slots of every template. The
result is the `-CandidateSet` of ConvertFrom-AzureResourceName
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)).
