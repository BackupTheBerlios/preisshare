unit DocumentNavigator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, bsSkinCtrls, ImgList, GTDBizDocs, Db, DBTables, Menus,
  bsSkinMenus, bsSkinData, ExtCtrls, StdCtrls, Mask, bsSkinBoxCtrls;

type

  hNavigatorOnDocumentEvent = procedure(Sender: TObject; Document_ID : Integer) of object;
  hNavigatorOnSearchEvent = procedure(Sender: TObject; SearchText : String) of object;

  TRegistryNavigator = class(TFrame)
	TreeView: TbsSkinTreeView;
	ImageList1: TImageList;
	qryGetInfo: TQuery;
	Query2: TQuery;
	sbVert: TbsSkinScrollBar;
    txtJumpTo: TbsSkinEdit;
    lblJumpTo: TbsSkinLabel;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    Report1: TMenuItem;
	procedure FrameResize(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure txtJumpToKeyPress(Sender: TObject; var Key: Char);
  private
	fDocuments      : GTDDocumentRegistry;
	fSkinData		: TbsSkinData;
	fOnDocSelect	: hNavigatorOnDocumentEvent;
	fOnSearchText   : hNavigatorOnSearchEvent;
	fJobSupport		: Boolean;
	fServiceJobSupport : Boolean;

	followUpNode,
	servicejobnode,
	jobNode,
	QNode,
	PONode,
	InvNode			: TTreeNode;

	procedure SetSkinData(NewSkin : TbsSkinData);
	procedure LoadFollowUps;

	{ Private declarations }
  published
	property DocRegistry: GTDDocumentRegistry read fDocuments write fDocuments;
	property SkinData : TbsSkinData read fSkinData write SetSkinData;
	property JobSupport : Boolean read fJobSupport write fJobSupport;
	property ServiceJobSupport : Boolean read fServiceJobSupport write fServiceJobSupport;
	property OnDocumentSelected : hNavigatorOnDocumentEvent read fOnDocSelect write fOnDocSelect;
	property OnSearchText : hNavigatorOnSearchEvent read fOnSearchText write fOnSearchText;
  public
	{ Public declarations }
	procedure Initialise;
	procedure Clear;
	procedure LoadDocuments(showDocument : Integer = -1);
	procedure LoadJobs;
	procedure LoadServiceJobs;
	procedure LoadPurchaseOrders;
	procedure LoadInvoices;
	procedure LoadQuotes;
  end;

implementation

{$R *.DFM}

const
	dnvImageDocType = 4;
	dnvImageJobType = 3;
	dnvImageStatusType = 4;

procedure TRegistryNavigator.Initialise;
begin
	TreeView.Items.Clear;

	// -- A Node for service jobs
	fServiceJobSupport := True;
	if fServiceJobSupport then
		ServicejobNode      := TreeView.Items.AddChild(nil,'Service Jobs');

	// -- A Node for construction jobs
	if fJobSupport then
		jobNode      := TreeView.Items.AddChild(nil,'Jobs');

	PONode  	 := TreeView.Items.AddChild(nil,'Purchase Orders');
	QNode   	 := TreeView.Items.AddChild(nil,'Quotations');
	InvNode      := TreeView.Items.AddChild(nil,'Invoices');

	FrameResize(Self);

end;

procedure TRegistryNavigator.Clear;
begin
end;

procedure TRegistryNavigator.LoadFollowUps;
begin
	// followUpNode := TreeView.Items.AddChild(nil,'Follow Ups');
end;

procedure TRegistryNavigator.LoadDocuments(showDocument : Integer);
var
	StatusNode, NewNode,DocNode,SelNode		: TTreeNode;
	lastType,lastStatus		: String;
	p : Pointer;
	dno,firstDoc,xc : Integer;
begin

	// -- used to select the selected document
	firstDoc := -1;
	SelNode  := nil;

	Clear;

	LoadFollowUps;

	LoadJobs;

	LoadServiceJobs;

	// -- Delete all the children on the node
	if Assigned(PONode) then
		PONode.DeleteChildren;
	if Assigned(InvNode) then
		InvNode.DeleteChildren;
	if Assigned(QNode) then
		QNode.DeleteChildren;

	{$IFNDEF LIGHTWEIGHT}
	with qryGetInfo do
	begin
		Active := False;
		DatabaseName := fDocuments.DatabaseName;

		SQL.Clear;
		SQL.Add('SELECT distinct');
		SQL.Add('	td.Document_ID,');
		SQL.Add('	td.local_status_code,');
		SQL.Add('	td.document_name,');
		SQL.Add('	td.document_reference,');
		SQL.Add('	t.name');
		SQL.Add('FROM Trader_Documents td, Trader t');
		SQL.Add('where');
		SQL.Add('	(td.shared_with = t.trader_id)');
		SQL.Add('	and (local_status_code <> "Cancelled")');
		SQL.Add('	and (local_status_code <> "Complete")');
		SQL.Add('	and ((document_name = "' + GTD_QUOTE_TYPE + '") or');
		SQL.Add('	     (document_name = "' + GTD_ORDER_TYPE + '") or');
		SQL.Add('	     (document_name = "' + GTD_INVOICE_TYPE + '"))');
		SQL.Add('order by');
		SQL.Add('	document_name,');
		SQL.Add('	local_status_code,');
		SQL.Add('	document_reference');

		Active := True;

		lastType := '';
		First;
		while not Eof do
		begin

			if lastType <> FieldByName('document_name').AsString then
			begin
				lastType := FieldByName('document_name').AsString;
				if lastType = GTD_QUOTE_TYPE then
					DocNode := QNode
				else if lastType = GTD_ORDER_TYPE then
					DocNode := PONode
				else if lastType = GTD_INVOICE_TYPE then
					DocNode := InvNode;

				lastStatus := '';
			end;

			if lastStatus <> FieldByName('local_status_code').AsString then
			begin
				lastStatus := FieldByName('local_status_code').AsString;
				if Assigned(DocNode) then
				begin
					StatusNode	:= TreeView.Items.AddChildObject(DocNode,FieldByName('local_status_code').AsString,p);
					StatusNode.ImageIndex := dnvImageStatusType;
				end;
			end;

			// -- Now proceed to add details from the record
			dno := FieldByName('Document_ID').AsInteger;

			// -- We are going to store the document number as a pointer
			p := Pointer(dno);

			// -- Now create the node for the item
			NewNode	:= TreeView.Items.AddChildObject(StatusNode,FieldByName('name').AsString + ' ' + FieldByName('document_reference').AsString,p);

			NewNode.ImageIndex := 1;
			NewNode.SelectedIndex := 2;

			// -- Choose either the first document, or the displayable document
			if ((firstDoc = -1) and (showDocument = -1)) or
			   ((showDocument <> -1) and (showDocument = dno)) then
			begin
				firstDoc := dno;
				SelNode  := NewNode;
			end;

			Next;
		end;

	end;

	// -- Now after we have loaded, look for the item to select
	if (ShowDocument <> -1) then
	begin
		p := Pointer(ShowDocument);
		for xc := 1 to Treeview.Items.Count do
		begin
			if Treeview.Items[xc-1].Data = p then
			begin
				Treeview.Selected := Treeview.Items[xc-1];
				firstDoc := ShowDocument;
				break;
			end;
		end;
	end
	else if Assigned(followUpNode) then
		Treeview.Selected := followUpNode;

	// -- Now notify the caller that we have selected a document
	if (Assigned(fOnDocSelect)) then
		fOnDocSelect(Self,firstDoc);

	// -- Set the node at the top
	if Assigned(followUpNode) then
	begin
		TreeView.TopItem := followUpNode;
	end
	else if Assigned(jobNode) then
	begin
		TreeView.TopItem := jobNode;
	end
	else if Assigned(PONode) then
	begin
		TreeView.TopItem := PONode;
	end
	else if Assigned(QNode) then
	begin
		TreeView.TopItem := QNode;
	end;

	// -- Open up nodes for easy viewing
	if Assigned(followUpNode) then
		followupNode.Expand(False);
	if Assigned(jobNode) then
		jobNode.Expand(False);
	if Assigned(ServicejobNode) then
		ServicejobNode.Expand(False);
	if Assigned(PONode) then
		PONode.Expand(False);
	if Assigned(QNode) then
		QNode.Expand(False);
	if Assigned(InvNode) then
		InvNode.Expand(False);

	// -- Open up only the topmost nodes
	{
	LoadPurchaseOrders;
	LoadInvoices;
	LoadQuotes;
	}

	{$ENDIF}
end;

procedure TRegistryNavigator.LoadJobs;
var
	JobNameNode,
	DocStatusNode,
	NewNode			: TTreeNode;
	lastjob			: Integer;
	laststatus,s	: String;
	p : Pointer;
	dno : Integer;
begin
	if (not Assigned(fDocuments)) or (not Assigned(jobNode)) then
		Exit;

	// -- Delete all the children on the node
	jobNode.DeleteChildren;

	{$IFNDEF LIGHTWEIGHT}
	with qryGetInfo do
	begin
		Active := False;
		DatabaseName := fDocuments.DatabaseName;
		DatabaseName := GTD_ALIAS;

		SQL.Clear;
		SQL.Add('SELECT');
		SQL.Add('	jd.job_number,');
		SQL.Add('	j.name job_name,');
		SQL.Add('	td.document_name,');
		SQL.Add('	td.document_reference,');
		SQL.Add('	td.local_status_code,');
		SQL.Add('	t.name trader_name,');
		SQL.Add('	jd.document_id');
		SQL.Add('FROM');
		SQL.Add('	job_documents jd,');
		SQL.Add('	trader_documents td,');
		SQL.Add('	trader t,');
		SQL.Add('	job j');
		SQL.Add('where');
		SQL.Add('	(jd.Document_ID = td.Document_id) and');
		SQL.Add('	(td.shared_with = t.trader_id) and');
		SQL.Add('	(jd.job_number = j.job_number) and');
		SQL.Add('	(j.status_code = "Active")');
		SQL.Add('order by');
		SQL.Add('	jd.job_number,');
		SQL.Add('	td.document_name,');
		SQL.Add('	t.name,');
		SQL.Add('	td.local_status_code,');
		SQL.Add('	td.document_reference');

		Active := True;

		lastjob := -1;
		laststatus := '';

		First;
		while not Eof do
		begin

			if lastjob <> FieldByName('job_number').AsInteger then
			begin
				lastjob := FieldByName('job_number').AsInteger;
				if Assigned(JobNode) then
				begin
					JobNameNode	:= TreeView.Items.AddChild(JobNode,FieldByName('job_name').AsString);
					JobNameNode.ImageIndex := dnvImageJobType;
					JobNameNode.SelectedIndex := dnvImageJobType;
				end;
				lastStatus := '';
			end;

			if lastStatus <> FieldByName('local_status_code').AsString then
			begin
				lastStatus := FieldByName('local_status_code').AsString;
				if Assigned(JobNameNode) then
				begin
					DocStatusNode	:= TreeView.Items.AddChild(JobNameNode,FieldByName('local_status_code').AsString);
					DocStatusNode.ImageIndex := dnvImageStatusType;
				end;
			end;

			dno := FieldByName('Document_ID').AsInteger;

			// -- We are going to store the document number as a pointer
			p := Pointer(dno);

			// -- Build the display name
			if FieldByName('Document_Name').AsString = 'Purchase Order' then
				s := 'PO ' +
					 FieldByName('Document_Reference').AsString + ' ' +
					 FieldByName('trader_name').AsString
			else
				s := FieldByName('Document_Name').AsString + ' ' +
					 FieldByName('Document_Reference').AsString + ' ' +
					 FieldByName('trader_name').AsString;

			NewNode	:= TreeView.Items.AddChildObject(DocStatusNode,s,p);

			NewNode.ImageIndex := 1;
			NewNode.SelectedIndex := 2;

			Next;
		end;

	end;
	{$ENDIF}
	
end;

procedure TRegistryNavigator.LoadServiceJobs;
var
	JobNameNode,
	DocStatusNode,
	NewNode			: TTreeNode;
	laststatus,s	: String;
	p : Pointer;
	dno : Integer;
begin
	if (not Assigned(fDocuments)) or (not Assigned(ServicejobNode)) then
		Exit;

	// -- Delete all the children on the node
	ServicejobNode.DeleteChildren;

	// --
	if not fJobSupport then
		// -- Job table won't exist
		Exit;

	{$IFNDEF LIGHTWEIGHT}
	try
		with qryGetInfo do
		begin
			Active := False;
			DatabaseName := fDocuments.DatabaseName;
			DatabaseName := GTD_ALIAS;

			SQL.Clear;
			SQL.Add('SELECT');
			SQL.Add('	jd.job_number,');
			SQL.Add('	j.name job_name,');
			SQL.Add('	td.document_name,');
			SQL.Add('	td.document_reference,');
			SQL.Add('	td.local_status_code,');
			SQL.Add('	t.name trader_name,');
			SQL.Add('	jd.document_id');
			SQL.Add('FROM');
			SQL.Add('	job_documents jd,');
			SQL.Add('	trader_documents td,');
			SQL.Add('	trader t,');
			SQL.Add('	job j');
			SQL.Add('where');
			SQL.Add('	(jd.Document_ID = td.Document_id) and');
			SQL.Add('	(td.shared_with = t.trader_id) and');
			SQL.Add('	(td.document_name = "Invoice") and');
			SQL.Add('	(jd.job_number = j.job_number) and');
			SQL.Add('	(j.status_code = "Active")');
			SQL.Add('order by');
			SQL.Add('	td.local_status_code,');
			SQL.Add('	jd.job_number,');
			SQL.Add('	t.name,');
			SQL.Add('	td.document_reference');

			Active := True;

			laststatus := '';

			First;
			while not Eof do
			begin

				if lastStatus <> FieldByName('local_status_code').AsString then
				begin
					lastStatus := FieldByName('local_status_code').AsString;
					DocStatusNode	:= TreeView.Items.AddChild(ServicejobNode,FieldByName('local_status_code').AsString);
					DocStatusNode.ImageIndex := dnvImageStatusType;
				end;

				dno := FieldByName('Document_ID').AsInteger;

				// -- We are going to store the document number as a pointer
				p := Pointer(dno);

				// -- Build the display name
				s := FieldByName('trader_name').AsString;

				NewNode	:= TreeView.Items.AddChildObject(DocStatusNode,s,p);

				NewNode.ImageIndex := 1;
				NewNode.SelectedIndex := 2;

				Next;
			end;

		end;
	except
	end;
	{$ENDIF}
end;

procedure TRegistryNavigator.LoadPurchaseOrders;
var
	NewNode			: TTreeNode;
begin
	if (not Assigned(fDocuments)) or (not Assigned(jobNode)) then
		Exit;

	// -- Delete all the children on the node
	PONode.DeleteChildren;

	{$IFNDEF LIGHTWEIGHT}
	with qryGetInfo do
	begin
		Active := False;
		DatabaseName := fDocuments.DatabaseName;
		DatabaseName := GTD_ALIAS;

		SQL.Clear;
		SQL.Add('SELECT');
		SQL.Add('	 distinct local_status_code');
		SQL.Add('FROM');
		SQL.Add('	trader_documents td');
		SQL.Add('where');
		SQL.Add('	(Document_Name = "' + GTD_ORDER_TYPE + '")');
		SQL.Add('	and (td.local_status_code <> "Complete")');

		Active := True;

		First;
		while not Eof do
		begin

			NewNode	:= TreeView.Items.AddChild(PONode,FieldByName('local_status_code').AsString);

			Next;
		end;

	end;
    {$ENDIF}
end;

procedure TRegistryNavigator.LoadInvoices;
begin
end;

procedure TRegistryNavigator.LoadQuotes;
begin
end;

procedure TRegistryNavigator.SetSkinData(NewSkin : TbsSkinData);
begin
	TreeView.SkinData := NewSkin;
	sbVert.SkinData := NewSkin;
	lblJumpTo.SkinData := NewSkin;
	txtJumpTo.SkinData := NewSkin;

	fSkinData := NewSkin;
end;

procedure TRegistryNavigator.FrameResize(Sender: TObject);
begin
	Treeview.Height := ClientHeight - Treeview.Top;
	Treeview.Width  := ClientWidth - sbVert.Width;
	sbVert.Left   := TreeView.Left + TreeView.ClientWidth;
	sbVert.Height := TreeView.Height;

	lblJumpTo.Width := ClientWidth;
	txtJumpTo.Width := ClientWidth;

end;

procedure TRegistryNavigator.TreeViewClick(Sender: TObject);
var
	p : Pointer;
	dno : Integer;
begin
	if Assigned(fOnDocSelect) then
	begin
		if Assigned(TreeView.Selected) then
		begin
			p := TreeView.Selected.Data;
			dno := Integer(p);
			if (Assigned(p)) and (Assigned(fOnDocSelect)) then
				fOnDocSelect(Sender,dno);
		end;
	end;
end;

procedure TRegistryNavigator.txtJumpToKeyPress(Sender: TObject;
  var Key: Char);
begin
	// --
	if (Key = #13) then
	begin
		If Assigned(fOnSearchText) then
		begin
			// -- Run the even
			fOnSearchText(Sender,txtJumpTo.Text);
			txtJumpTo.Text := '';
		end;
	end;
end;

end.
