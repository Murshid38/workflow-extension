codeunit 50100 "Approvals Mgmt. Sriq"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTransferOrderForApproval(var TransferHeader: Record "Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTransferOrderForApproval(var TransferHeader: Record "Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendRequisitionLineForApproval(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRequisitionLineForApproval(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendItemJnlLineForApproval(var ItemJnlLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelItemJnlLineForApproval(var ItemJnlLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFAForApproval(var FixedAsset: Record "Fixed Asset")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFAApprovalRequest(var FixedAsset: Record "Fixed Asset")
    begin
    end;

    procedure CheckTransOrderApprovalsWorkflowEnable(var TransferHeader: Record "Transfer Header"): Boolean
    begin
        if not IsTransOrderApprovalsWorkflowEnable(TransferHeader) then
            Error(NoWorkflowEnableErr);
        exit(true);
    end;

    procedure CheckFAApprovalsWorkflowEnable(var FixedAsset: Record "Fixed Asset"): Boolean
    begin
        if not IsFAApprovalsWorkflowEnable(FixedAsset) then
            Error(NoWorkflowEnableErr);
        exit(true);
    end;

    procedure ValidateTransferHeader(var TransferHeader: Record "Transfer Header"): Boolean
    var
        Text001: TextConst ENU = 'The transfer order %1 cannot be released because %2 and %3 are the same.';
        Text002: TextConst ENU = 'There is nothing to release for transfer order %1.';
        TransLine: Record "Transfer Line";
    begin

        TransferHeader.TestField("Transfer-from Code");
        TransferHeader.TestField("Transfer-to Code");
        if TransferHeader."Transfer-from Code" = TransferHeader."Transfer-to Code" then
            Error(Text001, TransferHeader."No.", TransferHeader.FIELDCAPTION("Transfer-from Code"), TransferHeader.FIELDCAPTION("Transfer-to Code"));
        if not TransferHeader."Direct Transfer" then
            TransferHeader.TestField("In-Transit Code")
        else begin
            TransferHeader.VerifyNoOutboundWhseHandlingOnLocation(TransferHeader."Transfer-from Code");
            TransferHeader.VerifyNoInboundWhseHandlingOnLocation(TransferHeader."Transfer-to Code");
        end;
        TransferHeader.TestField(Status, TransferHeader.Status::Open);
        TransLine.SetRange("Document No.", TransferHeader."No.");
        TransLine.SetFilter(Quantity, '<>0');
        if TransLine.IsEmpty then
            ERROR(Text002, TransferHeader."No.");
        exit(true);
    end;

    procedure IsTransOrderApprovalsWorkflowEnable(var TransferHeader: Record "Transfer Header"): Boolean
    begin
        // if TransferHeader."Approval Status" <> TransferHeader."Approval Status"::Open then
        // exit(false);
        exit(WorkflowManagment.CanExecuteWorkflow(TransferHeader, WorkflowEventHandling.RunWorkflowOnSendTransferOrderForApprovalCode));
    end;

    procedure IsFAApprovalsWorkflowEnable(var FixedAsset: Record "Fixed Asset"): Boolean
    begin
        exit(WorkflowManagment.CanExecuteWorkflow(FixedAsset, WorkflowEventHandling.RunWorkflowOnSendFAForApprovalCode));
    end;

    procedure PerformManualCheckAndRelease(var TransferHeader: Record "Transfer Header")
    begin
        if IsTransOrderApprovalsWorkflowEnable2(TransferHeader) then
            Error(Error0001);

        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(TransferHeader);
    end;

    procedure IsTransOrderApprovalsWorkflowEnable2(var TransferHeader: Record "Transfer Header"): Boolean
    begin
        // if TransferHeader."Approval Status" <> TransferHeader."Approval Status"::Open then
        //     exit(false);
        exit(WorkflowManagment.CanExecuteWorkflow(TransferHeader, WorkflowEventHandling.RunWorkflowOnSendTransferOrderForApprovalCode));
    end;

    procedure IsTransferHeaderPendingApproval(var TransferHeader: Record "Transfer Header")
    begin
        if IsTransOrderApprovalsWorkflowEnable2(TransferHeader) then
            Error(Error0002, TransferHeader."No.");

        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        TransferHeader: Record "Transfer Header";
        RequisitionLine: Record "Requisition Line";
        FixedAsset: Record "Fixed Asset";
    begin
        case RecRef.Number of
            Database::"Transfer Header":
                begin
                    RecRef.SetTable(TransferHeader);
                    ApprovalEntryArgument."Document No." := TransferHeader."No.";
                end;
            Database::"Requisition Line":
                begin
                    RecRef.SetTable(RequisitionLine);
                    ApprovalEntryArgument."Document No." := RequisitionLine."No.";
                end;
            Database::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    // ApprovalEntryArgument."Document No." := FixedAsset."Disposal Reference No.";
                end;
        end;
    end;

    procedure CheckRequisitionLineApprovalsWorkflowEnable(var RequisitionLine: Record "Requisition Line"): Boolean
    begin
        if not IsRequisitionLineApprovalsWorkflowEnable(RequisitionLine) then
            Error(NoWorkflowEnableErr);
        exit(true);
    end;

    procedure CheckItemJnlLineApprovalsWorkflowEnable(var ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        if not IsItemJnlLineApprovalsWorkflowEnable(ItemJnlLine) then
            Error(NoWorkflowEnableErr);
        exit(true);
    end;

    procedure IsRequisitionLineApprovalsWorkflowEnable(var RequisitionLine: Record "Requisition Line"): Boolean
    begin
        // if RequisitionLine."Approval Status" <> RequisitionLine."Approval Status"::Open then
        //     exit(false);
        exit(WorkflowManagment.CanExecuteWorkflow(RequisitionLine, WorkflowEventHandling.RunWorkflowOnSendRequisitionLineForApprovalCode));
    end;

    procedure IsItemJnlLineApprovalsWorkflowEnable(var ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        //if ItemJnlLine."Approval Status" <> ItemJnlLine."Approval Status"::Open then
        //exit(false);
        exit(WorkflowManagment.CanExecuteWorkflow(ItemJnlLine, WorkflowEventHandling.RunWorkflowOnSendItemJnlLineForApprovalCode));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowCommonApprovalStatus', '', false, false)]
    local procedure OnBeforeShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean);
    var
        TransferHeader: Record "Transfer Header";
        RequisitionLine: Record "Requisition Line";
    begin
        case RecRef.Number of
            Database::"Transfer Header":
                begin
                    RecRef.SetTable(TransferHeader);
                    IsHandle := false;
                end;
            Database::"Requisition Line":
                begin
                    RecRef.SetTable(RequisitionLine);
                    IsHandle := true;
                end;
        end;

    end;

    procedure TrySendRequisitionLineApprovalRequests(var RequisitionLine: Record "Requisition Line")
    var
        LinesSent: Integer;
    begin
        if RequisitionLine.Count = 1 then
            if CheckRequisitionLineApprovalsWorkflowEnable(RequisitionLine) then;
        REPEAT
            IF WorkflowManagment.CanExecuteWorkflow(RequisitionLine,
                 WorkflowEventHandling.RunWorkflowOnSendRequisitionLineForApprovalCode) AND
               NOT AppovalMgmt.HasOpenApprovalEntries(RequisitionLine.RECORDID)
            THEN BEGIN
                OnSendRequisitionLineForApproval(RequisitionLine);
                LinesSent += 1;
            END;
        UNTIL RequisitionLine.NEXT = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            RequisitionLine.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    end;

    procedure TrySendItemJnlLineApprovalRequests(var ItemJnlLine: Record "Item Journal Line")
    var
        LinesSent: Integer;
    begin
        if ItemJnlLine.Count = 1 then
            if CheckItemJnlLineApprovalsWorkflowEnable(ItemJnlLine) then;
        REPEAT
            IF WorkflowManagment.CanExecuteWorkflow(ItemJnlLine,
                 WorkflowEventHandling.RunWorkflowOnSendItemJnlLineForApprovalCode) AND
               NOT AppovalMgmt.HasOpenApprovalEntries(ItemJnlLine.RecordId)
            THEN BEGIN
                OnSendItemJnlLineForApproval(ItemJnlLine);
                LinesSent += 1;
            END;
        UNTIL ItemJnlLine.NEXT = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            ItemJnlLine.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    end;

    procedure TryCancelJournalLineApprovalRequests(var RequisitionLine: Record "Requisition Line")
    begin
        REPEAT
            IF AppovalMgmt.HasOpenApprovalEntries(RequisitionLine.RECORDID) THEN
                OnCancelRequisitionLineForApproval(RequisitionLine);
            WorkflowWebhookManagement.FindAndCancel(RequisitionLine.RECORDID);
        UNTIL RequisitionLine.NEXT = 0;
        MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);

    end;

    procedure TryCancelItemJnlLineApprovalRequests(var ItemJnlLine: Record "Item Journal Line")
    begin
        REPEAT
            IF AppovalMgmt.HasOpenApprovalEntries(ItemJnlLine.RECORDID) THEN
                OnCancelItemJnlLineForApproval(ItemJnlLine);
            WorkflowWebhookManagement.FindAndCancel(ItemJnlLine.RECORDID);
        UNTIL ItemJnlLine.NEXT = 0;
        MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    end;

    var
        AppovalMgmt: Codeunit "Approvals Mgmt.";
        WorkflowManagment: Codeunit "Workflow Management";

        NoWorkflowEnableErr: TextConst ENU = 'No Approval workflow for this type is enabled.';

        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";

        Error0001: TextConst ENU = 'This document can only be released when the approval process is complete.';
        Error0002: TextConst ENU = 'Transfer Order %1 must be approved and released before you can perform this action.';
        NoApprovalsSentMsg: TextConst ENU = 'No approval requests have been sent, either because they are already sent or because related workflows do not support the line.';
        PendingApprovalForSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: TextConst ENU = 'Requests for some lines were not sent, either because they are already sent or because related workflows do not support the line.';
        ApprovalReqCanceledForSelectedLinesMsg: TextConst ENU = 'The approval request for the selected record has been canceled.';
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";

        WorkflowEventHandling: Codeunit "Workflow Event Handling Sriq";
}