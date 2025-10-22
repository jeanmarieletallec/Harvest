let
    AddFunctionCall=List.Generate(()=>[Page Number=0,Func=null], each (try _[Func])[HasError]=false, each [Page Number=_[Page Number]+1, Func=fnGetProjectUsers([Page Number]+1)], each _[Func]),
    #"Converted to Table" = Table.FromList(AddFunctionCall, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandTableColumn(#"Converted to Table", "Column1", {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project_id", "project_name", "project_code", "user_id", "user_name"}, {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project_id", "project_name", "project_code", "user_id", "user_name"}),
    #"Lignes filtrées" = Table.SelectRows(#"Column1 développé", each [id] <> null and [id] <> ""),
    #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées",{{"id", "Project_user_id"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées",{{"Project_user_id", Int64.Type}, {"is_project_manager", type logical}, {"is_active", type logical}, {"use_default_rates", type logical}, {"budget", type number}, {"created_at", type datetime}, {"updated_at", type datetime}, {"hourly_rate", type number}, {"project_id", type text}, {"project_name", type text}, {"project_code", type text}, {"user_id", Int64.Type}, {"user_name", type text}})
in
    #"Type modifié"
