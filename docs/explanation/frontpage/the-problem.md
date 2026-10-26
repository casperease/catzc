# The problem

Delivery is slow mainly because of a distributed-systems problem, not because building or deploying is hard. The truth about a system is
spread across stores that were never designed to agree: servers, CMDBs, deployment engines, ticket systems, requirement databases. Each
holds part of reality, and they drift. Teams spend their effort rebuilding a picture of the whole — and every synchronisation path between
stores is one more way to drift.

cats does not manage that distributed system better. **It removes it.**

[Read the problem statement →](../../drs/thesis/one-source-of-truth.md#the-problem)
