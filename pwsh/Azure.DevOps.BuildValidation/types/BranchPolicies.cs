using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps.BuildValidation;

public sealed class BranchPolicies : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "minimum_reviewers", "reset_on_push", "creator_vote_counts", "require_comment_resolution", "automatic_reviewer_ids", "merge_types" };

    // The merge types a pull request may use, spelled as the ADO merge-strategy policy names them.
    public static readonly string[] MergeTypes = { "squash", "no_fast_forward", "rebase", "rebase_merge" };

    // The fewest approvals a pull request needs.
    public int minimum_reviewers { get; } = 1;

    // Whether a new push resets the approvals already given.
    public bool reset_on_push { get; } = true;

    // Whether the author's own approval counts toward the minimum.
    public bool creator_vote_counts { get; } = false;

    // Whether every comment must be resolved before the merge.
    public bool require_comment_resolution { get; } = true;

    // The reviewers added to every pull request, by ADO identity id (a GUID), since the required-reviewer policy takes ids, not names.
    public IReadOnlyList<string> automatic_reviewer_ids { get; } = Array.Empty<string>();

    // The merge types allowed; squash alone lands each pull request as one commit.
    public IReadOnlyList<string> merge_types { get; } = new[] { "squash" };

    public BranchPolicies(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d == null) { d = new Hashtable(); }
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("policies: unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        if (d.Contains("minimum_reviewers"))
        {
            int minimum;
            if (d["minimum_reviewers"] != null && int.TryParse(d["minimum_reviewers"].ToString(), out minimum) && minimum >= 1) { minimum_reviewers = minimum; }
            else { errors.Add(string.Format("policies: minimum_reviewers '{0}' must be a whole number of at least 1", d["minimum_reviewers"])); }
        }
        reset_on_push = Flag(d, "reset_on_push", reset_on_push, errors);
        creator_vote_counts = Flag(d, "creator_vote_counts", creator_vote_counts, errors);
        require_comment_resolution = Flag(d, "require_comment_resolution", require_comment_resolution, errors);

        if (d.Contains("automatic_reviewer_ids"))
        {
            List<string> reviewers = Names(d["automatic_reviewer_ids"], "automatic_reviewer_ids", errors);
            if (reviewers != null)
            {
                foreach (string id in reviewers)
                {
                    if (!Guid.TryParse(id, out _)) { errors.Add(string.Format("policies: automatic reviewer '{0}' is not an identity id (a GUID)", id)); }
                }
                automatic_reviewer_ids = reviewers;
            }
        }
        if (d.Contains("merge_types"))
        {
            List<string> types = Names(d["merge_types"], "merge_types", errors);
            if (types != null && types.Count == 0) { errors.Add("policies: merge_types must name at least one merge type"); }
            else if (types != null)
            {
                foreach (string type in types)
                {
                    if (Array.IndexOf(MergeTypes, type) < 0)
                    {
                        errors.Add(string.Format("policies: merge type '{0}' is unknown (allowed: {1})", type, string.Join(", ", MergeTypes)));
                    }
                }
                merge_types = types;
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private static bool Flag(IDictionary d, string key, bool fallback, List<string> errors)
    {
        if (!d.Contains(key)) { return fallback; }
        if (d[key] is bool value) { return value; }
        errors.Add(string.Format("policies: {0} must be true or false", key));
        return fallback;
    }

    private static List<string> Names(object raw, string key, List<string> errors)
    {
        if (raw is string || !(raw is IEnumerable items))
        {
            errors.Add(string.Format("policies: {0} must be a list", key));
            return null;
        }
        List<string> names = new List<string>();
        foreach (object item in items)
        {
            string name = item == null ? null : item.ToString();
            if (string.IsNullOrWhiteSpace(name)) { errors.Add(string.Format("policies: {0} holds an empty entry", key)); }
            else { names.Add(name); }
        }
        return names;
    }
}
