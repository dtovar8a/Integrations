report 70201 "DTOImportItemsFromWS"
{
    Caption = 'Import Items from Service Web', Comment = 'Importar productos desde Servicio web';
    UsageCategory = Tasks;
    ApplicationArea = All;
    UseRequestPage = false;
    ProcessingOnly = false;

    trigger OnPostReport()
    var
        ImportItemsFromSW : Codeunit DTOImportItemsFromSW;
    begin
        ClearLastError();
        if ImportItemsFromSW.Run() then;
    end;

}