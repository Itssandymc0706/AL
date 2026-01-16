table 50182 CustomerDataPosting
{
    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(2; DocumentNo; Code[20])
        {
            Caption = 'Document No';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(4; Postingdate; Date)
        {
            Caption = 'posting Date';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'High Value Amount';
        }
        field(6; BalancyLCY; Decimal)
        {
            Caption = 'Balance (LCY)';
        }
    }

}