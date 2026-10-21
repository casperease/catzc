<#
---
catzc:
  immutable:
    with_body_sha: be7bbb36f9e7
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureResourceTypeSet.Tests.ps1
    docs: "[Get-AzureResourceTypeSet.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md)"
    cites:
      - ADR-AZ-NAMING
---
#>

function Get-AzureResourceTypeSet {
    param()

    [ordered]@{
        rg    = @{ pattern = 'long'; limit = 90 }   # resource group
        st    = @{ pattern = 'storage' }               # storage account (tight, no hyphens, 24)
        kv    = @{ pattern = 'kv' }                    # key vault — hyphenated but length-restricted to 24
        waf   = @{ pattern = 'long'; limit = 128 }  # web application firewall policy
        vnet  = @{ pattern = 'long'; limit = 64 }   # virtual network
        sql   = @{ pattern = 'long'; limit = 63 }   # SQL logical server (lowercase, hyphens ok)
        sqldb = @{ pattern = 'long'; limit = 128 }  # SQL database (5-char type ok — long pattern)
        vm    = @{ pattern = 'vm'; omit = @('org', 'customer', 'role') }  # virtual machine (15; omits RG-encoded segments to fit)
        synw  = @{ pattern = 'long'; limit = 50 }   # Synapse Analytics workspace
        adf   = @{ pattern = 'long'; limit = 63 }   # Data Factory (V2) — 3-63 chars
        log   = @{ pattern = 'long'; limit = 63 }   # Log Analytics workspace (4-63)
        nic   = @{ pattern = 'long'; limit = 80 }   # network interface
        pip   = @{ pattern = 'long'; limit = 80 }   # public IP address
        nsg   = @{ pattern = 'long'; limit = 80 }   # network security group — 1-80, unique in the resource group
        snet  = @{ pattern = 'long'; limit = 80 }   # subnet — 1-80, unique in the virtual network
        rt    = @{ pattern = 'long'; limit = 80 }   # route table — 1-80, unique in the resource group
        peer  = @{ pattern = 'long'; limit = 80 }   # virtual network peering — 1-80, unique in the virtual network
        pep   = @{ pattern = 'long'; limit = 64 }   # private endpoint — 2-64, unique in the resource group
        budg  = @{ pattern = 'long'; limit = 63 }   # budget — 1-63 (letters, digits, _ and -), unique in the subscription
        pa    = @{ pattern = 'long'; limit = 64 }   # policy assignment — 1-64 at the subscription, unique there
    }
}
