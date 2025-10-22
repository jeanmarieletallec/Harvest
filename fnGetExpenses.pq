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
in 
    Source