table 70201 "DTOWebServiceConnection"
{
    Caption = 'Service Web Setup', Comment = 'Configuración Servicios Web';
    DataClassification = CustomerContent;
    LookupPageId = "DTOWebServiceConections";
    DrillDownPageId = "DTOWebServiceConections";
    DataCaptionFields = Code, Description;
    
    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', Comment = 'Código';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'Descripción';
        }
        field(3; Enabled; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enabled', Comment = 'Habilitado';
        }
        field(10; "Auth Type"; Enum DTOAuthType)
        {
            DataClassification = CustomerContent;
            Caption = 'Auth Type', Comment = 'Tipo autenticación';
        }
        field(20; User; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User', Comment = 'Usuario';
        }
        field(21; Password; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Password', Comment = 'Contraseña';
        }
        field(30; Token; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Token', Locked = true;
        }
        field(40; "Client Id"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Id', Locked = true;
        }
        field(41; "Cliente Secret"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cliente Secret', Locked = true;
        }
        field(42; "Grand Type"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Secret', Locked = true;
        }
        field(43; Resource; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource', Locked = true;
        }
        field(44; "Token URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Token URL', Locked = true;
        }
        field(50; "Certificated Load"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Certificated Load', Comment = 'Certificado cargado';
            Editable = false;
        }

        field(51; "Certificated Password"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Certificated Password', Comment = 'Contraseña';
        }
        field(52; "Certificate"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Certificate', Comment = 'Certificado';
        }
    }
    
    keys
    {
        key(PK; code)
        {
            Clustered = true;
        }
    } 

    procedure EmptyFieldsAccordingToTypeAuthentication()
    begin
        if "Auth Type" <> Enum::DTOAuthType::Basic then begin
            Rec.Validate(User, '');
            Rec.Validate(Password, '');
        end;

        if "Auth Type" <> Enum::DTOAuthType::Bearer then
            Rec.Validate(Token, '');

        if "Auth Type" <> Enum::DTOAuthType::OAuth2 then begin
            Rec.Validate("Grand Type", '');
            Rec.Validate("Client Id", '');
            Rec.Validate("Cliente Secret", '');
            Rec.Validate(Resource, '');
            Rec.Validate("Token URL", '');
        end;

        if "Auth Type" <> Enum::DTOAuthType::Certificated then begin
            Rec.Validate("Certificated Load", false);
            Rec.Validate("Certificated Password", '');
            Clear(Rec.Certificate);
        end;

        if "Auth Type" = Enum::DTOAuthType::OAuth2 then
            Rec.Validate("Grand Type", 'client_credentials');
    end;
}