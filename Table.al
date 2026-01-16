table 50181 CustomerData
{
    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'EntryNo';
        }
        field(2; CustomerNo; Code[20])
        {
            Caption = 'Customer No';
            TableRelation = Customer;
            trigger OnValidate()
            begin
                Clear(HighValueSalesInvoiceNo);
                HighValueSales();
            end;
        }
        field(4; LastPostingDate; Date)
        {
            Caption = 'Last Posting Date';
        }
        field(5; PhoneNo; Text[30])
        {
            Caption = 'Phone No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Phone No." where("No." = field(CustomerNo)));
        }
        field(6; DueDate; Date)
        {
            Caption = 'Due Date';
        }
        field(7; HighValueDocument; Code[20])
        {
            Caption = 'High Value Doc.No';
        }
        field(8; HighValueSalesInvoiceNo; Decimal)
        {
            Caption = 'High Value Sales.No';
        }
        field(9; CountryCode; Code[20])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";

        }
        field(10; CityCode; Code[20])
        {
            Caption = 'City Code';
            TableRelation = "Post Code";
        }
        field(11; CountryName; Text[50])
        {
            Caption = 'Country Name';
        }
        field(12; CityName; Text[30])
        {
            Caption = 'City';
        }
        field(13; CustomerRating; Option)
        {
            Caption = 'Customer Rating';
            NotBlank = true;
            OptionMembers = " ",Excellent,Good,Average,Bad;
            OptionCaption = ',Excellent,Good,Average,Bad';
        }
        field(14; CustomerResponseRating; Integer)
        {
            Caption = 'Customer Response Rating';
            NotBlank = true;
            BlankZero = true;
            trigger OnValidate()
            var
                MyNotification: Notification;
            begin
                if Rec.CustomerResponseRating = 10 then begin
                    MyNotification.Message('Grate Customer Keep Touch with them');
                    MyNotification.Scope := NotificationScope::LocalScope;
                    MyNotification.Send();
                end;
                if (Rec.CustomerResponseRating >= 5) AND (Rec.CustomerResponseRating <= 9) then begin
                    MyNotification.Message('Good Customer Keep touch With them');
                    MyNotification.Scope := NotificationScope::LocalScope;
                    MyNotification.Send();
                end;
                if (Rec.CustomerResponseRating < 5) AND (Rec.CustomerResponseRating >= 2) then begin
                    MyNotification.Message('Not a grate customer, Please discuss with manager');
                    MyNotification.Scope := NotificationScope::LocalScope;
                    MyNotification.Send();
                end;

                if Rec.CustomerResponseRating <= 1 then begin
                    MyNotification.Message('Bad Customer, Please block them in the system with manager approval');
                    MyNotification.AddAction('Customer', Page::"Customer Card", Rec.CustomerNo);
                    MyNotification.Scope := NotificationScope::LocalScope;
                    MyNotification.Send();
                end;
            end;
        }
        field(15; CustomerName; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(16; CustomerPostingroup; Code[20])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
        }
        field(17; GenBusPostingGroup; Code[20])
        {
            Caption = 'Gen.Bus.Posting Group';
            Editable = false;
        }
        field(18; BalanceLCY; Decimal)
        {
            Caption = 'Balance (LCY)';
            Editable = false;
        }
        field(19; ApprovalStatus; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,PendingApproval,Approved,Rejected;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
        }
        field(20; TotalSalesInvoice; Integer)
        {
            Caption = 'Total Sales Invoice';
            Editable = false;
        }

    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    var
        Customer: Record Customer;
        CustLedger: Record "Cust. Ledger Entry";
    begin
        HighAmount();
        HighValueSales();
        Address();
        CustomerGroup();
        if Customer.Get(CustomerNo) then begin
            CustomerName := Customer.Name;
        end;
        CustLedger.Init();
        CustLedger.SetRange("Customer No.", CustomerNo);
        CustLedger.SetCurrentKey("Posting Date");
        if CustLedger.FindLast() then begin
            LastPostingDate := CustLedger."Posting Date";
            DueDate := CustLedger."Due Date";
        end;
    end;

    trigger OnDelete()
    begin
        if Confirm('Are you going to delete ?', false) then
            Message('Record deleted') else
            Error('Delete Aborted');
    end;

    local procedure HighAmount()
    var
        Ledger: Record "Cust. Ledger Entry";
    begin
        Ledger.Init();
        Ledger.SetRange("Customer No.", CustomerNo);
        Ledger.SetCurrentKey(Amount);
        Ledger.Ascending(true);
        if Ledger.FindLast() then begin
            HighValueDocument := Ledger."Document No.";
        end;
    end;

    local procedure HighValueSales()
    var
        Sales: Record "Sales Invoice Header";
    begin
        Sales.Init();
        Sales.SetRange("Sell-to Customer No.", CustomerNo);
        Sales.SetCurrentKey(Amount);
        Sales.Ascending(true);
        if Sales.FindLast() then begin
            HighValueSalesInvoiceNo := Sales.Amount;
        end;
    end;

    local procedure Address()
    var
        Post: Record "Post Code";
        Country: Record "Country/Region";
    begin
        Post.Init();
        Post.SetRange(Code, CityCode);
        if Post.FindFirst() then
            CityName := Post.City;

        Country.Init();
        Country.SetRange(Code, CountryCode);
        if Country.FindFirst() then
            CountryName := Country.Name;
    end;

    local procedure CustomerGroup()
    var
        Cust: Record Customer;
    begin
        Cust.Reset();
        Cust.SetRange("No.", Rec.CustomerNo);
        if Cust.FindFirst() then begin
            Rec.CustomerPostingroup := Cust."Customer Posting Group";
        end;
        Cust.Reset();
        Cust.SetRange("No.", Rec.CustomerNo);
        if Cust.FindFirst() then begin
            Rec.GenBusPostingGroup := Cust."Gen. Bus. Posting Group";
        end;
        Cust.Reset();
        Cust.SetRange("No.", Rec.CustomerNo);
        if Cust.FindFirst() then begin
            if Cust."Customer Posting Group" = '' then
                Error('Please Fill the customer Posting group for %1', Rec.CustomerNo);
        end;
        Cust.Reset();
        Cust.SetRange("No.", Rec.CustomerNo);
        if Cust.FindFirst() then begin
            Cust.CalcFields("Balance (LCY)");
            Rec.BalanceLCY := Cust."Balance (LCY)";
        end;
    end;
}