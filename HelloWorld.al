// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.BULKSMS;

using Microsoft.Sales.Customer;

pageextension 50100 CustomerListExt extends "Customer List"
{

    actions
    {
        addlast(processing)
        {
            action(NofifyCust)
            {
                Caption = 'Notify Customer';
                ApplicationArea = All;
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    //sendSMS()
                    SendSmsToCustomer('254712345678', 'Hello%20World%20BC%20CRONUS')
                end;
            }
        }
    }
    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;




    local procedure sendSMS() ResponseText: Text
    var
        HttpClient: HttpClient;
        HttpHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        ServiceCallErr: Label 'Web service call failed.';
        ErrorInfoObject: ErrorInfo;
        HttpResponseMessage: HttpResponseMessage;
        HttpStatusCode: Integer;
        HttpContent: HttpContent;


    begin

        HttpHeaders.Add('Accept', 'application/json');
        HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpHeaders.Add('apiKey', 'atsk_6a7041873a97551dabb571229474f75a18b2c03705884dfe61a605e8f83138df818a0f02');
        HttpContent.WriteFrom('username=sandbox&to=%2B254712345678&message=Hello%20World!%20Cronus');
        HttpContent.GetHeaders(HttpHeaders);

        IsSuccessful := HttpClient.Post('https://api.sandbox.africastalking.com/version1/messaging', HttpContent, HttpResponseMessage);

        if not IsSuccessful then begin
            // handle the error
        end;

        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpStatusCode := HttpResponseMessage.HttpStatusCode();
            ErrorInfoObject.DetailedMessage := 'Sorry, we could not retrieve the cat info right now. ';
            ErrorInfoObject.Message := Format(ServiceCallErr, HttpStatusCode, HttpResponseMessage.ReasonPhrase());
            Error(ErrorInfoObject);
        end;

        HttpResponseMessage.Content().ReadAs(ResponseText);


    end;


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
    begin
        // Africa's Talking API credentials
        ApiKey := 'atsk_6a7041873a97551dabb571229474f75a18b2c03705884dfe61a605e8f83138df818a0f02'; // Replace with your actual API key
        Username := 'sandbox'; // Replace with your actual Africa's Talking username
        SmsGatewayUrl := 'https://api.sandbox.africastalking.com/version1/messaging';

        // Create the request body
        //     RequestBody := '{
        //     "username": "' + Username + '",
        //     "to": "' + CustomerPhoneNumber + '",
        //     "message": "' + MessageText + '"
        // }';
        RequestBody := 'username=' + Username + '&to=%2B' + CustomerPhoneNumber + '&message=' + MessageText;

        // Create HttpContent object with the request body
        Content.WriteFrom(RequestBody);

        Content.GetHeaders(Headers); // Add Content-Type header here
        //Failed to send SMS: The request's Content-Type [text/plain; charset=UTF-8] is not supported. Expected:application/x-www-form-urlencoded or multipart/form-data
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
    end;

}