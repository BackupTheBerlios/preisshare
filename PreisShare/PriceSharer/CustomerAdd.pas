unit CustomerAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinCtrls, ExtCtrls,
  GTDBizDocs,PricelistGenerate, jpeg, bsMessages;

type
  TfrmCustomerAdd = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    cbxUpdateFrequency: TbsSkinGroupBox;
    btnSave: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    cbxWeekly: TbsSkinCheckRadioBox;
    cbxFortnightly: TbsSkinCheckRadioBox;
    cbxWhenChanged: TbsSkinCheckRadioBox;
    bsSkinLabel1: TbsSkinLabel;
    txtContactName: TbsSkinEdit;
    txtEmailAddress: TbsSkinEdit;
    bsSkinLabel2: TbsSkinLabel;
    cbxPricelistFormat: TbsSkinGroupBox;
    cbxHTML: TbsSkinCheckRadioBox;
    cbxXLSFormat: TbsSkinCheckRadioBox;
    cbxXMLFormat: TbsSkinCheckRadioBox;
    cbxCSVFormat: TbsSkinCheckRadioBox;
    cbxDaily: TbsSkinCheckRadioBox;
    bsSkinLabel3: TbsSkinLabel;
    txtCompanyName: TbsSkinEdit;
    Image1: TImage;
    bsSkinMessage1: TbsSkinMessage;
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomerAdd: TfrmCustomerAdd;

implementation

{$R *.DFM}
uses Main;

procedure TfrmCustomerAdd.btnSaveClick(Sender: TObject);

    // -- Validate the users data entry
    function ValidateEntry:Boolean;
    begin
        if txtContactName.Text = '' then
        begin
            bsSkinMessage1.MessageDlg('Contact Name required',mtError,[mbOk],0);
            Exit;
        end;

        if txtCompanyName.Text = '' then
        begin
            bsSkinMessage1.MessageDlg('Company Name required',mtError,[mbOk],0);
            Exit;
        end;

        if txtEmailAddress.Text = '' then
        begin
            bsSkinMessage1.MessageDlg('Email Address required',mtError,[mbOk],0);
            Exit;
        end;

        if (not cbxXLSFormat.Checked) and (not cbxXMLFormat.Checked) and (not cbxCSVFormat.Checked) then
        begin
            bsSkinMessage1.MessageDlg('Contact Name required',mtError,[mbOk],0);
            Exit;
        end;

        // -- Seems to be ok then
        Result := True;
    end;

var
    pf,uf : String;

begin
    // -- Bomb out if something is not entered
    if not ValidateEntry then
        Exit;

    // -- Create a new customer record
    with frmMain.DocRegistry.Traders do
    begin
        // -- Open the table if not open
        if not Active then
            Active := True;

        // -- This takes care of the creating the Trader record
        Append;
        FieldByName(GTD_DB_COL_CONTACT).AsString := txtContactName.Text;
        FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := txtCompanyName.Text;
        FieldByName(GTD_DB_COL_EMAILADDRESS).AsString := txtEmailAddress.Text;

        FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := GTD_TRADER_RLTNSHP_CUSTOMER;
        FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_ACTIVE;
        Post;

        // -- Now edit it again to have the correct details
        if frmMain.DocRegistry.OpenForTraderNumber(frmMain.DocRegistry.Traders.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger) then
        begin

            // -- Build a string containing all the desired formats
            pf := '';
            if cbxXLSFormat.Checked then
                pf := pf + PL_DELIV_XLS + ';';
            if cbxXMLFormat.Checked then
                pf := pf + PL_DELIV_XML + ';';
            if cbxCSVFormat.Checked then
                pf := pf + PL_DELIV_CSV + ';';

            if pf <> '' then
                pf := Copy(pf,1,Length(pf)-1);

            frmMain.DocRegistry.SaveTraderSettingString(PL_DELIV_NODE,PL_DELIV_FORMAT,pf,false);

            // -- Save the update frequency
            uf := '';
            if cbxWhenChanged.Checked then
                uf := PL_DELIV_FREQ_INSTANT
            else if cbxDaily.Checked then
                uf := PL_DELIV_FREQ_DAILY
            else if cbxWeekly.Checked then
                uf := PL_DELIV_FREQ_WEEKLY
            else if cbxFortnightly.Checked then
                uf := PL_DELIV_FREQ_FORTNIGHT;

            frmMain.DocRegistry.SaveTraderSettingString(PL_DELIV_NODE,PL_DELIV_FREQUENCY,uf);

        end;
    end;

    // -- Clear the fields
    txtContactName.Text := '';
    txtCompanyName.Text := '';
    txtEmailAddress.Text := '';
    cbxWhenChanged.Checked := True;
    cbxXMLFormat.Checked := True;

end;

end.
