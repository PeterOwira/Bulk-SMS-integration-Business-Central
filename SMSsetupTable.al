table 50110 SMSSetup
{
    DataClassification = ToBeClassified;
    Caption = 'SMS Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; ApiUsername; Text[50])
        {
            Caption = 'API Username';
            DataClassification = ToBeClassified;

        }
        field(3; ApiKey; Text[100])
        {
            Caption = 'API Key';
            DataClassification = ToBeClassified;
        }
        field(4; ApiEndpoint; Text[250])
        {
            Caption = 'API Endpoint';
            DataClassification = ToBeClassified;
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
    key(PK; "Primary Key")
        {
            Clustered = true;
        }
        key(Key1; ApiUsername)
        {
            Clustered = false;
        }
    
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}


 
       



