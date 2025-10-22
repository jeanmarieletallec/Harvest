let
    HelpersLocal = try Helpers otherwise null,
    FetchRemoteHelpers = () => Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared),
    HelpersRecord = if HelpersLocal <> null then HelpersLocal else (try FetchRemoteHelpers() otherwise null),
    fetch = (p) => fnGetInvoices(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    #"Lignes filtrées" = Table.SelectRows(all, each Record.HasFields(_, "id") and [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Invoice_id"}, {"number", "Invoice_number"}}),
    #"client développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "client", {"id", "name"}, {"client.id", "client.name"}),
    #"Colonnes renommées1" = Table.RenameColumns(#"client développé",{{"client.id", "client_id"}, {"client.name", "client_name"}}, MissingField.Ignore),
    WithUserNames = if List.Contains(Table.ColumnNames(#"Colonnes renommées1"), "id.1") then Table.RenameColumns(#"Colonnes renommées1",{{"id.1", "User_id"}}) else #"Colonnes renommées1",
    WithUserNames2 = if List.Contains(Table.ColumnNames(WithUserNames), "name") and not List.Contains(Table.ColumnNames(WithUserNames), "User_name") then Table.RenameColumns(WithUserNames,{{"name", "User_name"}}) else WithUserNames,
    // apply types only to existing columns
    TypeCandidates = {{"Invoice_id", Int64.Type}, {"client_key", type text}, {"Invoice_number", type text}, {"purchase_order", type text}, {"amount", type number}, {"due_amount", type number}, {"tax", type number}, {"tax_amount", type number}, {"tax2", type number}, {"tax2_amount", type number}, {"discount", type number}, {"discount_amount", type number}, {"subject", type text}, {"notes", type text}, {"period_start", type date}, {"period_end", type date}, {"issue_date", type date}, {"due_date", type date}, {"sent_at", type datetime}, {"paid_at", type datetime}, {"closed_at", type datetime}, {"created_at", type datetime}, {"updated_at", type datetime}, {"paid_date", type datetime}, {"currency", type text}, {"client_id", Int64.Type}, {"client_name", type text}, {"estimate", type number}, {"retainer", type number}, {"User_id", Int64.Type}, {"User_name", type text}},
    ExistingTypePairs = List.Select(TypeCandidates, each List.Contains(Table.ColumnNames(WithUserNames2), _{0})),
    #"Type modifié" = if List.Count(ExistingTypePairs) = 0 then WithUserNames2 else Table.TransformColumnTypes(WithUserNames2, ExistingTypePairs),
    // expand line_items if present
    #"line_items développé" = if List.Contains(Table.ColumnNames(#"Type modifié"), "line_items") then Table.ExpandListColumn(#"Type modifié", "line_items") else #"Type modifié",
    #"line_items développé1" = if List.Contains(Table.ColumnNames(#"line_items développé"), "line_items") then Table.ExpandRecordColumn(#"line_items développé", "line_items", {"id", "kind", "description", "quantity", "unit_price", "amount", "taxed", "taxed2", "project"}, {"id", "kind", "description", "quantity", "unit_price", "amount.1", "taxed", "taxed2", "project"}) else #"line_items développé",
    #"Colonnes renommées2" = Table.RenameColumns(#"line_items développé1",{{"id", "Line_item_id"}, {"kind", "Line_item_kind"}, {"description", "Line_item_description"}, {"quantity", "Line_item_quantity"}, {"unit_price", "Line_item_unit_price"}, {"amount.1", "Line_item_amount"}}, MissingField.Ignore),
    // expand project in line items only if present and a record
    #"project développé" = if List.Contains(Table.ColumnNames(#"Colonnes renommées2"), "project") then Table.ExpandRecordColumn(#"Colonnes renommées2", "project", {"id", "name", "code"}, {"id", "name", "code"}) else #"Colonnes renommées2",
    #"Colonnes renommées3" = Table.RenameColumns(#"project développé",{{"id", "Project_id"}, {"name", "Project_name"}, {"code", "Project_code"}}, MissingField.Ignore),
    TypeCandidates2 = {{"Line_item_id", Int64.Type}, {"Line_item_kind", type text}, {"Line_item_description", type text}, {"Line_item_quantity", type number}, {"Line_item_unit_price", type number}, {"Line_item_amount", type number}, {"taxed", type logical}, {"taxed2", type logical}, {"Project_id", type text}, {"Project_name", type text}, {"Project_code", type text}},
    ExistingTypePairs2 = List.Select(TypeCandidates2, each List.Contains(Table.ColumnNames(#"Colonnes renommées3"), _{0})),
    #"Type modifié1" = if List.Count(ExistingTypePairs2) = 0 then #"Colonnes renommées3" else Table.TransformColumnTypes(#"Colonnes renommées3", ExistingTypePairs2)
in
    #"Type modifié1"
