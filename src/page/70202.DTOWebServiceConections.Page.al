page 70202 "DTOWebServiceConections"
{
    Caption = 'Web Service Connections', Comment = 'Conexiones Servicios Web';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DTOWebServiceConnection;
    CardPageId = "DTOWebServiceConnectionCard";
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
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
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}