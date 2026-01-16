page 50184 CustomerCardPage
{
    ApplicationArea = All;
    PageType = Card;
    Caption = 'Customer Card Page';
    SourceTable = CustomerData;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(CustomerName; Rec.CustomerName)
                {
                    ApplicationArea = All;
                }
                field(LastPostingDate; Rec.LastPostingDate)
                {
                    ApplicationArea = All;
                }
                field(PhoneNo; Rec.PhoneNo)
                {
                    ApplicationArea = All;
                }
                field(DueDate; Rec.DueDate)
                {
                    ApplicationArea = All;
                }
                field(CityCode; Rec.CityCode)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(City; Rec.CityName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CountryCode; Rec.CountryCode)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(CountryName; Rec.CountryName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ApprovalStatus; Rec.ApprovalStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(CustomerRevenue)
            {
                Caption = 'Customer Revenue';
                field(HighValueDocument; Rec.HighValueDocument)
                {
                    ApplicationArea = All;
                }
                field(HighValueSalesInvoiceNo; Rec.HighValueSalesInvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'High Value Sales Amount';
                }
                field(BalanceLCY; Rec.BalanceLCY)
                {
                    ApplicationArea = All;
                    Caption = 'Balance (LCY)';
                }
                field(CustomerPostingroup; Rec.CustomerPostingroup)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Posting Group';
                }
                field(GenBusPostingGroup; Rec.GenBusPostingGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Gen.Bus Posting Group';
                }
            }
            group(CustomerRelationShip)
            {
                Caption = 'Customer Relationship';
                field(CustomerRating; Rec.CustomerRating)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(CustomerResponseRating; Rec.CustomerResponseRating)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(TotalSalesInvoice; Rec.TotalSalesInvoice)
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
            action(Post)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Promoted = true;
                Image = PostDocument;
                Caption = 'Post';
                trigger OnAction()
                Var
                    CodeUnit: Codeunit CodeUnitForPractice;
                begin
                    if Rec.ApprovalStatus <> Rec.ApprovalStatus::Approved then
                        Error('Document must be approved before posting');
                    if Confirm('Do you want to post this document ?', false) then begin
                        CodeUnit.CustomerPosting(Rec);
                        Message('Posting Done.');
                    end;
                end;
            }
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
            action(SendApproval)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = SendTo;
                Caption = 'Send Approval';

                trigger OnAction()
                begin
                    Rec.TestField(No);
                    Rec.TestField(CityCode);
                    Rec.TestField(CountryCode);
                    Rec.TestField(CustomerResponseRating);
                    Rec.TestField(CustomerRating);

                    if Rec.ApprovalStatus = Rec.ApprovalStatus::Open then begin
                        if Confirm('Do you want to send approval ?', false) then
                            Rec.ApprovalStatus := Rec.ApprovalStatus::PendingApproval;
                        Message('Approval has been sent');
                    end;
                end;
            }
            action(Approval)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Approval;
                Caption = 'Approve';
                trigger OnAction()
                var
                    User: Record "User Setup";
                begin
                    Rec.TestField(No);
                    Rec.TestField(CityCode);
                    Rec.TestField(CountryCode);
                    Rec.TestField(CustomerResponseRating);
                    Rec.TestField(CustomerRating);

                    User.Reset();
                    User.SetRange("User ID", UserId);
                    if User.FindFirst() then begin
                        if not User.CustomerDataApproval then
                            Error('You did not have access to approve the customer.');
                    end;
                    if Rec.ApprovalStatus = Rec.ApprovalStatus::PendingApproval then begin
                        if Confirm('Do you want to approve this document', false) then
                            Rec.ApprovalStatus := Rec.ApprovalStatus::Approved;
                        Rec.Modify(true);
                        Message('Customer has been Approved');
                    end else
                        Error('Cannot Approve the customer');
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                Image = Reject;
                Caption = 'Reject';
                trigger OnAction()
                var
                    User: Record "User Setup";
                begin
                    Rec.TestField(No);
                    Rec.TestField(CityCode);
                    Rec.TestField(CountryCode);
                    Rec.TestField(CustomerResponseRating);
                    Rec.TestField(CustomerRating);

                    User.Reset();
                    User.SetRange("User ID", UserId);
                    if User.FindFirst() then begin
                        if not User.CustomerDataApproval then
                            Error('You did not have a access to reject the customer');
                    end;
                    if Rec.ApprovalStatus = Rec.ApprovalStatus::PendingApproval then begin
                        if Confirm('Do uou want to reject this document ?', false) then
                            Rec.ApprovalStatus := Rec.ApprovalStatus::Rejected;
                        Rec.Modify(true);
                        Message('Customer has been Rejected');
                    end else
                        Error('Cannot Reject the customer');
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                Image = ReOpen;
                Caption = 'Re-open';
                trigger OnAction()
                begin
                    if (Rec.ApprovalStatus = Rec.ApprovalStatus::Approved) or (Rec.ApprovalStatus = Rec.ApprovalStatus::Rejected) then begin
                        if Confirm('Do you want to re-open the document ?', false) then
                            Rec.ApprovalStatus := Rec.ApprovalStatus::Open;
                        Rec.Modify(true);
                        Message('Customer has been Re-Opened');
                    end else
                        Error('Cannot Re-open');
                end;
            }
            action(TotalSalesInvoices)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Total Sales Invoice';
                Image = Totals;
                trigger OnAction()
                var
                    Sales: Codeunit CodeUnitForPractice;
                begin
                    Sales.TotalSalesInvoice(Rec.CustomerNo);
                end;
            }
        }

    }
    trigger OnOpenPage()
    var
    begin
        if UserId <> 'MEB201450\HPIT' then
            Error('You Cannot');
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (Rec.CountryCode = '') or (Rec.CityCode = '') or (Rec.CustomerResponseRating = 0) then begin
            Message('Please Fill the mandatory fields');
            exit(false);
        end;
    end;
}