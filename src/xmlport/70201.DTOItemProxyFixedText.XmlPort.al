xmlport 70201 "DTOItemProxyFixedText"
{
    Direction = Both;
    Caption = 'XMLPort Item Proxy', Comment = 'XMPPort Integración productos';
    UseRequestPage = false;
    Format = FixedText;
    TextEncoding = UTF8;

    schema
    {
        textelement(root)
        {
            tableelement(DTOItemProxy; DTOItemProxy)
            {
                fieldelement(ItemNo; DTOItemProxy."Item No.")
                {
                    Width = 20;
                }
                fieldelement(Description; DTOItemProxy.Description)
                {
                    Width = 100;
                }
                fieldelement(NextCountingStartDate ; DTOItemProxy."Next Counting Start Date")
                {
                    Width = 10;
                }

                trigger OnBeforeInsertRecord()
                begin
                    if not Head then begin
                        head := true;
                        currXMLport.Skip();
                    end;
                end;
            }
        }
    }

    var
        Head : Boolean;
}