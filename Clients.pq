let
    Helpers = Helpers,
    fetch = (p) => fnGetClients(p),
    all = Helpers.FetchAllPages(fetch),
    expanded = Table.TransformColumnTypes(all,{{"id", Int64.Type}, {"name", type text}, {"is_active", type logical}, {"address", type text}, {"created_at", type datetime}, {"updated_at", type datetime}, {"currency", type text}}),
    filtered = Table.SelectRows(expanded, each [id] <> null),
    renamed = Table.RenameColumns(filtered,{{"id", "Client_Id"},{"name", "Client_name"}})
in
    renamed
