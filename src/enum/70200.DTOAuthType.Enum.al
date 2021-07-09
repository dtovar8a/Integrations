enum 70200 "DTOAuthType"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Basic)
    {
        Caption = 'Basic', Locked = true;
    }
    value(2; Bearer)
    {
        Caption = 'Bearer', Locked = true;
    }
    value(3; OAuth2)
    {
        Caption = 'OAuth2', Locked = true;
    }
    value(4; Certificated)
    {
        Caption = 'Certificated', Comment = 'Certificado';
    }
}