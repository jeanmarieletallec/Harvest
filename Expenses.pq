let
    HelpersRecord = try Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared) otherwise null,
    fetch = (p) => fnGetExpenses(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    // The FetchAllPages helper returns a combined table directly (not wrapped in a Column1 column)
    // Use the returned table as-is
    #"Expanded Column1" = all,
    #"Lignes filtrées" = Table.SelectRows(#"Expanded Column1", each [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Expense_id"}, {"notes", "Expense_notes"}, {"total_cost", "Expense_cost"}, {"units", "Expense_units"}}),
    #"receipt développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "receipt", {"file_name"}, {"receipt.file_name"}),
    #"Colonnes renommées1" = Table.RenameColumns(#"receipt développé",{{"receipt.file_name", "receipt_file_name"}, {"id.2", "Client_id"}, {"name.1", "Client_name"}, {"id.3", "Project_id"}, {"name.2", "Project_name"}, {"code", "Project_code"}, {"name.3", "ExpenseCat_name"}, {"id.4", "ExpenseCat_id"}, {"id.5", "Project_user_id"}, {"created_at.1", "Project_user_created"}, {"updated_at.1", "Project_user_updated"}, {"id.6", "Invoice_id"}, {"number", "Invoice_number"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées1",{{"Expense_id", Int64.Type}, {"spent_date", type date}, {"Expense_notes", type text}, {"Expense_cost", type number}, {"Expense_units", type number}, {"billable", type logical}, {"receipt_file_name", type text}, {"is_closed", type logical}, {"is_locked", type logical}, {"is_billed", type logical}, {"locked_reason", type text}, {"created_at", type datetime}, {"updated_at", type datetime}}),
    #"Colonnes renommées2" = Table.RenameColumns(#"Type modifié",{{"id.1", "User_id"}, {"name", "User_name"}}),
    #"Type modifié1" = Table.TransformColumnTypes(#"Colonnes renommées2",{{"User_id", Int64.Type}, {"User_name", type text}, {"Client_id", Int64.Type}, {"Client_name", type text}, {"currency", type text}, {"Project_id", type text}, {"Project_name", type text}, {"Project_code", type text}, {"ExpenseCat_id", Int64.Type}, {"ExpenseCat_name", type text}, {"unit_price", type number}, {"unit_name", type text}, {"Project_user_id", Int64.Type}, {"is_project_manager", type logical}, {"is_active", type logical}, {"budget", type number}, {"Project_user_created", type datetime}, {"Project_user_updated", type datetime}, {"hourly_rate", type number}, {"Invoice_id", Int64.Type}, {"Invoice_number", type text}})
in
    #"Type modifié1"
