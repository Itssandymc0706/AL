codeunit 50168 CodeUnitForPractice
{
    [EventSubscriber(ObjectType::Table, Database::CustomerData, OnBeforeInsertEvent, '', false, false)]
    local procedure BeforeInsert(var Rec: Record CustomerData)
    var
    begin
        if Rec.No = '' then
            Error('Please enter number');
    end;

    [EventSubscriber(ObjectType::Page, Page::CustomerCardPage, OnAfterValidateEvent, 'CustomerNo', false, false)]
    local procedure AfterGetCurr(var Rec: Record CustomerData)
    var
        MyNotification: Notification;
    begin
        if Rec.HighValueSalesInvoiceNo = 0 then begin
            MyNotification.Message := StrSubstNo('This Customer have 0 Sales Amount, Please Block them with Managers Approval.');
            MyNotification.Scope := NotificationScope::LocalScope;
            MyNotification.SetData('No.', Rec.CustomerNo);
            MyNotification.AddAction('Customers', Codeunit::CodeUnitForPractice, 'CustomerBlock');
            MyNotification.Send();
        end;
    end;

    procedure CustomerBlock(MyNotification: Notification)
    var
        CustomerNo: Code[20];
        Cust: Record Customer;
    begin
        CustomerNo := MyNotification.GetData('No.');
        if Cust.get(CustomerNo) then
            Page.RunModal(Page::"Customer Card", Cust);
    end;

    [EventSubscriber(ObjectType::Table, Database::CustomerData, OnBeforeValidateEvent, 'CustomerRating', false, false)]
    local procedure OnBeforeValidate(var Rec: Record CustomerData)
    var
    begin
        if Rec.CustomerRating = Rec.CustomerRating::Bad then begin
            if not Confirm('Are you going to mention this customer as a bad customer', true) then
                Error('Cleared');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::CustomerData, OnAfterValidateEvent, 'CustomerNo', false, false)]
    local procedure OnAfterValidate(var Rec: Record CustomerData)
    begin
        if CustomersBlock(Rec.CustomerNo) then
            Error('Customer is Blocked');
    end;

    procedure CustomersBlock(CustomerNo: Code[20]): Boolean
    var
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then
            exit(Cust.Blocked <> Cust.Blocked::" ");
    end;

    procedure CustomerPosting(var CustomerData: Record CustomerData)
    var
        CustomerPostingDate: Record CustomerDataPosting;
    begin
        CustomerPostingDate.Init();
        CustomerPostingDate.DocumentNo := CustomerData.CustomerNo;
        CustomerPostingDate.Name := CustomerData.CustomerName;
        CustomerPostingDate.Postingdate := Today();
        CustomerPostingDate.Amount := CustomerData.HighValueSalesInvoiceNo;
        CustomerPostingDate.BalancyLCY := CustomerData.BalanceLCY;
        CustomerPostingDate.Insert();
    end;

    procedure CustomerName(CustomerNos: Code[20])
    var
        Cust: Record CustomerData;
    begin
        Cust.SetRange(CustomerNo, CustomerNos);
        if Cust.FindFirst() then
            Message('Customer Name is : %1', Cust.CustomerName);
    end;

    procedure TotalSalesInvoice(CustNumber: Code[20])
    var
        CustData: Record CustomerData;
        Sales: Record "Sales Invoice Header";
        Total: Integer;
    begin
        Sales.Reset();
        Sales.SetRange("Bill-to Customer No.", CustNumber);
        if Sales.FindSet() then begin
            Total := Sales.Count();
            Message('Total Sales Invoice is %1', Total);
        end;
        CustData.SetRange(CustomerNo, CustNumber);
        if CustData.FindFirst() then
            CustData.TotalSalesInvoice := Total;
        CustData.Modify(true);
    end;
}