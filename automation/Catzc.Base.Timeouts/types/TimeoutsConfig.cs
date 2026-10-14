// The time safeguards (configs/timeouts.yml) — how long a call may run before it is stopped. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Timeouts.TimeoutsConfig), so Get-Config -Config timeouts
// returns this typed record; Get-TimeoutSeconds resolves a limit from it. Mirrors the YAML keys verbatim
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The Claude Code Bash
// hook (.claude/hooks/Assert-BashTimeout/) compiles this same file, so the hook and the pwsh side share one parser
// and one set of defaults.
//
// Limits are keyed on two axes: the environment (devbox | pipeline, from Get-RunEnvironment) and the shell (bash |
// pwsh). bash carries a foreground and a background limit (the hook bounds both); pwsh carries one limit for the
// work pwsh code bounds itself (Invoke-WithTimeout, Invoke-Executable). The sensible defaults are declared here,
// once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), so an empty file and a fresh checkout
// behave the same; the file states only what is
// tuned.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only known keys at every level ('limits', 'executables', 'commands'; devbox | pipeline; bash | pwsh; foreground |
//     background) — an unknown key (a typo) fails fast at load;
//   - every limit is a positive whole number (a YAML plain integer — a quoted '10' is rejected); there is no
//     "no limit" value, so every call runs inside a safeguard;
//   - a bash background limit is at least its foreground limit;
//   - 'executables' maps a bare executable name (no directory, no extension) to a positive whole number;
//   - 'commands' maps a function name (Verb-Noun) to a positive whole number — the config layer above a function's own
//     [TimeLimit] decoration (Get-TimeoutSeconds -Command);
//   - 'tests' holds the test-run time limits (Get-TestTimeLimits): 'level_ms' maps a test tier (TestTiers.Names, L0 to
//     L4) to the most milliseconds one test of that tier may take, and 'run_seconds' is the budget for a whole
//     Test-Automation run up to L3 (an L4 run is a stage of its own). Both are positive whole numbers, with defaults
//     declared here.

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Timeouts;

public sealed class TimeoutsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "limits", "executables", "commands", "tests" };
    private static readonly string[] TestKeys = { "level_ms", "run_seconds" };
    private static readonly string[] TestLevels = TestTiers.Names;

    // The sensible test-run defaults: an L0 logic test is milliseconds, an L1 integrity test a couple of seconds, an L2
    // test that drives a real tool tens of seconds, an L3 vertical system test up to two minutes, an L4 test of the
    // released system through its public edge (DNS, TLS, a cold start) up to ten; a whole run up to L3 fits in three
    // minutes.
    private static readonly Dictionary<string, int> TestLevelDefaults = new Dictionary<string, int>(StringComparer.Ordinal)
    {
        { "L0", 400 },
        { "L1", 2000 },
        { "L2", 30000 },
        { "L3", 120000 },
        { "L4", 600000 },
    };
    private const int TestRunDefaultSeconds = 180;
    private static readonly string[] Environments = { "devbox", "pipeline" };
    // The shells a limit is keyed by: the execution engines, declared once
    // ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
    private static readonly string[] Shells = new List<string>(Catzc.Base.Engines.ExecutionEngines.Names).ToArray();
    private static readonly string[] BashKeys = { "foreground", "background" };

    // The sensible defaults: tight on a devbox, where the blockers are tuned together; looser in a pipeline, where
    // nobody watches and a long build is ordinary — but still bounded.
    private static readonly Dictionary<string, int> Defaults = new Dictionary<string, int>(StringComparer.Ordinal)
    {
        { "devbox.bash.foreground", 3 },
        { "devbox.bash.background", 360 },
        { "devbox.pwsh", 3 },
        { "pipeline.bash.foreground", 600 },
        { "pipeline.bash.background", 3600 },
        { "pipeline.pwsh", 600 },
    };

    private readonly Dictionary<string, int> resolved = new Dictionary<string, int>(Defaults, StringComparer.Ordinal);

    // The resolved limits, defaults filled in: limits[devbox|pipeline][bash] is { foreground, background },
    // limits[devbox|pipeline][pwsh] is the pwsh limit. A read-only view for display; resolve through SecondsFor.
    public IDictionary limits { get; }

    // Per-executable limits in seconds, keyed by the bare executable name (case-insensitive). Empty when the file
    // declares none.
    public IReadOnlyDictionary<string, int> executables { get; }

    // Per-command limits in seconds, keyed by the function name (case-insensitive). Empty when the file declares none.
    public IReadOnlyDictionary<string, int> commands { get; }

    // The resolved test-run limits, defaults filled in: tests[level_ms][L0..L4] in milliseconds, tests[run_seconds].
    public IDictionary tests { get; }

    private readonly Dictionary<string, int> testLevelMs = new Dictionary<string, int>(TestLevelDefaults, StringComparer.Ordinal);
    private int testRunSeconds = TestRunDefaultSeconds;

    public TimeoutsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        CheckKeys(d, AllowedKeys, "", errors);

        if (d != null && d.Contains("limits") && d["limits"] != null)
        {
            IDictionary byEnvironment = d["limits"] as IDictionary;
            if (byEnvironment == null)
            {
                errors.Add("invalid limits (must be a map of devbox | pipeline)");
            }
            else
            {
                CheckKeys(byEnvironment, Environments, "limits.", errors);
                foreach (string environment in Environments)
                {
                    ReadEnvironment(byEnvironment, environment, errors);
                }
            }
        }

        foreach (string environment in Environments)
        {
            int foreground = resolved[environment + ".bash.foreground"];
            int background = resolved[environment + ".bash.background"];
            if (background < foreground)
            {
                errors.Add(string.Format(
                    "invalid limits.{0}.bash: background ({1}) is below foreground ({2})", environment, background, foreground));
            }
        }

        Dictionary<string, int> perExecutable = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        if (d != null && d.Contains("executables") && d["executables"] != null)
        {
            IDictionary map = d["executables"] as IDictionary;
            if (map == null)
            {
                errors.Add("invalid executables (must be a map of executable name to seconds)");
            }
            else
            {
                foreach (DictionaryEntry entry in map)
                {
                    string name = entry.Key == null ? "" : entry.Key.ToString();
                    if (name.Length == 0 || name.IndexOfAny(new[] { '/', '\\', '.' }) >= 0)
                    {
                        errors.Add(string.Format("invalid executables key '{0}' (a bare executable name: no directory, no extension)", name));
                        continue;
                    }
                    int? seconds = PositiveSeconds(entry.Value);
                    if (seconds == null)
                    {
                        errors.Add(string.Format("invalid executables.{0} '{1}' (must be a positive whole number)", name, entry.Value));
                        continue;
                    }
                    perExecutable[name] = seconds.Value;
                }
            }
        }
        executables = perExecutable;

        Dictionary<string, int> perCommand = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        if (d != null && d.Contains("commands") && d["commands"] != null)
        {
            IDictionary map = d["commands"] as IDictionary;
            if (map == null)
            {
                errors.Add("invalid commands (must be a map of function name to seconds)");
            }
            else
            {
                foreach (DictionaryEntry entry in map)
                {
                    string name = entry.Key == null ? "" : entry.Key.ToString();
                    if (name.IndexOf('-') <= 0 || name.IndexOfAny(new[] { '/', '\\', '.', ' ' }) >= 0)
                    {
                        errors.Add(string.Format("invalid commands key '{0}' (a function name: Verb-Noun)", name));
                        continue;
                    }
                    int? seconds = PositiveSeconds(entry.Value);
                    if (seconds == null)
                    {
                        errors.Add(string.Format("invalid commands.{0} '{1}' (must be a positive whole number)", name, entry.Value));
                        continue;
                    }
                    perCommand[name] = seconds.Value;
                }
            }
        }
        commands = perCommand;

        if (d != null && d.Contains("tests") && d["tests"] != null)
        {
            ReadTests(d["tests"], errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("timeouts configuration validation failed:\n" + string.Join("\n", errors));
        }

        Hashtable view = new Hashtable(StringComparer.OrdinalIgnoreCase);
        foreach (string environment in Environments)
        {
            Hashtable bash = new Hashtable(StringComparer.OrdinalIgnoreCase)
            {
                { "foreground", resolved[environment + ".bash.foreground"] },
                { "background", resolved[environment + ".bash.background"] },
            };
            view[environment] = new Hashtable(StringComparer.OrdinalIgnoreCase)
            {
                { "bash", bash },
                { "pwsh", resolved[environment + ".pwsh"] },
            };
        }
        limits = view;

        tests = new Hashtable(StringComparer.OrdinalIgnoreCase)
        {
            { "level_ms", TestLevelLimitsMs() },
            { "run_seconds", testRunSeconds },
        };
    }

    // The most milliseconds one test may take, per tier (L0..L4) — a fresh copy, so a caller cannot change the config.
    public Hashtable TestLevelLimitsMs()
    {
        Hashtable copy = new Hashtable(StringComparer.OrdinalIgnoreCase);
        foreach (KeyValuePair<string, int> entry in testLevelMs) { copy[entry.Key] = entry.Value; }
        return copy;
    }

    // The budget, in seconds, for a whole Test-Automation run up to L3.
    public int TestRunSeconds()
    {
        return testRunSeconds;
    }

    private void ReadTests(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid tests (must be a map of level_ms, run_seconds)");
            return;
        }
        CheckKeys(map, TestKeys, "tests.", errors);

        if (map.Contains("level_ms") && map["level_ms"] != null)
        {
            IDictionary levels = map["level_ms"] as IDictionary;
            if (levels == null)
            {
                errors.Add("invalid tests.level_ms (must be a map of " + string.Join(" | ", TestLevels) + " to milliseconds)");
            }
            else
            {
                CheckKeys(levels, TestLevels, "tests.level_ms.", errors);
                foreach (string level in TestLevels)
                {
                    if (!levels.Contains(level) || levels[level] == null) { continue; }
                    int? ms = PositiveSeconds(levels[level]);
                    if (ms == null)
                    {
                        errors.Add(string.Format("invalid tests.level_ms.{0} '{1}' (must be a positive whole number of milliseconds)", level, levels[level]));
                        continue;
                    }
                    testLevelMs[level] = ms.Value;
                }
            }
        }

        if (map.Contains("run_seconds") && map["run_seconds"] != null)
        {
            int? seconds = PositiveSeconds(map["run_seconds"]);
            if (seconds == null)
            {
                errors.Add(string.Format("invalid tests.run_seconds '{0}' (must be a positive whole number)", map["run_seconds"]));
            }
            else { testRunSeconds = seconds.Value; }
        }
    }

    // The limit for a shell call in an environment. environment is devbox | pipeline and shell is bash | pwsh
    // (case-insensitive); background applies to bash only.
    public int SecondsFor(string environment, string shell, bool background)
    {
        string env = Axis(environment, Environments, "environment");
        string sh = Axis(shell, Shells, "shell");
        if (sh == "pwsh")
        {
            if (background)
            {
                throw new ArgumentException("pwsh has no background limit; background applies to bash calls only");
            }
            return resolved[env + ".pwsh"];
        }
        return resolved[env + ".bash." + (background ? "background" : "foreground")];
    }

    // The limit for an executable that pwsh code runs: its own entry when it has one, otherwise the environment's
    // pwsh limit. The name may carry a directory and an extension (`C:\tools\dotnet.exe`); only the bare name is
    // looked up.
    public int SecondsForExecutable(string environment, string executable)
    {
        string name = string.IsNullOrWhiteSpace(executable) ? "" : Path.GetFileNameWithoutExtension(executable.Trim());
        int seconds;
        return name.Length > 0 && executables.TryGetValue(name, out seconds) ? seconds : SecondsFor(environment, "pwsh", false);
    }

    // The configured limit for a command, or null when timeouts.yml has no entry for it.
    public int? SecondsForCommand(string command)
    {
        int seconds;
        return !string.IsNullOrWhiteSpace(command) && commands.TryGetValue(command.Trim(), out seconds) ? seconds : (int?)null;
    }

    private void ReadEnvironment(IDictionary byEnvironment, string environment, List<string> errors)
    {
        if (!byEnvironment.Contains(environment) || byEnvironment[environment] == null)
        {
            return;
        }
        string path = "limits." + environment;
        IDictionary byShell = byEnvironment[environment] as IDictionary;
        if (byShell == null)
        {
            errors.Add(string.Format("invalid {0} (must be a map of bash | pwsh)", path));
            return;
        }
        CheckKeys(byShell, Shells, path + ".", errors);

        if (byShell.Contains("pwsh") && byShell["pwsh"] != null)
        {
            ReadSeconds(byShell["pwsh"], environment + ".pwsh", path + ".pwsh", errors);
        }
        if (byShell.Contains("bash") && byShell["bash"] != null)
        {
            IDictionary bash = byShell["bash"] as IDictionary;
            if (bash == null)
            {
                errors.Add(string.Format("invalid {0}.bash (must be a map of foreground | background)", path));
                return;
            }
            CheckKeys(bash, BashKeys, path + ".bash.", errors);
            foreach (string key in BashKeys)
            {
                if (bash.Contains(key) && bash[key] != null)
                {
                    ReadSeconds(bash[key], environment + ".bash." + key, path + ".bash." + key, errors);
                }
            }
        }
    }

    private void ReadSeconds(object value, string slot, string path, List<string> errors)
    {
        int? seconds = PositiveSeconds(value);
        if (seconds == null)
        {
            errors.Add(string.Format("invalid {0} '{1}' (must be a positive whole number)", path, value));
            return;
        }
        resolved[slot] = seconds.Value;
    }

    private static void CheckKeys(IDictionary d, string[] allowed, string prefix, List<string> errors)
    {
        if (d == null)
        {
            return;
        }
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}{1}' (allowed: {2})", prefix, key, string.Join(", ", allowed)));
            }
        }
    }

    private static string Axis(string value, string[] allowed, string axis)
    {
        string normalized = value == null ? "" : value.Trim().ToLowerInvariant();
        if (Array.IndexOf(allowed, normalized) < 0)
        {
            throw new ArgumentException(string.Format("unknown {0} '{1}' (allowed: {2})", axis, value, string.Join(", ", allowed)));
        }
        return normalized;
    }

    private static int? PositiveSeconds(object value)
    {
        if (value is int || value is long || value is short || value is byte)
        {
            long seconds = Convert.ToInt64(value);
            return seconds > 0 && seconds <= int.MaxValue ? (int)seconds : (int?)null;
        }

        return null;
    }
}
