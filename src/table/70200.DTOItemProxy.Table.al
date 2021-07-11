table 70200 "DTOItemProxy"
{
    Caption = 'Item Proxy', comment = 'Integración Producto';
    DataClassification = CustomerContent;
    DataCaptionFields = "Item No.", Description;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.', Comment = 'No. movimiento';
            Editable = false;
        }
        field(2; Transfered; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Transfered', Comment = 'Traspasado';
            Editable = false;
        }
        field(3; HasError; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Has error', Comment = 'Error';
            Editable = false;
        }
        field(4; "Error Description"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Error Description', Comment = 'Descripción error';
        }

        field(10; "Item No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', Comment = 'No. producto';
        }

        field(11; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'Descripción';
        }
        field(12; "Next Counting Start Date"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Next Counting Start Date', Comment = 'Fecha de inicio de conteo siguiente';
        }
        field(13; "Created by User"; Text[80])
        {
            Caption = 'Created by User', Comment = 'Creado por';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }

        field(14; "Modified by User"; Text[80])
        {
            Caption = 'Modified by User', Comment = 'Modificado por';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Security ID" = field(SystemModifiedBy)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ItemProxy: Record DTOItemProxy;
    begin
        if ItemProxy.FindLast() then
            Rec."Entry No." := ItemProxy."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;

    procedure SetErrorDescription(ErrorDescription : Text)
    var
        OutStr : OutStream;
    begin
        Clear("Error Description");
        Rec."Error Description".CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(ErrorDescription);
        Modify();
    end;

    procedure GetErrorDescription() : Text;
    var
        TypeHelper : Codeunit "Type Helper";
        InStr : InStream;
    begin
        CalcFields("Error Description");
        "Error Description".CreateInStream(InStr, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStr, TypeHelper.LFSeparator()));
    end;

    procedure ImportFromCSVBuffer()
    var
        Filename: Text;
        InStr: InStream;
        CSVBuffer: Record "CSV Buffer" temporary;
        ItemProxy: record DTOItemProxy;
    begin
        if not UploadIntoStream('', '', '', Filename, InStr) then
            exit;

        CSVBuffer.LoadDataFromStream(InStr, ';');

        CSVBuffer.SetCurrentKey("Line No.", "Field No.");
        CSVBuffer.SetFilter("Line No.", '<>1');

        if not CSVBuffer.FindSet() then
            exit;

        repeat
            // Inicializamos nuevo registro
            clear(ItemProxy);
            ItemProxy.Init();
            ItemProxy.Insert(true);

            CSVBuffer.SetRange("Line No.", CSVBuffer."Line No.");
            repeat
                // Tratamos todos los campos del registro
                case CSVBuffer."Field No." of
                    1:
                        ItemProxy.Validate("Item No.", CopyStr(CSVBuffer.Value, 1, MaxStrLen(ItemProxy."Item No.")));

                    2:
                        ItemProxy.Validate(Description, CopyStr(CSVBuffer.Value, 1, MaxStrLen(ItemProxy.Description)));

                    3:
                        ItemProxy.Validate("Next Counting Start Date", CopyStr(CSVBuffer.Value, 1, MaxStrLen(ItemProxy."Next Counting Start Date")));
                end;

            until CSVBuffer.Next() = 0;
            CSVBuffer.SetRange("Line No.");

            // Modificamos el registro con los campos leidos
            ItemProxy.Modify(true);

        until CSVBuffer.Next() = 0;
    end;

    procedure ImportWithExcelBuffer()
    var
        ExcelBuffer: record "Excel Buffer" temporary;
        ItemProxy: record DTOItemProxy;
        InStr: InStream;
        Filename: text;
        RowNo: Integer;
        ColumnNo: Integer;
        Rows: Integer;
        SheetName: text;
    begin
        if not UploadIntoStream('', '', '', Filename, InStr) then
            exit;

        SheetName := ExcelBuffer.SelectSheetsNameStream(InStr);

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(InStr, SheetName);
        ;
        ExcelBuffer.ReadSheet();

        ExcelBuffer.SetCurrentKey("Row No.", "Column No.");
        if not ExcelBuffer.FindSet() then
            exit;

        repeat
            ItemProxy.Init();
            ItemProxy.Insert(true);

            ExcelBuffer.SetRange("Row No.", ExcelBuffer."Row No.");
            repeat
                case ExcelBuffer."Column No." of
                    1:
                        ItemProxy.Validate("Item No.", CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(ItemProxy."Item No.")));
                    2:
                        ItemProxy.Validate(Description, CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(ItemProxy.Description)));
                    3:
                        ItemProxy.Validate("Next Counting Start Date", CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(ItemProxy."Next Counting Start Date")));
                end
            until ExcelBuffer.Next() = 0;
            ExcelBuffer.SetRange("Row No.");

            ItemProxy.Modify(true);
        until ExcelBuffer.Next() = 0;

    end;

    procedure ImportFromXMLPort_VariantText()
    begin
        Xmlport.Run(Xmlport::DTOItemProxyVarText, false, true);
    end;

    procedure ImportFromXMLPort_FixedText()
    begin
        Xmlport.Run(Xmlport::DTOItemProxyFixedText, false, true);
    end;

    procedure ImportFromXMLPort_Xml()
    begin
        Xmlport.Run(Xmlport::DTOItemProxyXML, false, true);
    end;

    procedure ImportFromXMLDocument()
    var
        InStr: InStream;
        Filename: text;
        XMLDoc: XmlDocument;
        XMLItemList: XmlNodeList;
        Node, SubNode : XmlNode;
        ItemProxy: record DTOItemProxy;
    begin
        if not UploadIntoStream('', '', '', Filename, InStr) then
            exit;

        if not XmlDocument.ReadFrom(InStr, XMLDoc) then
            exit;

        if not XMLDoc.SelectNodes('//Items/Item', XMLItemList) then
            exit;

        if XMLItemList.Count = 0 then
            exit;

        foreach Node in XmlItemList do begin
            ItemProxy.Init();
            ItemProxy.Insert(true);

            if Node.SelectSingleNode('./ItemNo', SubNode) then
                ItemProxy.Validate("Item No.", CopyStr(SubNode.AsXmlElement().InnerText(), 1, MaxStrLen(ItemProxy."Item No.")));

            if Node.SelectSingleNode('./Description', SubNode) then
                ItemProxy.Validate(Description, CopyStr(SubNode.AsXmlElement().InnerText(), 1, MaxStrLen(ItemProxy.Description)));

            if Node.SelectSingleNode('./NextCountingStartDate', SubNode) then
                ItemProxy.Validate("Next Counting Start Date", CopyStr(SubNode.AsXmlElement().InnerText(), 1, MaxStrLen(ItemProxy."Next Counting Start Date")));

            ItemProxy.Modify(true);
        end;
    end;

    procedure ImportFromJSONObject()
    var
        InStr: InStream;
        Filename: Text;
        JItems, JItem : JsonObject;
        JTValues, JValue, JToken : JsonToken;
        ItemProxy: record DTOItemProxy;
    begin
        if not UploadIntoStream('', '', '', Filename, InStr) then
            exit;

        if not JItems.ReadFrom(InStr) then
            exit;

        if not JItems.Get('value', JTValues) then
            exit;

        foreach JValue in JTValues.AsArray() do begin
            JItem := JValue.AsObject();

            ItemProxy.Init();
            ItemProxy.Insert(true);

            if JItem.Get('No', JToken) then
                ItemProxy.Validate("Item No.", CopyStr(JToken.AsValue().AsCode(), 1, MaxStrLen(ItemProxy."Item No.")));

            if JItem.Get('Description', JToken) then
                ItemProxy.Validate(Description, CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ItemProxy.Description)));

            ItemProxy.Modify(true);
        end;
    end;

    procedure Export_ManualText()
    var
        ItemProxy: Record DTOItemProxy;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        OutText: text;
        InStr: InStream;
        Filename: text;
    begin
        TempBlob.CreateOutStream(OutStr);

        ItemProxy.SetCurrentKey("Entry No.");
        ItemProxy.SetRange(Transfered, false);

        if not ItemProxy.FindSet() then
            exit;

        repeat
            OutText := StrSubstNo('%1;%2;%3',
                ItemProxy."Item No.",
                ItemProxy.Description,
                ItemProxy."Next Counting Start Date");
            OutStr.WriteText(OutText);
            OutStr.WriteText();
        until ItemProxy.Next() = 0;

        Filename := 'Exportacion manual Items.csv';
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, '', '', '', Filename);
    end;

    procedure ExportWithCSVBuffer()
    var
        CSVBuffer: record "CSV Buffer" temporary;
        InStr: InStream;
        ItemProxy: record DTOItemProxy;
        LineNo: Integer;
        TempBlob: codeunit "Temp Blob";
        Filename: text;
    begin
        ItemProxy.SetCurrentKey("Entry No.");
        ItemProxy.SetRange(Transfered, false);

        if not ItemProxy.FindSet() then
            exit;

        repeat
            LineNo += 1;
            CSVBuffer.InsertEntry(LineNo, 1, ItemProxy."Item No.");
            CSVBuffer.InsertEntry(LineNo, 2, ItemProxy.Description);
            CSVBuffer.InsertEntry(LineNo, 3, ItemProxy."Next Counting Start Date");
        until ItemProxy.Next() = 0;

        CSVBuffer.SaveDataToBlob(TempBlob, ';');
        TempBlob.CreateInStream(InStr);
        Filename := 'Items Exported.csv';

        DownloadFromStream(InStr, '', '', '', Filename);
    end;

    procedure ExportWithExcelBuffer()
    var
        ExcelBuffer: record "Excel Buffer" temporary;
        ItemProxy: record DTOItemProxy;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        SheetName: label 'Items', Locked = true;
        RowNo: Integer;
        Filename: text;
    begin
        ExcelBuffer.CreateNewBook(SheetName);

        ItemProxy.SetCurrentKey("Entry No.");
        ItemProxy.SetRange(Transfered, false);

        if not ItemProxy.FindSet() then
            exit;

        repeat
            RowNo += 1;
            ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 1, ItemProxy."Item No.", false, false, false);
            ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 2, ItemProxy.Description, false, false, false);
            ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 3, ItemProxy."Next Counting Start Date", false, false, false);
        until ItemProxy.Next() = 0;

        ExcelBuffer.WriteSheet(SheetName, CompanyName(), UserId());
        ExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(OutStr);
        ExcelBuffer.SaveToStream(OutStr, true);
        TempBlob.CreateInStream(InStr);

        Filename := 'Item.xlsx';
        DownloadFromStream(InStr, '', '', '', Filename);
    end;

    procedure ExportWithXMLPort_VariantText()
    begin
        Xmlport.run(Xmlport::DTOItemProxyVarText, false, false, rec);
    end;

    procedure ExprotWithXMLPort_FixedText()
    begin
        Xmlport.run(Xmlport::DTOItemProxyFixedText, false, false, rec);
    end;

    procedure ExportWithXMLPort_XML()
    begin
        Xmlport.Run(Xmlport::DTOItemProxyXML, false, false, rec);
    end;

    procedure ExportWithXMLDocument()
    var
        TempBlob: Codeunit "Temp Blob";
        XMLDoc: XmlDocument;
        XMLDec: XmlDeclaration;
        InsStr: InStream;
        Filename: text;
        XMLItems, XMLItem : XmlElement;
        OutStr: OutStream;

        ItemProxy: record DTOItemProxy;
    begin
        ItemProxy.SetCurrentKey("Entry No.");
        ItemProxy.SetRange(Transfered, false);

        if not ItemProxy.FindSet() then
            exit;

        XMLDoc := XmlDocument.Create();
        // XMLDec := XmlDeclaration.Create('1.0', 'UTF-16', '');
        // XMLDoc.SetDeclaration(XMLDec);

        XMLItems := XmlElement.Create('Items');

        repeat
            clear(XMLItem);
            XMLItem := XmlElement.Create('Item');
            XMLItem.Add(AddField('ItemNo', ItemProxy."Item No."));
            XMLItem.Add(AddField('Description', ItemProxy.Description));
            XMLItem.Add(AddField('NextCountingStartDate', ItemProxy."Next Counting Start Date"));
            XMLItems.Add(XMLItem);
        until ItemProxy.Next() = 0;

        XMLDoc.Add(XMLItems);

        TempBlob.CreateOutStream(outStr, TextEncoding::UTF16);
        XMLDoc.WriteTo(OutStr);
        TempBlob.CreateInStream(InsStr, TextEncoding::UTF16);

        Filename := 'Items XMLDocument.xml';
        DownloadFromStream(InsStr, '', '', '', Filename);
    end;

    procedure ExportWithJSONObject()
    var
        ItemProxy: Record DTOItemProxy;
        JAValue: JsonArray;
        JItems, JItemProxy : JsonObject;

        TempBlob: Codeunit "Temp Blob";
        IntStr: InStream;
        OutStr: OutStream;
        Filename: text;
    begin
        ItemProxy.SetRange(Transfered, false);
        if not ItemProxy.FindSet() then
            exit;

        JItemProxy.Add('No', '');
        JItemProxy.Add('Description', '');

        repeat
            JItemProxy.Replace('No', ItemProxy."Item No.");
            JItemProxy.Replace('Description', ItemProxy.Description);
            JAValue.Add(JItemProxy);
        until ItemProxy.Next() = 0;

        JItems.Add('value', JAValue);

        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF16);
        JItems.WriteTo(OutStr);
        TempBlob.CreateInStream(IntStr, TextEncoding::UTF16);

        Filename := 'Items JSonObject.json';
        DownloadFromStream(IntStr, '', '', '', Filename);
    end;

    local procedure AddField(Name: Text; Value: Text): XmlElement;
    var
        e: XmlElement;
    begin
        e := XmlElement.Create(Name);
        e.Add(Value);
        exit(e);
    end;


    procedure CreateItem(
        ItemProxy: record DTOItemProxy)
    var
        CreateItemFromProxy: Codeunit DTOCreateItemsFromProxy;
    begin
        ClearLastError();
        if not CreateItemFromProxy.Run(ItemProxy) then begin
            ItemProxy.Validate(HasError, true);
            ItemProxy.SetErrorDescription(GetLastErrorText());
        end else begin
            ItemProxy.Validate(Transfered, true);
            ItemProxy.Validate(HasError, false);
            ItemProxy.SetErrorDescription('');
        end;

        ItemProxy.Modify(true);
        Commit();
    end;
}