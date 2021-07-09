tableextension 70200 "DTOInventorySetup" extends "Inventory Setup"
{
    fields
    {
        field(70000; DTOIItemSW; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Service Web', Comment = 'Servicio web Productos';
            TableRelation = "DTOCustomWebService";
        }
    }
}