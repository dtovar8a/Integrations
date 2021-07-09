xmlport 70202 "DTOItemProxyXML"
{
    Direction = Both;
    Caption = 'Integration Products - XML', Comment = 'Integración productos - XML';
    UseRequestPage = false;
    Format = Xml;

    schema
    {
        textelement(Items)
        {
            XmlName = 'Items';
            tableelement(DTOItemProxy; DTOItemProxy)
            {
                XmlName = 'Item';
                MinOccurs = Once;
                MaxOccurs = Unbounded;

                fieldelement(ItemNo; DTOItemProxy."Item No.")
                {
                }
                fieldelement(Description; DTOItemProxy.Description)
                {
                }
                fieldelement(NextCountingStartDate ; DTOItemProxy."Next Counting Start Date")
                {
                }
            }
        }
    }
}