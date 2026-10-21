/*
---
catzc:
  immutable:
    with_body_sha: "63ff5b91a399"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
    docs: "[TimeoutsConfig.cs.md](docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-ENGINE-THREEENGINES
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Timeouts;

public sealed class TimeoutsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "limits", "executables", "commands", "tests", "wait" };
    private static readonly string[] TestKeys = { "level_ms", "run_seconds", "engine_start_seconds", "run_list_seconds" };

    // The default Watch-Blocking: one second and one millisecond, one pair for every environment.
    private static readonly string[] WaitKeys = { "seconds", "milliseconds" };
    public const int WaitDefaultSeconds = 1;
    public const int WaitDefaultMilliseconds = 1;
    private static readonly string[] TestLevels = TestTiers.Names;

    private static readonly Dictionary<string, int> TestLevelDefaults = new Dictionary<string, int>(StringComparer.Ordinal)
    {
        { "L0", 400 },
        { "L1", 2000 },
        { "L2", 30000 },
        { "L3", 120000 },
        { "L4", 600000 },
    };
    private const int TestRunDefaultSeconds = 180;
    // One engine start of a black-box test: the import plus one command, so two starts and a margin fit under the pwsh limit.
    private const int EngineStartDefaultSeconds = 150;
    // One run of a run list under one engine: an engine start and its few commands, under the pwsh limit.
    private const int RunListDefaultSeconds = 300;
    private static readonly string[] Environments = { "devbox", "pipeline" };
    private static readonly string[] Shells = new List<string>(Catzc.Base.Engines.ExecutionEngines.Names).ToArray();
    private static readonly string[] BashKeys = { "foreground", "background" };
    // The shell whose limits the Bash hook enforces, a foreground and a background limit; every other shell has one.
    private const string HookShell = "bash";

    private static readonly Dictionary<string, int> Defaults = new Dictionary<string, int>(StringComparer.Ordinal)
    {
        { "devbox.bash.foreground", 3 },
        { "devbox.bash.background", 360 },
        { "devbox.pwsh", 3 },
        { "devbox.zsh", 3 },
        { "pipeline.bash.foreground", 600 },
        { "pipeline.bash.background", 3600 },
        { "pipeline.pwsh", 600 },
        { "pipeline.zsh", 600 },
    };

    private readonly Dictionary<string, int> resolved = new Dictionary<string, int>(Defaults, StringComparer.Ordinal);

    public IDictionary limits { get; }

    public IReadOnlyDictionary<string, int> executables { get; }

    // Per-command limits in seconds, keyed by the function name (case-insensitive). Empty when the file declares none.
    public IReadOnlyDictionary<string, int> commands { get; }

    // The resolved test-run limits, defaults filled in: tests[level_ms][L0..L4] in milliseconds, tests[run_seconds], tests[engine_start_seconds].
    public IDictionary tests { get; }

    // The Watch-Blocking defaults, defaults filled in: wait[seconds], wait[milliseconds].
    public IDictionary wait { get; }

    private readonly Dictionary<string, int> testLevelMs = new Dictionary<string, int>(TestLevelDefaults, StringComparer.Ordinal);
    private int testRunSeconds = TestRunDefaultSeconds;
    private int engineStartSeconds = EngineStartDefaultSeconds;
    private int runListSeconds = RunListDefaultSeconds;
    private int waitSeconds = WaitDefaultSeconds;
    private int waitMilliseconds = WaitDefaultMilliseconds;

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

        if (d != null && d.Contains("wait") && d["wait"] != null)
        {
            ReadWait(d["wait"], errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("timeouts configuration validation failed:\n" + string.Join("\n", errors));
        }

        Hashtable view = new Hashtable(StringComparer.OrdinalIgnoreCase);
        foreach (string environment in Environments)
        {
            Hashtable byShell = new Hashtable(StringComparer.OrdinalIgnoreCase);
            foreach (string shell in Shells)
            {
                byShell[shell] = shell == HookShell
                    ? new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        { "foreground", resolved[environment + "." + shell + ".foreground"] },
                        { "background", resolved[environment + "." + shell + ".background"] },
                    }
                    : (object)resolved[environment + "." + shell];
            }
            view[environment] = byShell;
        }
        limits = view;

        tests = new Hashtable(StringComparer.OrdinalIgnoreCase)
        {
            { "level_ms", TestLevelLimitsMs() },
            { "run_seconds", testRunSeconds },
            { "engine_start_seconds", engineStartSeconds },
            { "run_list_seconds", runListSeconds },
        };

        wait = new Hashtable(StringComparer.OrdinalIgnoreCase)
        {
            { "seconds", waitSeconds },
            { "milliseconds", waitMilliseconds },
        };
    }

    private void ReadWait(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid wait (must be a map of seconds, milliseconds)");
            return;
        }
        CheckKeys(map, WaitKeys, "wait.", errors);
        foreach (string key in WaitKeys)
        {
            if (!map.Contains(key) || map[key] == null) { continue; }
            int? number = PositiveSeconds(map[key]);
            if (number == null)
            {
                errors.Add(string.Format("invalid wait.{0} '{1}' (must be a positive whole number)", key, map[key]));
                continue;
            }
            if (key == "seconds") { waitSeconds = number.Value; } else { waitMilliseconds = number.Value; }
        }
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

    // The most seconds one engine start of a black-box test may take: the entry's import plus one command.
    public int EngineStartSeconds()
    {
        return engineStartSeconds;
    }

    // The most seconds one run of a run list may take under one engine.
    public int RunListSeconds()
    {
        return runListSeconds;
    }

    private void ReadTests(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid tests (must be a map of level_ms, run_seconds, engine_start_seconds, run_list_seconds)");
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

        if (map.Contains("engine_start_seconds") && map["engine_start_seconds"] != null)
        {
            int? seconds = PositiveSeconds(map["engine_start_seconds"]);
            if (seconds == null)
            {
                errors.Add(string.Format("invalid tests.engine_start_seconds '{0}' (must be a positive whole number)", map["engine_start_seconds"]));
            }
            else { engineStartSeconds = seconds.Value; }
        }

        if (map.Contains("run_list_seconds") && map["run_list_seconds"] != null)
        {
            int? seconds = PositiveSeconds(map["run_list_seconds"]);
            if (seconds == null)
            {
                errors.Add(string.Format("invalid tests.run_list_seconds '{0}' (must be a positive whole number)", map["run_list_seconds"]));
            }
            else { runListSeconds = seconds.Value; }
        }
    }

    public int SecondsFor(string environment, string shell, bool background)
    {
        string env = Axis(environment, Environments, "environment");
        string sh = Axis(shell, Shells, "shell");
        if (sh != HookShell)
        {
            if (background)
            {
                throw new ArgumentException(sh + " has no background limit; background applies to bash calls only");
            }
            return resolved[env + "." + sh];
        }
        return resolved[env + "." + sh + "." + (background ? "background" : "foreground")];
    }

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
            errors.Add(string.Format("invalid {0} (must be a map of {1})", path, string.Join(" | ", Shells)));
            return;
        }
        CheckKeys(byShell, Shells, path + ".", errors);

        foreach (string shell in Shells)
        {
            if (shell != HookShell && byShell.Contains(shell) && byShell[shell] != null)
            {
                ReadSeconds(byShell[shell], environment + "." + shell, path + "." + shell, errors);
            }
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
