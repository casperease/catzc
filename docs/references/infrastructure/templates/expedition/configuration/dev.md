# infrastructure/templates/expedition/configuration/dev.yml

The expedition configuration for shared dev (configuration root, subscription `shared_nonprod`).

The workload sits in the nonprod hub's shared-services subnet and registers in the same hub's private DNS zones. It is the nonprod class: a
serverless database that pauses when idle.
