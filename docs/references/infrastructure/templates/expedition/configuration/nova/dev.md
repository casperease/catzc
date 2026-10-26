# infrastructure/templates/expedition/configuration/nova/dev.yml

The expedition configuration for nova dev (customer `nova`, subscription `nova_nonprod`).

The workload sits in the nova nonprod spoke and registers in the nonprod hub's private DNS zones. It is the nonprod class: a serverless
database that pauses when idle.
