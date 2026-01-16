report 50138 ReportForTable
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Caption = 'Report';

    RDLCLayout = '.alpackages\.TablePageReport\Reports.rdl';

    dataset
    {
        dataitem(CustomerData; CustomerData)
        {
            column(No; No)
            {
                Caption = 'No.';
            }
            column(CustomerNo; CustomerNo)
            {
                Caption = 'Customer No.';
            }
            column(LastPostingDate; LastPostingDate)
            {
                Caption = 'Posting Date';
            }
            column(PhoneNo; PhoneNo)
            {
                Caption = 'Phone No.';
            }
            column(DueDate; DueDate)
            {
                Caption = 'Due Date';
            }
            column(HighValueDocument; HighValueDocument)
            {
                Caption = 'Document';
            }
            column(HighValueSalesInvoiceNo; HighValueSalesInvoiceNo)
            {
                Caption = 'High Value Sales Invoice No.';
            }
            column(CityCode; CityCode)
            {
                Caption = 'Code';
            }
            column(CityName; CityName)
            {
                Caption = 'City Name';
            }
            column(CountryCode; CountryCode)
            {
                Caption = 'Country Code';
            }
            column(CountryName; CountryName)
            {
                Caption = 'Country Name';
            }
            column(RequestFilter; RequestFilter)
            {
                Caption = 'Report Filter';
            }
            trigger OnPreDataItem()
            begin
                RequestFilter := CustomerData.GetFilters;
            end;
        }
    }
    var
        RequestFilter: Text;
}