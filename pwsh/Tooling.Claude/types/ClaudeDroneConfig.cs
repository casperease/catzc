using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Tooling.Claude;

public sealed class ClaudeDroneConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultLauncher = "windows-terminal";

    public static IReadOnlyList<string> Launchers { get; } = Array.AsReadOnly(new[] { "windows-terminal", "pwsh" });

    private static readonly string[] AllowedKeys = { "launcher" };

    // The terminal a drone session opens in: windows-terminal (wt.exe new-tab) or pwsh (a pwsh -NoExit window).
    public string launcher { get; }

    public ClaudeDroneConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string launcherValue = DefaultLauncher;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("launcher") && raw["launcher"] != null)
            {
                string candidate = raw["launcher"] as string;
                if (candidate == null || !Launchers.Contains(candidate))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "launcher '{0}' must be one of: {1}", raw["launcher"], string.Join(", ", Launchers)));
                }
                else
                {
                    launcherValue = candidate;
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("claude-drone configuration validation failed:\n" + string.Join("\n", errors));
        }

        launcher = launcherValue;
    }
}
