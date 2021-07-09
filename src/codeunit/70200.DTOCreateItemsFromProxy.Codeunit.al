codeunit 70200 "DTOCreateItemsFromProxy"
{
    TableNo = DTOItemProxy;

    trigger OnRun()
    var
        Item : record Item;
    begin
        Item.Init();
        Item.Validate("No.", Rec."Item No.");
        Item.Insert(true);

        Item.Validate(Description, Rec.Description);
        Item.Validate("Next Counting End Date", ConvertTextToDate(Rec."Next Counting Start Date"));
        Item.Modify(true);
    end;
  
    local procedure ConvertTextToDate(TextDate : Text) : Date
    var
        ConvertedDate : Date;
    begin
        Evaluate(ConvertedDate, TextDate);
        exit(ConvertedDate);
    end;
}
