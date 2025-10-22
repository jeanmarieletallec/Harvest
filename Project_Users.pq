let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetProjectUsers(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Project_user_id"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"Project_user_id", Int64.Type}, {"is_project_manager", type logical}, {"is_active", type logical}, {"use_default_rates", type logical}, {"budget", type number}, {"created_at", type datetime}, {"updated_at", type datetime}, {"hourly_rate", type number}, {"project_id", type text}, {"project_name", type text}, {"project_code", type text}, {"user_id", Int64.Type}, {"user_name", type text}})
in
    #"Type modifié"
