# infrastructure/modules/firewall-policy.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `resource policy 'Microsoft.Network/firewallPolicies@2024-05-01' = {`, written with `//`.

```text
One rule set for both tiers: no rule uses the DNS proxy Standard alone runs. Threat intelligence is the only difference: Basic can only
alert, Standard denies.
```
