page 50183 CustomerDataPage
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = CustomerData;
    Caption = 'Customer Data';
    Editable = false;
    CardPageId = CustomerCardPage;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(CustomerName; Rec.CustomerName)
                {
                    ApplicationArea = All;
                }
                field(BalanceLCY; Rec.BalanceLCY)
                {
                    ApplicationArea = All;
                }
                field(LastPostingDate; Rec.LastPostingDate)
                {
                    ApplicationArea = All;
                }
                field(CustomerRating; Rec.CustomerRating)
                {
                    ApplicationArea = All;
                }
                field(CustomerResponseRating; Rec.CustomerResponseRating)
                {
                    ApplicationArea = All;
                }
                field(ApprovalStatus; Rec.ApprovalStatus)
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
            action(Generals)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Report;
                Caption = 'Report';
                trigger OnAction()
                var
                    CustRec: Record CustomerData;
                begin
                    CustRec := Rec;
                    CustRec.SetRecFilter();
                    Report.Run(Report::CardReport, true, false, CustRec);
                end;
            }
            action(Generals2)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Overdue;
                Caption = 'Over All Report';

                trigger OnAction()
                begin
                    Report.RunModal(Report::ReportForTable);
                end;
            }
            action(Name)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = NewWarehouseShipment;
                Caption = 'Name';
                trigger OnAction()
                var
                    Names: Codeunit CodeUnitForPractice;
                begin
                    Names.CustomerName(Rec.CustomerNo);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        User: Record "User Setup";
    begin
        User.Reset();
        User.SetRange(User."User ID", UserId);
        if User.FindFirst() then begin
            if not User.CustomerData then
                Error('You do not have access');
        end;
    end;
}