# infrastructure/templates/expedition/configuration/apex/prod.yml

The expedition configuration for apex prod (customer `apex`, subscription `apex_prod`).

The workload sits in the apex prod spoke and registers in the prod hub's private DNS zones. It is the production class: a provisioned
database with geo backups, zone-redundant by the template default.
