let
    HelpersRecord = try Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared) otherwise null,
    fetch = (p) => fnGetClients(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    expanded = Table.TransformColumnTypes(all,{{"id", Int64.Type}, {"name", type text}, {"is_active", type logical}, {"address", type text}, {"created_at", type datetime}, {"updated_at", type datetime}, {"currency", type text}}),
    filtered = Table.SelectRows(expanded, each [id] <> null),
    renamed = Table.RenameColumns(filtered,{{"id", "Client_Id"},{"name", "Client_name"}})
in
    renamed
