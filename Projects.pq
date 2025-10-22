let
    Helpers = try Helpers otherwise Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    fetch = (p) => fnGetProjects(p),
    all = if (Helpers <> null and Record.HasFields(Helpers, "FetchAllPages")) then Helpers[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found",
    -- Ensure column names consistent
    typed = Table.TransformColumnTypes(all,{{"id", Int64.Type}, {"name", type text}, {"code", type text}, {"is_active", type logical}, {"is_billable", type logical}, {"is_fixed_fee", type logical}, {"bill_by", type text}, {"budget", type number}, {"budget_by", type text}, {"notify_when_over_budget", type logical}, {"over_budget_notification_percentage", type number}, {"show_budget_to_all", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}, {"starts_on", type date}, {"ends_on", type date}, {"over_budget_notification_date", type date}, {"notes", type text}, {"cost_budget", type number}, {"cost_budget_include_expenses", type logical}, {"hourly_rate", type number}, {"fee", type number}, {"Client_id", Int64.Type}, {"currency", type text}}),
    filtered = Table.SelectRows(typed, each [id] <> null),
    renamed = Table.RenameColumns(filtered,{{"id", "Project_id"},{"name", "Project_name"}})
in
    renamed
