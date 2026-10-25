# Session learnings d2a5f2

Started 2026-10-25T23:52:39.8581500+01:00.

- 2026-10-25 Cats: In hindsight I wish I knew this fact: a config may be a folder of disjoint parts, configs/\<name>/*.yml, merged by
  Get-Config; every gate that walks configs/ must accept it.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: under manifest-glob addressing one contract asset yields one record per Target, so
  a contract test matches on AssetPath and Target.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a case-only rename on disk leaves the git index in the old case, and the
  normal-name round-trip test reads the index.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: ConvertTo-Guid and SentenceGuid live in Catzc.Base.Objects, so any module may mint
  a sentence GUID without a dependency cycle.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: reading a run's results-shard-*.xml failure messages in one python pass instead of
  guessing from the pasted tail.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: re-running a snapshot-only failure in a small -Isolated -Modules slice before
  chasing its cause.
