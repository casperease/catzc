---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-OE-OE09
      - ADR-AZ-CAF-DEVOPS-UNITTESTINFRASTRUCTURECODEASWELL
---

# Infrastructure is tested in tiers and every template is built and checked in the ci (ADR-AZ-WAF-OE-OE09 + ADR-AZ-CAF-DEVOPS-UNITTESTINFRASTRUCTURECODEASWELL)

This article is one rule: [ADR-AZ-WAF-OE-OE09](../../drs/azure/waf/operational-excellence.md#rule-adr-az-waf-oe-oe09) and
[ADR-AZ-CAF-DEVOPS-UNITTESTINFRASTRUCTURECODEASWELL](../../drs/azure/caf/platform-automation-and-devops.md#rule-adr-az-caf-devops-unittestinfrastructurecodeaswell)
merged into one. It holds nothing beyond what those two rules say.

Infrastructure is tested in tiers by `Test-Automation`: the CI engine builds every template and checks its parameters files against the
compiled parameter model, and a deployed template is verified by a system test. This is partly realised: every template is validated,
compiled and checked against its parameter model in the build, while the Bicep linter as a quality gate and system tests of a deployed
template are planned.
