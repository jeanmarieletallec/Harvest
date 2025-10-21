let
    AddFunctionCall=List.Generate(()=>[Page Number=0,Func=null], each (try _[Func])[HasError]=false, each [Page Number=_[Page Number]+1, Func=fnGetClients([Page Number]+1)], each _[Func]),
    #"Converted to Table" = Table.FromList(AddFunctionCall, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandTableColumn(#"Converted to Table", "Column1", {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"}, {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"}),
    #"Lignes filtrées" = Table.SelectRows(#"Expanded Column1", each [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Client_Id"},{"name", "Client_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"Client_Id", Int64.Type}, {"Client_name", type text}, {"is_active", type logical}, {"address", type text}, {"created_at", type datetime}, {"updated_at", type datetime}, {"currency", type text}})
in
    #"Type modifié"
