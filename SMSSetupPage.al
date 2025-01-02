page 50110 "SMSSetupPage"
{

    PageType = Card;
    SourceTable = SMSSetup;
    Caption = 'SMS Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                //You might want to add fields here
                field(ApiUsername; Rec.ApiUsername)
                {
                    Caption = 'API Username';
                    ToolTip = 'API Username';
                    ApplicationArea = All;
                }
                field(ApiKey; Rec.ApiKey)
                {
                    Caption = 'API Key';
                    ApplicationArea = All;
                }
                field(ApiEndpoint; Rec.ApiEndpoint)
                {
                    Caption = 'API Endpoint';
                    ApplicationArea = All;
                }

                field(Active; Rec.Active)
                {
                    Caption = 'IsActive';
                    ApplicationArea = All;
                }



            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}

