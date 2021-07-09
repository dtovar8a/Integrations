codeunit 70202 "DTOImportItemsFromSW"
{
    trigger OnRun()
    var
        HTTPRest: Codeunit DTOHTTPRest;
    begin
        CheckServiceWeb();

        HTTPRest.Inizialice(Enum::"Http Request Type"::GET, CustomServiceWeb."Request URL");
        SetAuthorization(HTTPRest);
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

    local procedure SetAuthorization(var HTTPRest: Codeunit DTOHTTPRest)
    var
        InStr: InStream;
    begin
        case ServiceWebConnection."Auth Type" of
            Enum::DTOAuthType::Basic:
                begin
                    ServiceWebConnection.TestField(User);
                    ServiceWebConnection.TestField(Password);

                    HTTPRest.AddAuthorization(ServiceWebConnection.User, ServiceWebConnection.Password);
                end;

            Enum::DTOAuthType::Bearer:
                begin
                    ServiceWebConnection.TestField(Token);

                    HTTPRest.AddAuthorization(ServiceWebConnection.Token);
                end;

            Enum::DTOAuthType::Certificated:
                begin
                    ServiceWebConnection.TestField("Certificated Load", true);
                    ServiceWebConnection.TestField("Certificated Password");
                    ServiceWebConnection.CalcFields(Certificate);

                    if not ServiceWebConnection.Certificate.HasValue then
                        Error(CertificateDoesnotExistsLbl);

                    ServiceWebConnection.Certificate.CreateInStream(InStr);
                    HTTPRest.AddAuthorization(InStr, ServiceWebConnection."Certificated Password");
                end;

            Enum::DTOAuthType::OAuth2:
                begin
                    ServiceWebConnection.TestField("Grand Type");
                    ServiceWebConnection.TestField("Client Id");
                    ServiceWebConnection.TestField("Cliente Secret");
                    ServiceWebConnection.TestField(Resource);
                    ServiceWebConnection.TestField("Token URL");

                    HTTPRest.AddAuthorization(
                        ServiceWebConnection."Token URL",
                        ServiceWebConnection."Grand Type",
                        ServiceWebConnection."Client Id",
                        ServiceWebConnection."Cliente Secret",
                        ServiceWebConnection.Resource);
                end;
        end;
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
        CertificateDoesnotExistsLbl: label 'There is no certificate file loaded', Comment = 'No existe fichero de certificado cargado';
}