let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetExpenseCategories(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "ExpenseCat_id"},{"name", "ExpenseCat_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"ExpenseCat_id", Int64.Type}, {"ExpenseCat_name", type text}, {"unit_name", type text}, {"unit_price", type number}, {"is_active", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}})
in
    #"Type modifié"
