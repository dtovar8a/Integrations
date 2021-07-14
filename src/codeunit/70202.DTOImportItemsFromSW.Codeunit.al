codeunit 70202 "DTOImportItemsFromSW"
{
    trigger OnRun()
    var
        HTTPRest: Codeunit DTOHTTPRest;
    begin
        CheckServiceWeb();

        HTTPRest.Inizialice(Enum::"Http Request Type"::GET, CustomServiceWeb."Request URL");
        ServiceWebConnection.SetAuthorization(HTTPRest);
        HTTPRest.Run();

        CreateItemProxy(HTTPRest.GetResponseMessageContentText());
    end;

    local procedure CheckServiceWeb()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        InventorySetup.TestField(DTOIItemSW);

        CustomServiceWeb.Get(InventorySetup.DTOIItemSW);
        CustomServiceWeb.TestField(Enabled, true);
        CustomServiceWeb.TestField("Connection Code");

        ServiceWebConnection.Get(CustomServiceWeb."Connection Code");
        ServiceWebConnection.TestField(Enabled, true);
    end;

    local procedure CreateItemProxy(
        ResponseText: text)
    var
        ItemProxy: record DTOItemProxy;
        JItems: JsonObject;
        JItem: JsonObject;
        JTValues: JsonToken;
        JValue: JsonToken;
        JToken: JsonToken;
    begin
        if not JItems.ReadFrom(ResponseText) then
            exit;

        if not JItems.Get('value', JTValues) then
            exit;

        foreach JValue in JTValues.AsArray() do begin
            JItem := JValue.AsObject();

            ItemProxy.Init();
            ItemProxy.Insert(true);

            if JItem.Get('No', JToken) then
                ItemProxy.Validate("Item No.", CopyStr(JToken.AsValue().AsCode(), 1, MaxStrLen(ItemProxy."Item No.")));

            if JItem.Get('Description', JToken) then
                ItemProxy.Validate(Description, CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ItemProxy.Description)));

            ItemProxy.Modify(true);
        end;
    end;

    var
        CustomServiceWeb: record "DTOCustomWebService";
        ServiceWebConnection: record DTOWebServiceConnection;
}