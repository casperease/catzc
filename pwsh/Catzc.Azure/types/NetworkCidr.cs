/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure/types/NetworkCidr.cs.md"
  warning: "Generated Header"
---
*/

using System;
using System.Net;
using System.Net.Sockets;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public static class NetworkCidr
{
    private const string Shape = @"^\d{1,3}(\.\d{1,3}){3}/\d{1,2}$";

    // True when the value is an aligned IPv4 CIDR.
    public static bool IsValid(string value)
    {
        uint network;
        int prefix;
        return TryParse(value, out network, out prefix);
    }

    // Parses an aligned IPv4 CIDR into its network address and prefix length; false when the value is not one.
    public static bool TryParse(string value, out uint network, out int prefix)
    {
        network = 0;
        prefix = 0;
        if (value == null || !Regex.IsMatch(value, Shape)) { return false; }
        string[] parts = value.Split('/');
        IPAddress ip;
        if (!IPAddress.TryParse(parts[0], out ip) || ip.AddressFamily != AddressFamily.InterNetwork) { return false; }
        if (!int.TryParse(parts[1], out prefix) || prefix > 32) { return false; }
        byte[] b = ip.GetAddressBytes();
        uint address = ((uint)b[0] << 24) | ((uint)b[1] << 16) | ((uint)b[2] << 8) | b[3];
        network = address & Mask(prefix);
        return network == address;
    }

    // True when the inner range lies wholly inside the outer range; false when either is not a valid range.
    public static bool Contains(string outer, string inner)
    {
        uint outerNetwork, innerNetwork;
        int outerPrefix, innerPrefix;
        if (!TryParse(outer, out outerNetwork, out outerPrefix) || !TryParse(inner, out innerNetwork, out innerPrefix)) { return false; }
        return innerPrefix >= outerPrefix && (innerNetwork & Mask(outerPrefix)) == outerNetwork;
    }

    // True when the two ranges share at least one address; false when either is not a valid range.
    public static bool Overlaps(string a, string b)
    {
        uint aNetwork, bNetwork;
        int aPrefix, bPrefix;
        if (!TryParse(a, out aNetwork, out aPrefix) || !TryParse(b, out bNetwork, out bPrefix)) { return false; }
        uint mask = Mask(Math.Min(aPrefix, bPrefix));
        return (aNetwork & mask) == (bNetwork & mask);
    }

    // The network mask of a prefix length (a shift by 32 is a no-op in C#, so /0 is its own case).
    private static uint Mask(int prefix) => prefix == 0 ? 0u : uint.MaxValue << (32 - prefix);
}
