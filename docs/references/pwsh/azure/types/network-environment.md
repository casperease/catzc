# pwsh/Azure/types/NetworkEnvironment.cs

One environment's IP plan in `configs/network.yml` ([ADR-AZ-NETWORK](../../../../drs/azure/azure-network-model.md)): the vnet address space
and the default subnet, keyed by the `azure.yml` environment name. It mirrors an `environments` entry with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`NetworkConfig` builds one per entry and collects its violations with the file's.

## shape

- The name is a lower-snake_case identifier.
- `vnet_address_space` and `default_subnet` are required, aligned IPv4 CIDRs (`NetworkCidr`).
- The default subnet lies inside the vnet address space.
- No other key is allowed.
