Codeunit 50101 "Workflow Event Handling Sriq"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary();
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendTransferOrderForApprovalCode, Database::"Transfer Header", TransOrderSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelTransferOrderForApprovalCode, Database::"Transfer Header", TransOrderApprovalReuqestCancelEventDescText, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendRequisitionLineForApprovalCode, Database::"Requisition Line", RequisitionLineSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelRequisitionLineForApprovalCode, Database::"Requisition Line", RequisitionLineApprovalReuqestCancelEventDescText, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJnlLineForApprovalCode, Database::"Item Journal Line", ItemJnlLineSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJnlLineForApprovalCode, Database::"Item Journal Line", ItemJnlLineApprovalReuqestCancelEventDescText, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFAForApprovalCode, Database::"Fixed Asset", FASendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFAApprovalRequestCode, Database::"Fixed Asset", FAApprovalReuqestCancelEventDescText, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128]);
    begin
        case EventFunctionName of
            RunWorkflowOnCancelTransferOrderForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelTransferOrderForApprovalCode, RunWorkflowOnSendTransferOrderForApprovalCode);

            RunWorkflowOnCancelRequisitionLineForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelRequisitionLineForApprovalCode, RunWorkflowOnSendRequisitionLineForApprovalCode);

            RunWorkflowOnCancelItemJnlLineForApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelItemJnlLineForApprovalCode, RunWorkflowOnSendItemJnlLineForApprovalCode);

            RunWorkflowOnCancelFAApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelFAApprovalRequestCode, RunWorkflowOnSendFAForApprovalCode);

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTransferOrderForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendRequisitionLineForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendItemJnlLineForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFAForApprovalCode);
                end;
        end;
    end;

    procedure RunWorkflowOnSendTransferOrderForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendTransferOrderForApproval'));
    end;

    procedure RunWorkflowOnCancelTransferOrderForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelTransferOrderForApproval'));
    end;

    procedure RunWorkflowOnSendRequisitionLineForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendRequisitionLineForApproval'));
    end;

    procedure RunWorkflowOnCancelRequisitionLineForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelRequisitionLineForApproval'));
    end;

    procedure RunWorkflowOnSendItemJnlLineForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendItemJnlLineForApproval'));
    end;

    procedure RunWorkflowOnCancelItemJnlLineForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelItemJnlLineForApproval'));
    end;

    procedure RunWorkflowOnSendFAForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendFAForApproval'));
    end;

    procedure RunWorkflowOnCancelFAApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelFAApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnSendTransferOrderForApproval', '', false, false)]
    local procedure OnSendTransferOrderForApproval(var TransferHeader: Record "Transfer Header");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnSendTransferOrderForApprovalCode, TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnCancelTransferOrderForApproval', '', false, false)]
    local procedure OnCancelTransferOrderForApproval(var TransferHeader: Record "Transfer Header");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnCancelTransferOrderForApprovalCode, TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnSendRequisitionLineForApproval', '', false, false)]
    local procedure OnSendRequisitionLineForApproval(var RequisitionLine: Record "Requisition Line");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnSendRequisitionLineForApprovalCode, RequisitionLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnCancelRequisitionLineForApproval', '', false, false)]
    local procedure OnCancelRequisitionLineForApproval(var RequisitionLine: Record "Requisition Line");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnCancelRequisitionLineForApprovalCode, RequisitionLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnSendItemJnlLineForApproval', '', false, false)]
    local procedure OnSendItemJnlLineForApproval(var ItemJnlLine: Record "Item Journal Line");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnSendItemJnlLineForApprovalCode, ItemJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnCancelItemJnlLineForApproval', '', false, false)]
    local procedure OnCancelItemJnlLineForApproval(var ItemJnlLine: Record "Item Journal Line");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnCancelItemJnlLineForApprovalCode, ItemJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnSendFAForApproval', '', false, false)]
    local procedure OnSendFAForApproval(var FixedAsset: Record "Fixed Asset");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnSendFAForApprovalCode, FixedAsset);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Sriq", 'OnCancelFAApprovalRequest', '', false, false)]
    local procedure OnCancelFAForApproval(var FixedAsset: Record "Fixed Asset");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnCancelFAApprovalRequestCode, FixedAsset);
    end;

    var
        WorkflowManagment: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";

        TransOrderSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Transfer Order is required';
        TransOrderApprovalReuqestCancelEventDescText: TextConst ENU = 'Approval of a Transfer Order is canceled';

        RequisitionLineSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Requisition Line is required';
        RequisitionLineApprovalReuqestCancelEventDescText: TextConst ENU = 'Approval of a Requisition Line is canceled';
        ItemJnlLineSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Item Journal Line is required';
        ItemJnlLineApprovalReuqestCancelEventDescText: TextConst ENU = 'Approval of a Item Journal Line is canceled';
        FASendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Fixed Asset is required';
        FAApprovalReuqestCancelEventDescText: TextConst ENU = 'Approval of a Fixed Asset is canceled';
}