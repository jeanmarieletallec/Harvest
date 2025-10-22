let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/expense_categories?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    expenseCategories = if Record.HasFields(raw, "expense_categories") then raw[expense_categories] else {},
    table = Table.FromList(expenseCategories, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"}, {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = expanded, NextPage = nextPage]
in
    Source
