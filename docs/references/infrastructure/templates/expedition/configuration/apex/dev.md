# infrastructure/templates/expedition/configuration/apex/dev.yml

The expedition configuration for apex dev (customer `apex`, subscription `apex_nonprod`).

The workload sits in the apex nonprod spoke and registers in the nonprod hub's private DNS zones. It is the nonprod class: a serverless
database that pauses when idle.
