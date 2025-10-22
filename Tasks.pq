let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetTasks(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Task_id"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"Task_id", Int64.Type}, {"name", type text}, {"billable_by_default", type logical}, {"default_hourly_rate", type number}, {"is_default", type logical}, {"is_active", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}, {"code", type text}, {"is_billable", type logical}, {"is_fixed_fee", type logical}, {"bill_by", type text}, {"budget", type number}, {"budget_by", type text}, {"notify_when_over_budget", type logical}, {"over_budget_notification_percentage", type number}, {"show_budget_to_all", type logical}, {"starts_on", type date}, {"ends_on", type date}, {"over_budget_notification_date", type date}, {"notes", type text}, {"cost_budget", type number}, {"cost_budget_include_expenses", type logical}, {"hourly_rate", type number}, {"fee", type number}, {"id.1", Int64.Type}, {"name.1", type text}, {"currency", type text}})
in
    #"Type modifié"
