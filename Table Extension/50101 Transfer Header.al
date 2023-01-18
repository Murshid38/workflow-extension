tableextension 50101 "Transfer Header Ext Appv." extends "Transfer Header"
{
    fields
    {

        field(50051; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval,Released';
            Editable = false;
        }

        modify("Transfer-from Code")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Transfer-to Code")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Shipment Date")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Receipt Date")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("In-Transit Code")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Shipping Agent Code")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Shipping Agent Service Code")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Shipping Time")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Shipping Advice")
        {
            trigger OnBeforeValidate()
            begin
                if Rec."Shipping Advice" <> xRec."Shipping Advice" then
                    TestApprovalStatusOpen();
            end;
        }
        modify("Outbound Whse. Handling Time")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }
        modify("Inbound Whse. Handling Time")
        {
            trigger OnBeforeValidate()
            begin
                TestApprovalStatusOpen();
            end;
        }

        /*  modify(Status)
        {
                OptionCaption = 'Open,Released,Pending';
        } */

    }

    /* trigger OnModify()
    begin
        CheckApprovalStatus();
    end;

    local procedure CheckApprovalStatus()
    var
        Error0001: TextConst ENU = '%1 must be equal to %2 in Transfer Header: No.=%3. Current value is %4.';
    begin
        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
            Error(Error0001, Rec.FieldCaption("Approval Status"), Rec."Approval Status"::Open, Rec."No.", Rec."Approval Status"::"Pending Approval");
    end; */

    trigger OnInsert()
    begin
        TestApprovalStatusOpen();
    end;


    procedure TestApprovalStatusOpen()
    begin
        TESTFIELD(Rec."Approval Status", Rec."Approval Status"::Open);
    end;

    procedure DeleteApprovalStatusOpen()
    var
        Error0001: TextConst ENU = 'This document can only be deleted when the approval process is complete.';
    begin
        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval"
        then
            Error(Error0001);
    end;

}