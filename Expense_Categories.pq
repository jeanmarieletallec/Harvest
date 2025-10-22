let
    AddFunctionCall=List.Generate(()=>[Page Number=0,Func=null], each (try _[Func])[HasError]=false, each [Page Number=_[Page Number]+1, Func=fnGetExpenseCategories([Page Number]+1)], each _[Func]),
    #"Converted to Table" = Table.FromList(AddFunctionCall, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandTableColumn(#"Converted to Table", "Column1", {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"}, {"id", "name", "unit_name", "unit_price", "is_active", "created_at", "updated_at"}),
    #"Lignes filtrées" = Table.SelectRows(#"Expanded Column1", each [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "ExpenseCat_id"},{"name", "ExpenseCat_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"ExpenseCat_id", Int64.Type}, {"ExpenseCat_name", type text}, {"unit_name", type text}, {"unit_price", type number}, {"is_active", type logical}, {"created_at", type datetime}, {"updated_at", type datetime}})
in
    #"Type modifié"
