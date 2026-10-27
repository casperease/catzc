# Get started

## Choose how you adopt cats

| Pin the bundle                                                                                  | Own a clone                                                          |
| ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Your trunk installs a released bundle and pins its version. You get the platform; we evolve it. | You change cats itself, in a trunk of your own with its own history. |
| `Export-Catzc -Root <your-repo>` places it under `.vendor/Catzc/<version>/`                     | Clone this repository and work at HEAD                               |

There is no third way: consuming cats implicitly across a repository boundary carries the coupling of one trunk without its atomic commits
([pin the bundle, or own a clone](../../drs/thesis/one-source-of-truth.md#pin-the-bundle-or-own-a-clone)).

## Four steps to your first delivery

[![1 Import][s1]](#1-import) [![2 Ask][s2]](#2-ask-cats) [![3 Add][s3]](#3-add-a-deployable-unit)
[![4 Ship][s4]](#4-ship-through-the-pipeline)

[s1]: https://img.shields.io/badge/1-Import-22c55e?style=for-the-badge
[s2]: https://img.shields.io/badge/2-Ask_cats-3b82f6?style=for-the-badge
[s3]: https://img.shields.io/badge/3-Add-8b5cf6?style=for-the-badge
[s4]: https://img.shields.io/badge/4-Ship-f97316?style=for-the-badge

### 1. Import

One line, about half a second, no install step, no network:

```powershell
. ./importer.ps1
```

### 2. Ask cats

The repository answers questions about the system it delivers — no CMDB, no portal:

```powershell
Get-AzureCustomers                                # every customer the repository delivers to
Get-AzureEnvironment <environment> <subscription> # one environment, resolved from config
```

### 3. Add a deployable unit

Declare what you deliver and the files that trigger it; drop in a template, and its pipeline follows:
[add a deployable unit](../../how-to/getting-started/automation/add-a-deployable-unit.md) ·
[add an infrastructure template](../../how-to/getting-started/automation/add-an-infrastructure-template.md).

### 4. Ship through the pipeline

Commit. The pipeline runs the same commands you ran on your devbox ([runner pattern](../../drs/ado/pipeline-runner-pattern.md)), and the
commit climbs its lifecycle to production ([commit lifecycle](../../drs/flow/commit-lifecycle.md)).

[**Full getting-started guide →**](../../how-to/getting-started/automation/index.md) ·
[FAQ →](../../how-to/getting-started/automation/faq.md)
