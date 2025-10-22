let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetTaskAssignments(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    // expand project only if present and record
    HasProject = List.Contains(Table.ColumnNames(#"Lignes filtrées"), "project"),
    WithProject = if HasProject then Table.ExpandRecordColumn(#"Lignes filtrées", "project", {"id", "name", "code"}, {"project.id", "project.name", "project.code"}) else #"Lignes filtrées",
    #"Colonnes renommées" = Table.RenameColumns(WithProject,{{"project.id", "project_id"}, {"project.name", "project_name"}, {"project.code", "project_code"}}, MissingField.Ignore),
    // expand task only if present
    HasTask = List.Contains(Table.ColumnNames(#"Colonnes renommées"), "task"),
    WithTask = if HasTask then Table.ExpandRecordColumn(#"Colonnes renommées", "task", {"id", "name"}, {"task.id", "task.name"}) else #"Colonnes renommées",
    #"Colonnes renommées1" = Table.RenameColumns(WithTask,{{"task.id", "task_id"}, {"task.name", "task_name"}}, MissingField.Ignore),
    // apply types only to existing columns
    TypeCandidates = {{"task_name", type text}, {"task_id", Int64.Type}, {"project_code", type text}, {"project_name", type text}, {"project_id", type text}, {"budget", type number}, {"hourly_rate", type number}, {"updated_at", type datetime}, {"created_at", type datetime}, {"is_active", type logical}, {"billable", type logical}, {"id", Int64.Type}},
    ExistingTypePairs = List.Select(TypeCandidates, each List.Contains(Table.ColumnNames(#"Colonnes renommées1"), _{0})),
    #"Type modifié" = if List.Count(ExistingTypePairs) = 0 then #"Colonnes renommées1" else Table.TransformColumnTypes(#"Colonnes renommées1", ExistingTypePairs)
in
    #"Type modifié"
