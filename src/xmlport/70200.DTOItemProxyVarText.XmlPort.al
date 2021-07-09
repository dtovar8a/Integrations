xmlport 70200 "DTOItemProxyVarText"
{
    Direction = Both;
    Caption = 'Item Proxy - Variable Text', Comment = 'Integración productos - Texto variable';
    UseRequestPage = false;
    Format = VariableText;
    FieldSeparator = ';';
    FieldDelimiter = '';
    TextEncoding = UTF8;

    schema
    {
        textelement(root)
        {
            tableelement(DTOItemProxy; DTOItemProxy)
            {
                fieldelement(ItemNo; DTOItemProxy."Item No.")
                {
                }
                fieldelement(Description; DTOItemProxy.Description)
                {
                }
                fieldelement(NextCountingStartDate ; DTOItemProxy."Next Counting Start Date")
                {
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