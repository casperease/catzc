# The `terminology` key of an ADR rule set: what it said, and where it lives now

## What the key said

Each rule set in the ADR registry (`pwsh/Catzc.Base.Docs/configs/adrs.yml`) could name a spelling token:

```yaml
one-living-version: { external: ADR-PRIN-ONELIVE, terminology: onelive, concern: [release] }
```

The token was the body of the rule set's code, lower-cased (`onelive` for `ADR-PRIN-ONELIVE`), and the same word was registered by hand in
the terminology registry (`pwsh/Catzc.Base.QualityGates/configs/terminology.yml`) as a term whose meaning read "body of the ADR-… code".
The spell checker then accepted the code body as a word. `AdrsConfig` read the key into `AdrRuleSet.Terminology`, and nothing else read it.

## Why it goes

An ADR code is a path of named segments ([adr-code-language](../adr/repository/adr-code-language.md)), and every rule gets a named segment
of its own. Registering each segment by hand would mean one terminology entry per rule, more than sixteen hundred of them, each a copy of a
fact the registry already holds. The decision recorded in `.claude/plans/plan-adr-code-language.md` (open question 1, decided 2026-10-18)
is that the spell checker takes the segments from the registry itself.

## Where it lives now

`Build-AdrCodeDictionary` (in `Catzc.Base.Docs`) writes `.cspell/adr-codes.txt`: every segment of every registered ADR code and rule
heading, lower-cased, from `adrs.yml` and the ADR files. The root `cspell.yml` lists it beside the terminology dictionaries, and
`Test-GeneratedFiles` keeps it current. The hand-written code-body terms left `terminology.yml` in the same change. The ADR code language
ADR (`ADR-REPO-ADRCODE`) absorbs this page when its rules are restated after the migration.
