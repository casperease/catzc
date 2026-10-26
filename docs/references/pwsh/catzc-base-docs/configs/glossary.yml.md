# pwsh/Base.Docs/configs/glossary.yml

The glossary source of `Catzc.Base.Docs`: the repository-wide vocabulary this module owns, the words for the ADRs themselves
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)). The source is split by ADR domain into the files of
`configs/glossary/`. Every option is defaulted: all checks, the whole repository and every text surface
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). It is read by
`Get-Glossary` and checked by `Test-Glossary`.

## Forms

A concept's `forms` lists the words allowed to qualify its head word. The `language zone` concept lists `language`, `design`, `test` and `live`; `landing`, `dns`
and `availability` are Azure's own terms (a CAF landing zone, a private DNS zone, an availability zone), not language zones.
