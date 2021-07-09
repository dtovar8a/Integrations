codeunit 70201 "DTOHTTPRest"
{
    var
        RequestMessage: HttpRequestMessage;
        RequestMessageHeader: HttpHeaders;
        RequestContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        HasRequestContent: Boolean;
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseMessageContent: HttpContent;
        ResponseMessageContentText: Text;
        XmlDoc: XmlDocument;
        XmlResponseText: text;
        JsonObj: JsonObject;
        JsonResponseText: text;

    trigger OnRun()
    var
        ClientSendErr: Label 'Error using Send method (Error code: %1, Description: %2', Comment = 'Error al utilizar el método Send (Código de error: %1, Descripción : %2';
        ResponseMessageContentErr: label 'Unexpected format for response (Response: %1)', Comment = 'Formato inesperado para la respuesta (Resuesta: %1)';
    begin
        if HasRequestContent then
            RequestMessage.Content := RequestContent;

        if Client.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessageContent := ResponseMessage.Content;
            ResponseMessageContent.ReadAs(ResponseMessageContentText);

            if ResponseMessageContentText <> '' then begin
                case true of
                    XmlDocument.ReadFrom(ResponseMessageContentText, XmlDoc):
                        begin
                            XmlResponseText := ResponseMessageContentText;
                            ConvertXMLToJson(XmlResponseText, JsonResponseText);
                        end;

                    JsonObj.ReadFrom(ResponseMessageContentText):
                        begin
                            JsonResponseText := ResponseMessageContentText;
                            ConvertJsonToXML(JsonResponseText, XmlResponseText);
                        end;

                end;
            end;

            if not ResponseMessage.IsSuccessStatusCode() then
                Error(ClientSendErr, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        end else
            Error(ClientSendErr, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

    end;

    procedure Inizialice()
    begin
        Reset();
    end;

    procedure Inizialice(
        Method: enum "Http Request Type";
        Url: text)
    begin
        Reset();

        SetMethod(Method);
        SetUrl(Url);
    end;

    procedure Initialize( 
        Method: enum "Http Request Type";
        Url: text;
        RequestMessageContentText: text)
    begin
        Reset();

        SetMethod(Method);
        SetUrl(Url);
        SetRequestMessageContentText(RequestMessageContentText);
    end;

    local procedure Reset()
    begin
        ClearAll();
        RequestMessage.GetHeaders(RequestMessageHeader);
        RequestMessageHeader.Clear();
    end;

    local procedure SetMethod(Method: enum "Http Request Type")
    begin
        RequestMessage.Method := Format(Method);
    end;

    local procedure SetUrl(Url: Text)
    begin
        RequestMessage.SetRequestUri(Url);
    end;

    procedure SetRequestMessageContentText(RequestMessageContentText: Text)
    begin
        RequestContent.WriteFrom(RequestMessageContentText);
        RequestContent.GetHeaders(RequestContentHeader);
        RequestContentHeader.Remove('Content-Type');

        HasRequestContent := true;
    end;

    procedure AddRequestMessageHeader(Name: text; value: text)
    begin
        RequestMessageHeader.Add(Name, value);
    end;

    procedure AddRequestContentHeader(Name: text; value: text)
    begin
        RequestContentHeader.Add(Name, value);
    end;

    /// <summary>
    /// Set Basic Request Content Header 
    /// </summary>    
    procedure AddAuthorization(
        BasicUserName: text;
        BasicPassword: text)
    var
        AuthorizationText: text;
        Base64Convert: codeunit "Base64 Convert";
    begin
        AuthorizationText := StrSubstNo('%1:%2', BasicUserName, BasicPassword);
        AuthorizationText := Base64Convert.ToBase64(AuthorizationText);
        RequestMessageHeader.Add('Authorization', StrSubstNo('Basic %1', AuthorizationText));
    end;

    /// <summary>
    /// Set Bearer Request Content Header 
    /// </summary>
    procedure AddAuthorization(
        AccessToken: text)
    begin
        RequestMessageHeader.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
    end;

    /// <summary>
    /// Set OAuth2 Request Content Header 
    /// </summary>
    procedure AddAuthorization(
        URLLogin: text;
        GrandType: text;
        ClientId: text;
        ClientSecret: text;
        Resource: text)
    var
        HTTPRest: codeunit DTOHTTPRest;
        content: text;
    begin
        content := StrSubstNo('grant_type=%1&client_id=%2&client_secret=%3&resource=%4',
            GetUrlEncode(GrandType),
            GetUrlEncode(ClientId),
            GetUrlEncode(ClientSecret),
            GetUrlEncode(Resource));

        HTTPRest.Initialize("HTTP Request Type"::POST, URLLogin, content);
        HTTPRest.AddRequestContentHeader('Content-Type', 'application/x-www-form-urlencoded');
        HTTPRest.Run();
        RequestMessageHeader.Add('Authorization', StrSubstNo('Bearer %1', HTTPRest.GetJsonValueAsText('access_token')));
    end;


    /// <summary>
    /// Set Certificate Request Content Header 
    /// </summary>
    procedure AddAuthorization(CertificateInStream: InStream; Password: text): Boolean
    var
        X509Certificate: text;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        X509Certificate := Base64Convert.ToBase64(CertificateInStream);
        Client.AddCertificate(X509Certificate, Password);
    end;

    procedure GetResponseMessageContentText(): text
    begin
        exit(ResponseMessageContentText);
    end;

    procedure GetResponseContentXML(): text
    begin
        exit(XmlResponseText);
    end;

    procedure GetResponseContentJson(): text
    begin
        exit(JsonResponseText);
    end;

    procedure GetXmlDocument(): XmlDocument
    begin
        exit(XmlDoc);
    end;

    procedure GetJsonObject(): JsonObject
    begin
        exit(JsonObj);
    end;

    procedure GetUrlEncode(data: Text): text
    var
        TypeHelper: codeunit "Type Helper";
        dataEncode: text;
        i: Integer;
        aux: text;
    begin
        for i := 1 to StrLen(data) do begin
            aux := CopyStr(data, i, 1);
            TypeHelper.UrlEncode(aux);
            dataEncode += aux;
        end;

        exit(dataEncode);
    end;

    procedure ConvertXMLToJson(
        XmlText: text;
        var JSonText: Text)
    var
        JSonMgt: Codeunit "JSON Management";
    begin
        JSonText := JSonMgt.XMLTextToJSONText(XmlText);
    end;

    procedure ConvertJsonToXML(
        JsonText: text;
        var XmlTxt: Text)
    var
        JSonMgt: Codeunit "JSON Management";
    begin
        XmlTxt := JSonMgt.JSONTextToXMLText(JsonText, 'root');
    end;

    procedure GetJsonValueAsText(Property: Text) Value: text
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(Property, JsonValue) then
            exit;
        Value := JsonValue.AsText;
    end;

    procedure GetJsonValue(Property: Text; var JsonValue: JsonValue): Boolean
    var
        JsonToken: JsonToken;
    begin
        if not JsonObj.Get(Property, JsonToken) then
            exit;
        JsonValue := JsonToken.AsValue();
        exit(true);
    end;

    procedure GetXmlBufferResponse(var xmlBuffer: record "XML Buffer" temporary)
    begin
        xmlBuffer.LoadFromText(XmlResponseText);
    end;

    procedure GetJsonlBufferResponse(var jsonBuffer: record "JSON Buffer" temporary)
    begin
        jsonBuffer.ReadFromText(JsonResponseText);
    end;

    procedure GetStreams(var ResponseInStream: InStream; var ResponseOutStream: OutStream)
    var
        TempBlob: codeunit "Temp Blob";
    begin
        TempBlob.CreateInStream(ResponseInStream);
        ResponseMessageContent.ReadAs(ResponseInStream);
        TempBlob.CreateOutStream(ResponseOutStream);
        CopyStream(ResponseOutStream, ResponseInStream);
    end;

    procedure DownloadResponseToFile()
    var
        ResponseInStream: InStream;
        ResponseOutStream: OutStream;
        Filename: Text;
        FilenameLbl: Label 'ResponseText.txt', Locked = true;
    begin
        GetStreams(ResponseInStream, ResponseOutStream);
        Filename := FilenameLbl;
        DownloadFromStream(ResponseInStream, '', '', '', Filename);
    end;

    procedure HttpStatusCode(): integer
    begin
        exit(ResponseMessage.HttpStatusCode());
    end;

    procedure IsSuccessStatusCode(): Boolean
    begin
        exit(ResponseMessage.IsSuccessStatusCode());
    end;

    local procedure GetAccessToken(
        ClientId: text;
        ClientSecret: text;
        RedirectURL: text;
        OAuthAuthorityURL: Text;
        ResourceURL: text;
        PrompInteraction: enum "Prompt Interaction"): text
    var
        OAuth2: Codeunit OAuth2;
        Scope: list of [Text];
        AccessToken: text;
        AuthCodeError: text;
    begin
        Scope.Add(ResourceURL);

        OAuth2.AcquireAuthorizationCodeTokenFromCache(
            ClientId,
            ClientSecret,
            RedirectURL,
            OAuthAuthorityURL,
            Scope,
            AccessToken);

        if AccessToken = '' then
            OAuth2.AcquireTokenByAuthorizationCode(
                ClientId,
                ClientSecret,
                OAuthAuthorityURL,
                RedirectURL,
                Scope,
                PrompInteraction,
                AccessToken,
                AuthCodeError);

        if (AccessToken = '') or (AuthCodeError <> '') then
            Error(AuthCodeError);

        exit(AccessToken);

    end;
}