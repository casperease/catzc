# infrastructure/templates/foundation/main.bicep

The foundation template, the once-per-subscription baseline: a Log Analytics workspace and a Key Vault. It deploys once per subscription
(envs `nsub` and `psub`), in the shared subscription and in each customer's.

## What it holds

The Key Vault holds the shared secrets of that subscription, notably the SQL admin password that consuming templates reference. The
resources come from the reusable modules in `infrastructure/modules/`.
