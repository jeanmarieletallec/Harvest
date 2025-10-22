let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetInvoices(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Invoice_id"}, {"number", "Invoice_number"}}),
    #"client développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "client", {"id", "name"}, {"client.id", "client.name"}),
    #"Colonnes renommées1" = Table.RenameColumns(#"client développé",{{"client.id", "client_id"}, {"client.name", "client_name"}, {"id.1", "User_id"}, {"name", "User_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées1",{{"Invoice_id", Int64.Type}, {"client_key", type text}, {"Invoice_number", type text}, {"purchase_order", type text}, {"amount", type number}, {"due_amount", type number}, {"tax", type number}, {"tax_amount", type number}, {"tax2", type number}, {"tax2_amount", type number}, {"discount", type number}, {"discount_amount", type number}, {"subject", type text}, {"notes", type text}, {"state", type text}, {"period_start", type date}, {"period_end", type date}, {"issue_date", type date}, {"due_date", type date}, {"payment_term", type text}, {"sent_at", type datetime}, {"paid_at", type datetime}, {"closed_at", type datetime}, {"created_at", type datetime}, {"updated_at", type datetime}, {"paid_date", type datetime}, {"currency", type text}, {"client_id", Int64.Type}, {"client_name", type text}, {"estimate", type number}, {"retainer", type number}, {"User_id", Int64.Type}, {"User_name", type text}}),
    #"Colonnes supprimées" = Table.RemoveColumns(#"Type modifié",{"line_items"})
in
    #"Colonnes supprimées"
