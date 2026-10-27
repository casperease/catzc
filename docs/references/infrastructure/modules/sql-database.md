# infrastructure/modules/sql-database.bicep

The reusable module for a single SQL database on an existing logical server.

## Defaults

The module carries the Well-Architected defaults: zone redundancy wherever the tier supports it, geo-redundant backup storage, and a
short-term backup retention policy.

## Serverless

Serverless SKUs (`GP_S_Gen5`) take an auto-pause delay and a minimum capacity.

## Use

A template references it with a relative `module` declaration (`../../modules/sql-database.bicep`), and `bicep build` inlines it. The server
comes from `sql-server.bicep`.
