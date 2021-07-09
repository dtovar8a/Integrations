page 70203 "DTOWebServiceConnectionCard"
{
    Caption = 'Web Service Connection', Comment = 'Conexión Servicio Web';
    PageType = Card;
    SourceTable = DTOWebServiceConnection;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'General';
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Auth Type"; Rec."Auth Type")
                {
                    ApplicationArea = All;
                    
                    trigger OnValidate()
                    begin
                        ControlDesign();
                    end;
                }    
                field(Enabled; Rec.Enabled)            
                {
                    ApplicationArea = All;
                }
            }

            group(BasicAuthGroup)
            {
                Caption = 'Basic Auth', Comment = 'Autenticación "Basic"';
                Visible = BasicAuthVisible;

                field(User; Rec.User)
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
            }

            group(BearerAuthGroup)
            {
                Caption = 'Bearer Auth', Comment = 'Autenticación "Bearer"';
                Visible = BearerAuthVisible;

                field(Token; Rec.Token)
                {
                    ApplicationArea = all;
                    ExtendedDatatype = Masked;
                }
            }
            group(OAuth2Group)
            {
                Caption = 'OAuth2 Auth', Comment = 'Autenticación "OAuth2"';
                Visible = OAuth2AuthVisible;

                field("Grand Type"; Rec."Grand Type")
                {
                    ApplicationArea = All;
                }
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                }
                field("Cliente Secret"; Rec."Cliente Secret")
                {
                    ApplicationArea = All;
                }
                field(Resource; Rec.Resource)
                {
                    ApplicationArea = All;
                }
                field("Token URL"; Rec."Token URL")
                {
                    ApplicationArea = All;
                }
            }
            group(CertificatedAuthGroup)
            {
                Caption = 'Certificated Auth', Comment = 'Autenticación certificada';
                Visible = CertificatedAuthVisible;

                field("Certificated Load"; Rec."Certificated Load")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        Filename : text;
                    begin
                        Rec.Validate("Certificated Load", UploadIntoStream('', '', '', Filename, InStr));
                        Rec.Certificate.CreateInStream(InStr);    
                        ControlDesign();
                    end;
                }
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        ControlDesign();
    end;

    var
        InStr : InStream;
        BasicAuthVisible : Boolean;
        BearerAuthVisible : Boolean;
        OAuth2AuthVisible : Boolean;
        CertificatedAuthVisible : Boolean;
        CertificatedPasswordVisible : Boolean;

    local procedure ControlDesign()
    begin
        BasicAuthVisible := (Rec."Auth Type" = Enum::DTOAuthType::Basic);
        BearerAuthVisible := (Rec."Auth Type" = Enum::DTOAuthType::Bearer);
        OAuth2AuthVisible := (Rec."Auth Type" = Enum::DTOAuthType::OAuth2);
        CertificatedAuthVisible := (Rec."Auth Type" = Enum::DTOAuthType::Certificated);
        CertificatedPasswordVisible := (Rec."Certificated Load");

        Rec.EmptyFieldsAccordingToTypeAuthentication();
    end;
}
