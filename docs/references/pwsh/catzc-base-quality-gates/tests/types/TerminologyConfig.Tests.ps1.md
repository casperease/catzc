# pwsh/Base.QualityGates/tests/types/TerminologyConfig.Tests.ps1

The test of the compiled `TerminologyConfig` and `TerminologyTerm` types, called directly. The constructor is the gate that stops an
unjustified or malformed registry entry from ever producing an instance
([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)). The
`categories` map is the single source of the allowed categories, and `terms` groups entries under those category keys, so a term's category
is the group it is listed under, with no per-entry category field.
