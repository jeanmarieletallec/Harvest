let
<<<<<<< HEAD
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/expenses?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Expenses = #"Imported JSON"[expenses],
    #"Converted to Table" = Table.FromList(Expenses, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "spent_date", "notes", "total_cost", "units", "billable", "receipt", "is_closed", "is_locked", "is_billed", "locked_reason", "created_at", "updated_at", "user", "client", "project", "expense_category", "user_assignment", "invoice"}, {"id", "spent_date", "notes", "total_cost", "units", "billable", "receipt", "is_closed", "is_locked", "is_billed", "locked_reason", "created_at", "updated_at", "user", "client", "project", "expense_category", "user_assignment", "invoice"}),
    #"user développé" = Table.ExpandRecordColumn(#"Column1 développé", "user", {"id", "name"}, {"id.1", "name"}),
    #"client développé" = Table.ExpandRecordColumn(#"user développé", "client", {"id", "name", "currency"}, {"id.2", "name.1", "currency"}),
    #"project développé" = Table.ExpandRecordColumn(#"client développé", "project", {"id", "name", "code"}, {"id.3", "name.2", "code"}),
    #"expense_category développé" = Table.ExpandRecordColumn(#"project développé", "expense_category", {"id", "name", "unit_price", "unit_name"}, {"id.4", "name.3", "unit_price", "unit_name"}),
    #"user_assignment développé" = Table.ExpandRecordColumn(#"expense_category développé", "user_assignment", {"id", "is_project_manager", "is_active", "budget", "created_at", "updated_at", "hourly_rate"}, {"id.5", "is_project_manager", "is_active", "budget", "created_at.1", "updated_at.1", "hourly_rate"}),
    #"invoice développé" = Table.ExpandRecordColumn(#"user_assignment développé", "invoice", {"id", "number"}, {"id.6", "number"})
in
    #"invoice développé"
=======
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/expenses?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    expenses = if Record.HasFields(raw, "expenses") then raw[expenses] else {},
    table = Table.FromList(expenses, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "project", "user", "client", "spent_date", "hours", "hours_decimal", "notes", "created_at", "updated_at", "is_closed", "is_billed", "billable", "amount", "invoice"}, {"id", "project", "user", "client", "spent_date", "hours", "hours_decimal", "notes", "created_at", "updated_at", "is_closed", "is_billed", "billable", "amount", "invoice"}),
    projectExpanded = Table.ExpandRecordColumn(expanded, "project", {"id", "name"}, {"project_id", "project_name"}),
    userExpanded = Table.ExpandRecordColumn(projectExpanded, "user", {"id", "name"}, {"user_id", "user_name"}),
    clientExpanded = Table.ExpandRecordColumn(userExpanded, "client", {"id", "name"}, {"client_id", "client_name"})
in
    [Data = clientExpanded, NextPage = null]
>>>>>>> ce84713 (Standardize queries: use Helpers.FetchAllPages pattern, convert fns to page records and normalize typings)
in
    let
        Source = (page as number) as record =>
    let
         apiUrl = "https://api.harvestapp.com/api/v2/expenses?page=" & Number.ToText(page),
         options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
         raw = Json.Document(Web.Contents(apiUrl , options),65001),
        expenses = if Record.HasFields(raw, "expenses") then raw[expenses] else {},
        table = Table.FromList(expenses, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "project", "user", "client", "spent_date", "hours", "hours_decimal", "notes", "created_at", "updated_at", "is_closed", "is_billed", "billable", "amount", "invoice"}, {"id", "project", "user", "client", "spent_date", "hours", "hours_decimal", "notes", "created_at", "updated_at", "is_closed", "is_billed", "billable", "amount", "invoice"}),
        projectExpanded = Table.ExpandRecordColumn(expanded, "project", {"id", "name"}, {"project_id", "project_name"}),
        userExpanded = Table.ExpandRecordColumn(projectExpanded, "user", {"id", "name"}, {"user_id", "user_name"}),
        clientExpanded = Table.ExpandRecordColumn(userExpanded, "client", {"id", "name"}, {"client_id", "client_name"})
    in
        [Data = clientExpanded, NextPage = null]
