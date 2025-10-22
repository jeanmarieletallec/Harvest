let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/expense_categories?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Expense_categories = #"Imported JSON"[expense_categories],
    #"Converted to Table" = Table.FromList(Expense_categories, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"}, {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"})
in
    #"Column1 développé"
in
    Source
