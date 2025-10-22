let
    HelpersRecord = try Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/jeanmarieletallec/Harvest/main/Helpers.pq")), #shared) otherwise null,
    fetch = (p) => fnGetExpenses(p),
    all = if (HelpersRecord <> null and Record.HasFields(HelpersRecord, "FetchAllPages")) then HelpersRecord[FetchAllPages](fetch) else error "Helpers.FetchAllPages not found - import Helpers or enable remote fetch",
    // The FetchAllPages helper returns a combined table directly (not wrapped in a Column1 column)
    // Use the returned table as-is
    // The helper returns a combined table; make renames tolerant to missing columns
    RenameIfExists = (tbl as table, oldName as text, newName as text) as table =>
        if List.Contains(Table.ColumnNames(tbl), oldName) then Table.RenameColumns(tbl, {{oldName, newName}}) else tbl,

    combined = all,
    filtered = Table.SelectRows(combined, each Record.FieldValues(_){0} <> null and Record.FieldValues(_){0} <> ""),
    step1 = RenameIfExists(filtered, "id", "Expense_id"),
    step2 = RenameIfExists(step1, "notes", "Expense_notes"),
    step3 = RenameIfExists(step2, "amount", "Expense_cost"),
    step4 = RenameIfExists(step3, "hours", "Expense_hours"),
    // rename nested entity ids/names if present
    step5 = RenameIfExists(step4, "user_id", "User_id"),
    step6 = RenameIfExists(step5, "user_name", "User_name"),
    step7 = RenameIfExists(step6, "client_id", "Client_id"),
    step8 = RenameIfExists(step7, "client_name", "Client_name"),
    step9 = RenameIfExists(step8, "project_id", "Project_id"),
    step10 = RenameIfExists(step9, "project_name", "Project_name"),
    // final type conversions for common columns (only if they exist)
    TypeConvert = Table.TransformColumnTypes(step10, List.Select({{"Expense_id", Int64.Type}, {"spent_date", type date}, {"Expense_notes", type text}, {"Expense_cost", type number}, {"Expense_hours", type number}, {"billable", type logical}, {"is_closed", type logical}, {"is_billed", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}, {"User_id", Int64.Type}, {"User_name", type text}, {"Client_id", Int64.Type}, {"Client_name", type text}, {"Project_id", type text}, {"Project_name", type text}}, each List.Contains(Table.ColumnNames(step10), _{0})) )
in
    TypeConvert
