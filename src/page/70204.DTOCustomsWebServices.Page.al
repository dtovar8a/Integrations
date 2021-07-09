page 70204 "DTOCustomsWebServices"
{
    Caption = 'Custom Web Services', Comment = 'Servicio Web personalizados';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "DTOCustomWebService";
    
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
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field("Connection Code"; Rec."Connection Code")
                {
                    ApplicationArea = All;
                }
                field("Request URL"; Rec."Request URL")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}