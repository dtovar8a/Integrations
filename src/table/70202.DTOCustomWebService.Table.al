table 70202 "DTOCustomWebService"
{
    Caption = 'Custom Web Services', Comment = 'Servicios Web personalizados';
    DataClassification = CustomerContent;
    LookupPageId = "DTOCustomsWebServices";
    DrillDownPageId = "DTOCustomsWebServices";
    
    fields
    {
        field(1; Code; code[10])
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
        field(11; "Request URL"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Request URL', Comment = 'URL de solicitud';
        }
        field(12; "Connection Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Connection Code', Comment = 'Cód. conexión';
            TableRelation = DTOWebServiceConnection;
        }
    }
    
    keys
    {
        key(FK; Code)
        {
            Clustered = true;
        }
    }
}