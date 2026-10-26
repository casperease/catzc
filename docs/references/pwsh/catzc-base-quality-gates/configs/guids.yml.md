# pwsh/Base.QualityGates/configs/guids.yml

The managed-GUID registry: the single authored source of every GUID literal the repository carries. Test-ManagedGuids and
Get-RepositoryGuids check the tracked text against it.

## Rule

Every GUID found in tracked text (code, configs, fixtures, pipelines, docs) must be registered here. The integrity quality gate enforces both
directions: an unregistered GUID fails the tests, and so does a dead entry that no tracked file references.

## Entries

The file is loaded with `Get-Config -Config guids`, and the GuidsConfig type maps and validates it. An entry is
`<snake_case_name>: { guid, description [, sentence] }`. There are two classes. An external-facing GUID is registered as it is, because the
outside world fixes its value. A placeholder GUID is minted with ConvertTo-Guid, so the value spells its `sentence`.

## Denied

`denied:` is the non-allow list: values that are never a legitimate identity. A denied GUID can never be registered under `guids:`, since
GuidsConfig rejects the overlap, and it must never appear in tracked text. The integrity quality gate names it as denied, not merely unregistered.
