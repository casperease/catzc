/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/types/BicepTemplate.cs
    folder: types
    name: bicep-template
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/types/BicepTemplate.cs.md
    cites:
      - ADR-AZ-CUSTOMER
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.Templates;

public sealed class BicepTemplate : Catzc.Base.Objects.DictionaryRecord
{
    // The template's name (its folder name). Always present.
    public string name { get; }

    // The template's folder (repo-relative). Always present.
    public string folder { get; }

    // The entry-point Bicep file within the folder. Always present.
    public string main { get; }

    // Every Bicep file in the template. Never null (empty array when none).
    public string[] bicep_files { get; }

    // The folder holding the template's per-deployment configuration files. Always present.
    public string configuration_folder { get; }

    // The configuration files under configuration_folder — one per deployable coordinate. Never null.
    public string[] configuration_files { get; }

    // The environments this template deploys into. Never null (empty array when none).
    public string[] environments { get; }

    // The subscriptions this template deploys into (resolved per slot). Never null (empty array when none).
    public string[] subscriptions { get; }

    // The customers this template is deployed for (its configuration subfolders). Never null.
    public string[] customers { get; }

    // The fully resolved deployable units — the (customer?, environment, slot) fan-out. Never null.
    public BicepSlot[] slots { get; }

    // The folder build output is written to. Always present.
    public string output_folder { get; }

    // The deployment mode (e.g. Incremental / Complete). Always present.
    public string deployment_mode { get; }

    // The deployment scope target (e.g. ResourceGroup / Subscription). Always present.
    public string deployment_target { get; }

    // The kind of environment this template targets (e.g. per-subscription vs shared). Always present.
    public string environment_kind { get; }

    public bool customer_deployment { get; }

    // The short name used when composing resource names. Always present.
    public string short_name { get; }

    // The template's PrePost.psm1 hook module (repo-relative). Null when the template ships no PrePost.psm1.
    public string prepost_module { get; }

    // Supporting resource files the template carries. Null when the template has no resources/ folder.
    public string[] resources { get; }

    public BicepTemplate(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("BicepTemplate requires a dictionary"); }
        name = Req(d, "name");
        folder = Req(d, "folder");
        main = Req(d, "main");
        configuration_folder = Req(d, "configuration_folder");
        output_folder = Req(d, "output_folder");
        deployment_mode = Req(d, "deployment_mode");
        deployment_target = Req(d, "deployment_target");
        environment_kind = Req(d, "environment_kind");
        customer_deployment = (d.Contains("customer_deployment") && d["customer_deployment"] is bool cd) && cd;
        short_name = Req(d, "short_name");
        bicep_files = StrArr(d, "bicep_files");
        configuration_files = StrArr(d, "configuration_files");
        environments = StrArr(d, "environments");
        subscriptions = StrArr(d, "subscriptions");
        customers = StrArr(d, "customers");
        slots = SlotArr(d, "slots");
        prepost_module = OptStr(d, "prepost_module");
        resources = (d.Contains("resources") && d["resources"] != null) ? StrArr(d, "resources") : null;
    }

    private static BicepSlot[] SlotArr(IDictionary d, string key)
    {
        object v = d.Contains(key) ? d[key] : null;
        if (v == null) { return new BicepSlot[0]; }
        var en = v as IEnumerable;
        if (en == null) { throw new ArgumentException("BicepTemplate.slots must be a collection of BicepSlot"); }
        var list = new List<BicepSlot>();
        foreach (var item in en)
        {
            var slot = item as BicepSlot;
            if (slot == null) { throw new ArgumentException("BicepTemplate.slots must contain BicepSlot instances"); }
            list.Add(slot);
        }
        return list.ToArray();
    }
}
