# pwsh/Base.Drs/types/DrsCodeForm.cs

The code grammar over the registered record kinds (ADR-REPO-DRSCODE), and the shortest form of a derived list of codes.

## The grammar

```text
ADR-<DOMAIN>-<ADR>-<NAME>   one rule, under a shared kind
ADR-<DOMAIN>-<ADR>          the whole ADR, every rule of it
ADR-<DOMAIN>                every ADR of the domain
TDR-<ADR>-<NAME>            one rule, under a kind one domain owns
TDR-<ADR>                   the whole ADR
```

A code is a kind and a path of upper-case segments, and a prefix selects everything below it. There is no number, group or range. The kinds
come from `drs.yml` (`DrsConfig.CodeForm`). `AnyKind` reads any kind of the shape `AnyKindShape`, for a config read without the registry,
whose codes the registry gates check.

## Minimize

`Minimize` returns a derived list at its shortest. A code another listed code covers goes, and a set of rules that is every rule of its ADR,
as the registry declares them, becomes the ADR's code. Without a registry nothing collapses, and the list is ordinal. With one it is in
authored order.
