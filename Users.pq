let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetUsers(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "User_id"}}),
    // apply types only for columns that exist
    TypeCandidates = { {"User_id", Int64.Type}, {"first_name", type text}, {"last_name", type text}, {"email", type text}, {"telephone", type text}, {"timezone", type text}, {"weekly_capacity", type number}, {"has_access_to_all_future_projects", type logical}, {"is_contractor", type logical}, {"is_admin", type logical}, {"is_project_manager", type logical}, {"can_see_rates", type logical}, {"can_create_projects", type logical}, {"can_create_invoices", type logical}, {"is_active", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}, {"default_hourly_rate", type number}, {"cost_rate", type number} },
    ExistingTypePairs = List.Select(TypeCandidates, each List.Contains(Table.ColumnNames(#"Colonnes renommées"), _{0})),
    #"Type modifié" = if List.Count(ExistingTypePairs) = 0 then #"Colonnes renommées" else Table.TransformColumnTypes(#"Colonnes renommées", ExistingTypePairs),
    // roles might not exist or not be a list
    #"Valeurs extraites" = if List.Contains(Table.ColumnNames(#"Type modifié"), "roles") then Table.TransformColumns(#"Type modifié", {"roles", each Text.Combine(List.Transform(_, Text.From), ";"), type text}) else #"Type modifié",
    // final optional columns
    FinalTypeCandidates = { {"avatar_url", type text}, {"name", type text}, {"address", type text}, {"currency", type text} },
    ExistingFinalPairs = List.Select(FinalTypeCandidates, each List.Contains(Table.ColumnNames(#"Valeurs extraites"), _{0})),
    #"Type modifié1" = if List.Count(ExistingFinalPairs) = 0 then #"Valeurs extraites" else Table.TransformColumnTypes(#"Valeurs extraites", ExistingFinalPairs)
in
    #"Type modifié1"
