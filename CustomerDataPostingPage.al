page 50185 CustomerDataPostingPage
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Customer Data Posting Page';
    SourceTable = CustomerDataPosting;
    PageType = List;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                }
                field(DocumentNo; Rec.DocumentNo)
                {
                    Caption = 'Document No.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(Postingdate; Rec.Postingdate)
                {
                    Caption = 'Posting Date';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field(BalancyLCY; Rec.BalancyLCY)
                {
                    Caption = 'Balance (LCY)';
                    ApplicationArea = All;
                }
            }
        }
    }
}