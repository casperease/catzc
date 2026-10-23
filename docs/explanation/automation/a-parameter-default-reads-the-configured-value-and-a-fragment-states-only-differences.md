---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PARAM-RESOLUTIONORDER
      - ADR-AUTO-OVERLAY-CONFIGFRAGMENT
---

# A parameter default reads the configured value and a fragment states only differences

This article is one rule:
[ADR-PWSH-PARAM-RESOLUTIONORDER](../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder) and
[ADR-AUTO-OVERLAY-CONFIGFRAGMENT](../../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-configfragment) merged into one. It holds
nothing beyond what those two rules say.

The resolution order of a setting is, in PowerShell, one parameter declaration: the default expression reads the configured value,
`[LinkWrap] $Wrap = (Get-Config -Config links).wrap`, which PowerShell evaluates only when the caller omits the parameter. A config fragment
states only the keys that differ and is merged onto the bundled config before the config's own type validates the result.
