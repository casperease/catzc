---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md
    kind: reference
    body_sha: f5392dd5edca
    adrs:
      - ADR-AUTO-ENVVAR#7
      - ADR-CONF-ADDRESSING#3
      - ADR-CONF-ADDRESSING#4
      - ADR-CONF-ADDRESSING#5
      - ADR-CONF-LOADING#1
      - ADR-CONF-LOADING#2
---

# automation/Catzc.Base.Config/Get-ConfigValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A global config address is a by-reference handle into a named config: global.<config>.<key>[.<key>...]
(see ADR config-value-addressing, code addr). Get-ConfigValue strips the 'global.' marker, reads the named
config through Get-Config (the one reader and one cache,
[ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1)), and walks the
remaining key segments with
Resolve-ConfigKeyPath. It never opens a file or caches anything of its own — it is a view over what
Get-Config already loaded and validated.

The first segment after 'global.' is the config's global lowercase name
([ADR-CONF-LOADING#2](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading2)); the owner module is
discovered, not part of the address. The remaining segments (which may be empty, addressing the whole
config) are walked into the parsed config. An unknown/ambiguous name or an unresolvable key throws
([ADR-CONF-ADDRESSING#4](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing4)) — there is
no silent $null. The returned node may be a live reference into the config cache and
must be treated as read-only
([ADR-CONF-ADDRESSING#5](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing5)). Addresses
only ever reach version-controlled config, so nothing
addressable is a secret
([ADR-CONF-ADDRESSING#3](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing3)); secrets
travel out-of-band as [SecureString] (see ADR
environment-variables, [ADR-AUTO-ENVVAR#7](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar7)).
```

## comment:2

Section `.PARAMETER Address` of the comment-based help.

```text
The global config address: global.<config>.<key>[.<key>...] — e.g. 'global.myproperty.name'. The key path
is optional; 'global.<config>' addresses the whole config as a subtree.
```
