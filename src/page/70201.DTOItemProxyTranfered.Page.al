page 70201 "DTOItemProxyTranfered"
{
    Caption = 'Item Proxy Transferd', Comment = 'Integración Productos - Transferidos';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DTOItemProxy;
    SourceTableView = where(Transfered = filter(true));
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Transfered; Rec.Transfered)
                {
                    ApplicationArea = All;
                }
                field(HasError; Rec.HasError)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Next Counting Start Date"; Rec."Next Counting Start Date")
                {
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field("Created by User"; Rec."Created by User")
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field("Modified by User"; Rec."Modified by User")
                {
                    ApplicationArea = All;
                }                
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction();
                begin
                    
                end;
            }
        }
    }
}