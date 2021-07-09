page 70200 "DTOItemProxy"
{
    Caption = 'Item Proxy', Comment = 'Integración Productos';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DTOItemProxy;
    SourceTableView = where(Transfered = filter(false));

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
                    ToolTip = '20 Alphanumeric chars', Comment = '20 carácteres alfanuméricos';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = '100 Alphanumeric chars', Comment = '100 carácteres alfanuméricos';
                }
                field("Next Counting Start Date"; Rec."Next Counting Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = '10 Alphanumeric chars (dd/mm/yyyy)', Comment = '10 carácteres alfanuméricos (dd/mm/aaaa)';
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
            group(Import)
            {
                Caption = 'Import', Comment = 'Importaciones';

                action(ImportWithCSVBuffer)
                {
                    Caption = 'Import with CSV Buffer', Comment = 'Importar con CSV Buffer';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction();
                    begin
                        Rec.ImportFromCSVBuffer();
                    end;
                }
                action(ImportWithExcelBuffer)
                {
                    Caption = 'Import with Excel Buffer', Comment = 'Importar con Excel Buffer';
                    ApplicationArea = All;
                    Image = ImportExcel;

                    trigger OnAction()
                    begin
                        Rec.ImportWithExcelBuffer();
                    end;
                }
                action(ImportWitdXmlPortVarText)
                {
                    Caption = 'Import with XMLPort (Variable Text)', Comment = 'Importar con XMLPort (Texto variable)';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFromXMLPort_VariantText();
                    end;
                }

                action(ImportWitdXmlPortFixedText)
                {
                    Caption = 'Import with XMLPort (Fixed Text)', Comment = 'Importar con XMLPort (Texto Fijo)';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFromXMLPort_FixedText();
                    end;
                }
                action(ImporttWithXMLPortXmlFormat)
                {
                    Caption = 'Import with XMLPort (XML format)', Comment = 'Importar con XMLPort (Formato XML)';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFromXMLPort_Xml();
                    end;
                }
                action(ImportWithXMLDocument)
                {
                    Caption = 'Import with XMLDocument (XML Format)', Comment = 'Importar con XMLDocument (Formato XML)';
                    ApplicationArea = all;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFromXMLDocument();
                    end;
                }
                action(ImportWithJSONObject)
                {
                    Caption = 'Import with JSONObject (JSON Format)', Comment = 'Importar con JSONObject (Formato JSON)';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFromJSONObject();
                    end;
                }
            }

            group(Export)
            {
                Caption = 'Export', Comment = 'Exportaciones';

                action(ManualExport)
                {
                    Caption = 'Manual Export', Comment = 'Exportación manual';
                    ApplicationArea = all;
                    Image = ExportFile;

                    trigger OnAction()
                    begin
                        Rec.Export_ManualText();
                    end;
                }
                action(ExportWithCSVBuffer)
                {
                    Caption = 'Export with CSV Buffer', Comment = 'Exportar con CSV Buffer';
                    ApplicationArea = All;
                    Image = ExportFile;

                    trigger OnAction();
                    begin
                        Rec.ExportWithCSVBuffer();
                    end;
                }
                action(ExportWithExcelBuffer)
                {
                    Caption = 'Export with Excel Buffer', Comment = 'Exportar con Excel Buffer';
                    ApplicationArea = All;
                    Image = ExportToExcel;

                    trigger OnAction()
                    begin
                        Rec.ExportWithExcelBuffer();
                    end;
                }
                action(ExportWithXMLPortVarText)
                {
                    Caption = 'Export with XMLPort (Variable Text)', Comment = 'Exportar con XMLPort (Texto Variable)';
                    ApplicationArea = All;
                    Image = ExportFile;

                    trigger OnAction()
                    begin
                        Rec.ExportWithXMLPort_VariantText();
                    end;
                }
                action(ExportWithXMLPortFixedText)
                {
                    Caption = 'Export with XMLPort (Text Fixed)', Comment = 'Exportar con XMLPort (Texto Fijo)';
                    ApplicationArea = All;
                    Image = ExportFile;

                    trigger OnAction()
                    begin
                        Rec.ExprotWithXMLPort_FixedText();
                    end;
                }
                action(ExportWithXMLPortXmlFormat)
                {
                    Caption = 'Export with XMLPort (XML format)', Comment = 'Exportar con XMLPort (Formato XML)';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.ExportWithXMLPort_XML();
                    end;
                }
                action(ExportWithXMLDocument)
                {
                    Caption = 'Export with XMLDocument (XML Format)', Comment = 'Exportar con XMLDocument (Formato XML)';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.ExportWithXMLDocument();
                    end;
                }

                action(ExportWithJSONObject)
                {
                    Caption = 'Export with JSONObject (JSON Format)', Comment = 'Exportar con JSONObject (Formato JSON)';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.ExportWithJSONObject();
                    end;
                }
            }

            group(WebService)
            {
                Caption = 'Web Service', Comment = 'Servicio web';

                action(ImprotFromWebService)
                {
                    ApplicationArea = All;
                    Caption = 'Import from Web Service', Comment = 'Importar desde Servicio Web';
                    Image = Web;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::DTOImportItemsFromWS, false, false);
                    end;
                }
            }
            group(CreateProduct)
            {
                Caption = 'Create Product', Comment = 'Crear Producto';

                action(CreateOnlySelectedProduct)
                {
                    Caption = 'Create Only Selected Product', Comment = 'Crear sólo producto seleccionado';
                    ApplicationArea = All;
                    Image = Create;

                    trigger OnAction()
                    var
                        CreateItemFromProxy: Codeunit DTOCreateItemsFromProxy;
                    begin
                        CreateItemFromProxy.Run(Rec);
                        Rec.Validate(Transfered, true);
                        Rec.Modify(true);
                    end;
                }

                action(CreateSelectedProducts)
                {
                    Caption = 'Create Selected Products', Comment = 'Crear productos seleccionados';
                    ToolTip = 'If any error occurs in a record, all the created products are reversed', Comment = 'Si se produce algún error en algún registro, se revierten todos los productos creados';
                    ApplicationArea = All;
                    Image = Create;

                    trigger OnAction()
                    var
                        ItemProxy: record DTOItemProxy;
                        CreateItemFromProxy: Codeunit DTOCreateItemsFromProxy;
                    begin
                        CurrPage.SetSelectionFilter(ItemProxy);

                        if not ItemProxy.FindSet() then
                            exit;

                        repeat
                            CreateItemFromProxy.Run(ItemProxy);
                            ItemProxy.Validate(Transfered, true);
                            ItemProxy.Modify(true);
                        until ItemProxy.Next() = 0;
                    end;
                }

                action(CreateSelectedProdutsWithErrorControl)
                {
                    Caption = 'Create selected products with error management', Comment = 'Crear productos seleccionados con gestión de errores';
                    ToolTip = 'If error occurs in a record, it is marked as "error" and continuous with the process.', Comment = 'Si se produce error en algún registro, se marca como "Error" y continua con el proceso.';
                    ApplicationArea = all;
                    Image = Create;

                    trigger OnAction()
                    var
                        ItemProxy: record DTOItemProxy;
                        CreateItems: Report DTOCreateItems;
                    begin
                        InitControlTime();

                        CurrPage.SetSelectionFilter(ItemProxy);
                        CreateItems.SetTableView(ItemProxy);
                        CreateItems.RunModal();

                        StopControlTime();
                    end;
                }
            }
        }
    }

    local procedure InitControlTime()
    begin
        InitDateTime := CurrentDateTime;
    end;

    local procedure StopControlTime()
    var
        RunTimeLbl: label 'Run Time: %1', Comment = 'Segundos ejecución: %1';
    begin
        StopDateTime := CurrentDateTime;
        seconds := (StopDateTime - InitDateTime) / 1000;
        Message(RunTimeLbl, seconds);
    end;

    var
        InitDateTime: DateTime;
        StopDateTime: DateTime;
        seconds: Decimal;
        CreatedByUser: Text[80];
}