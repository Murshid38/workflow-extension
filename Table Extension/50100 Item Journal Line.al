tableextension 50100 ItemJournalLine extends "Item Journal Line"
{
    fields
    {
        field(50100; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval,Released';
            Editable = false;
        }
    }
}
