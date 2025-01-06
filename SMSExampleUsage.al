
pageextension 50110 PostSalesInvoices extends "Posted Sales Invoice"
{


    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(SendSMS)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send SMS';
                ToolTip = 'Send SMS to Customer for payment';
                Image = SendTo;

                trigger OnAction()
                var
                    LCustomerRec: Record Customer;
                    LMessage: Text[250];
                    LAmount: Decimal;
                begin
                    LCustomerRec.Reset();
                    IF LCustomerRec.Get(Rec."Sell-to Customer No.") THEN BEGIN
                        LAmount := 0;
                        SalesLineRec.Reset();
                        SalesLineRec.SetRange(SalesLineRec."No.", Rec."No.");
                        IF SalesLineRec.FindFirst then begin

                            repeat
                                LAmount += SalesLineRec."Amount Including VAT";
                            //Message(Format(LAmount));
                            until SalesLineRec.Next() = 0;
                        end;

                        LMessage := 'Hello%20Customer:' + LCustomerRec."No." + ',%20Your%20Invoice:' + Rec."No." + '%20is%20created%20with%20Amount:%20' + Format(LAmount);

                        SendSmsToCustomer(LCustomerRec."Mobile Phone No.", LMessage);


                    END ELSE
                        Error('%1 not found on Customer Records', Rec."Sell-to Customer No.");


                end;
            }

        }

    }

    var
        SalesLineRec: Record "Sales Line";

    procedure SendSmsToCustomer(CustomerPhoneNumber: Text[20]; MessageText: Text[250])
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        JsonResponse: Text;
        Headers: HttpHeaders;
        ApiKey: Text[100];
        Username: Text[50];
        RequestBody: Text;
        SmsGatewayUrl: Text;
        SMSSetup: Record SMSSetup;
    begin
        SMSSetup.Reset();
        IF SMSSetup.Get() THEN BEGIN
            // Africa's Talking API credentials

            ApiKey := SMSSetup.ApiKey;  // Replace with your actual API key
            Username := SMSSetup.ApiUsername; // Replace with your actual Africa's Talking username
            SmsGatewayUrl := SMSSetup.ApiEndpoint;


            RequestBody := 'username=' + Username + '&to=%2B' + CustomerPhoneNumber + '&message=' + MessageText;

            // Create HttpContent object with the request body
            Content.WriteFrom(RequestBody);

            Content.GetHeaders(Headers); // Add Content-Type header here
            Headers.Clear(); // Remove existing Content-Type header if it exists
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            // Set up the HTTP client
            HttpClient.DefaultRequestHeaders().Add('apiKey', ApiKey);


            // Make the POST request

            if HttpClient.Post(SmsGatewayUrl, Content, HttpResponseMessage) then begin
                if HttpResponseMessage.IsSuccessStatusCode() then begin
                    HttpResponseMessage.Content().ReadAs(JsonResponse);
                    Message('SMS sent successfully: %1', JsonResponse);
                end else begin
                    HttpResponseMessage.Content().ReadAs(JsonResponse);
                    Message('Failed to send SMS: %1', JsonResponse);
                end;
            end else begin
                Error('Failed to connect to the SMS gateway.');
            end;
        END;
    end;


}

