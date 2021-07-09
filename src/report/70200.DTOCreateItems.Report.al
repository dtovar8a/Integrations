report 70200 "DTOCreateItems"
{
    Caption = 'Create Items', Comment = 'Crear productos';
    UsageCategory = Tasks;
    ApplicationArea = All;
    UseRequestPage = false;
    ProcessingOnly = true;
    
    dataset
    {
        dataitem(DTOItemProxy; DTOItemProxy)
        {
            DataItemTableView = where(Transfered = filter(false));

            trigger OnAfterGetRecord()
            begin
                DTOItemProxy.CreateItem(DTOItemProxy);
            end;
        }
    }
}