# pwsh/Azure/types/NetworkCidr.cs

The IPv4 CIDR arithmetic of the network plan, `configs/network.yml` ([ADR-AZ-NETWORK](../../../../drs/azure/azure-network-model.md)). It is
the one place a range is parsed, so the shape check, the subnet-inside-its-vnet check and the no-overlap check all read a range the same
way. `NetworkEnvironment`, `NetworkSubscription` and `NetworkConfig` call it while they validate.

## valid range

A valid range is an aligned IPv4 CIDR: a dotted-quad address, a prefix length from 0 to 32, and no host bits set. `10.10.0.0/16` is valid
and `10.10.0.1/16` is not, because Azure rejects an address prefix with host bits set.
