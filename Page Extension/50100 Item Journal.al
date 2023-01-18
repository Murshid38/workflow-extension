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

    actions
    {
        addbefore("F&unctions")
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalLine)
                    {
                        Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                        Image = SendApprovalRequest;
                        Caption = 'Send Selected Journal Lines';
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedCategory = Category8;
                        PromotedOnly = true;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ItemJnlLine: Record "Item Journal Line";
                            JournalBatchName: Code[20];
                        begin
                            GetCurrentlySelectedLines(ItemJnlLine);
                            if ApprovalsMgmt.CheckItemJnlLineApprovalsWorkflowEnable(ItemJnlLine) then
                                ApprovalsMgmt.TrySendItemJnlLineApprovalRequests(ItemJnlLine);
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                        Image = CancelApprovalRequest;
                        Caption = 'Cancel Selected Journal Lines';
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedCategory = Category8;
                        PromotedOnly = true;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ItemJnlLine: Record "Item Journal Line";
                            JournalBatchName: Code[20];
                        begin
                            GetCurrentlySelectedLines(ItemJnlLine);
                            ApprovalsMgmt.TryCancelItemJnlLineApprovalRequests(ItemJnlLine);
                        end;
                    }
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if OpenApprovalEntriesExist then
                            ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    var
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt. Sriq";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    procedure GetCurrentlySelectedLines(var ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(ItemJnlLine);
        exit(ItemJnlLine.FindSet);
    end;
}