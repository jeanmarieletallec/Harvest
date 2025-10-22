let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetTaskAssignments(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"project développé" = Table.ExpandRecordColumn(#"Lignes filtrées", "project", {"id", "name", "code"}, {"project.id", "project.name", "project.code"}),
    #"Colonnes renommées" = Table.RenameColumns(#"project développé",{{"project.id", "project_id"}, {"project.name", "project_name"}, {"project.code", "project_code"}}),
    #"task développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "task", {"id", "name"}, {"task.id", "task.name"}),
    #"Colonnes renommées1" = Table.RenameColumns(#"task développé",{{"task.id", "task_id"}, {"task.name", "task_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées1",{{"task_name", type text}, {"task_id", Int64.Type}, {"project_code", type text}, {"project_name", type text}, {"project_id", type text}, {"budget", type number}, {"hourly_rate", type number}, {"updated_at", type datetime}, {"created_at", type datetime}, {"is_active", type logical}, {"billable", type logical}, {"id", Int64.Type}})
in
    #"Type modifié"
