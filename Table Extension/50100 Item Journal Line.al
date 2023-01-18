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

    trigger OnBeforeModify()
    begin
        CheckStatus();
    end;

    trigger OnDelete()
    begin
        CheckStatus();
    end;

    procedure CheckStatus()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt. Sriq";
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.Copy(Rec);
        if ApprovalsMgmt.IsItemJnlLineApprovalsWorkflowEnable(ItemJnlLine) then
            Rec.TestField("Approval Status", "Approval Status"::Open)
    end;
}
