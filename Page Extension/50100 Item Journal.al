pageextension 50100 ItemJnl extends "Item Journal"
{
    PromotedActionCategories = 'New,Process,Report,Page,Post/Print,Line,Item,Request Approval,Approval';

    layout
    {
        addbefore("Document No.")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = all;
            }
        }
    }
}