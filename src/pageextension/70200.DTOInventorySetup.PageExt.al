pageextension 70200 "DTOInventorySetup" extends "Inventory Setup"
{
    layout
    {
        addlast(content)
        {
            group(Integration)
            {
                Caption = 'Integration', Comment = 'Integración';
                field(DTOIItemSW; Rec.DTOIItemSW)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}