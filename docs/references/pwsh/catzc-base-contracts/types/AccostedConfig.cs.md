# pwsh/Base.Contracts/types/AccostedConfig.cs

The accosted language's settings ([ADR-AUTO-ACCOSTED](../../../../drs/automation/accosted-language.md)): which verbs are harmless, and the
`timeouts.yml` key that bounds one run. The sensible defaults are declared once on the type (`DefaultHarmlessVerbs`, `DefaultRunTimeout`).
