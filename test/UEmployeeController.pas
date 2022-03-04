(*
/// -------------------------------------------------
/// Code by Warapetch  Ruangpornvisuthi
/// Thailand
/// 03/03/2565
/// -------------------------------------------------
*)
unit UEmployeeController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  MVCFramework.Serializer.Commons ,
  FireDAC.Comp.Client, // tmpQuery
  Data.DB;

type

  [MVCPath('/api')]   // "/"
  TEmployeeController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;
  private
    tmpQuery : TFDQuery;
    function GetData(sql: String): TDataset;
    function ExecSQL(action, sql: String): String;

    function RequestFindKey(KeyName: String): Boolean;
    procedure RenderDataset(AData: TDataset);
	procedure RequestImage(FullPathFileName : String);
    procedure DownloadFile(AHttpContentType, AFoloder, AFileName: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    //Sample CRUD Actions for a "Employee" entity
    [MVCPath('/employees')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmployees;

    [MVCPath('/employee/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmployee(id: Integer);

    [MVCPath('/employee')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateEmployee;

    [MVCPath('/employee/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateEmployee(id: Integer);

    [MVCPath('/employee/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteEmployee(id: Integer);

    [MVCPath('/employee/upload/($imagetype)/($id)')]
    [MVCHTTPMethod([httpPOST])]
    procedure UploadFile(imageType : String;id: Integer);

//    [MVCPath('/employee/image/($id)')]
//    [MVCHTTPMethod([httpGET])]
//    procedure GetEmployeeFile(id: Integer);

    [MVCPath('/employee/imagefile/($imagetype)/($id)/($filename)')]
    [MVCHTTPMethod([httpGET])]
    procedure RequestImageFileName(imageType : String;id : integer;filename : String);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils,
  Windows, // font Color in console
  System.Classes, System.IOUtils ,
  UDatamodule
  ;


procedure TEmployeeController.RenderDataset(AData : TDataset);
begin
    // send to Client
    if AData.RecordCount > 0 then
       Render(AData)
    else
    Render('{"message": "Record not Found !!"}');

    // Global Dataset
    if tmpQuery <> NIL then
       tmpQuery := NIL;

    // this Dataset
    AData := NIL;
end;

function TEmployeeController.GetData(sql : String) : TDataset;
begin
    // Create Temp-Query
    tmpQuery := TFDQuery.Create(NIL);
    tmpQuery.Connection := DMmain.FDconn;
    // Open Dataset
    tmpQuery.Open(sql);

    result := tmpQuery;
    // Free at @RenderDataset
end;


function TEmployeeController.ExecSQL(action,sql : String) : String;
var iAffect : Integer;
begin
    // Create Temp-Query
    tmpQuery := TFDQuery.Create(NIL);
    tmpQuery.Connection := DMMain.FDconn;

    // ExecSQL
    iAffect := tmpQuery.ExecSQL(sql); // RowAffect

    // Result String
	result := '{"message" : "'+action+' success" , "affect" : '+IntToStr(iAffect)+'}' ;

    // Free tmpQuery
    FreeAndNil(tmpQuery);
end;

procedure TEmployeeController.Index;
begin
  //use Context property to access to the HTTP request and response 
  Render('สวัสดีชาวโลก "DelphiMVCFramework" ');
end;


procedure TEmployeeController.OnAfterAction(Context: TWebContext; const AActionName: string);
var I : Integer;
begin
  { Executed after each action }
  inherited;

    // ทดสอบสี ตัวอักษร
    for I := 1 to 254 do
	   begin
          SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),I);
          Writeln('Test Color '+IntTostr(I))
       end;

    case Context.Request.HTTPMethod of
        httpGET    : SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),6);
        httpPOST   : SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),2);
        httpPUT    : SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),3);
        httpDELETE : SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),12);
        else
		SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),7);
    end;

    // display at Console
	Writeln('Client : '+Context.Request.ClientIp+' > '+
					    '['+Context.Request.HTTPMethodAsString+']'+
    					Context.Request.PathInfo+ ' : '+
                        InttoStr(Context.Response.StatusCode));

end;

procedure TEmployeeController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Employee" entity
procedure TEmployeeController.GetEmployees;
var sql : String;
begin
  //todo: render a list of Employees
    sql := 'select * from employee ';

    RenderDataset(GetData(SQL));
end;

procedure TEmployeeController.GetEmployee(id: Integer);
var sql : String;
begin
  //todo: render the Employee by id
    sql := 'select * from employee where emp_code = '+IntToStr(id);

    RenderDataset(GetData(SQL));
end;

function TEmployeeController.RequestFindKey(KeyName : String) : Boolean;
begin
  	//result := ARequest.ContentFields.ContainsKey(KeyName);
    result := Context.Request.ContentFields.ContainsKey(KeyName)
end;


procedure TEmployeeController.CreateEmployee;
var sId,sName,sPhone,sImage,
	sql ,result : String;
begin

  //todo: create a new Employee
  // ----------------------------------
  // uses x-www-form-urlencoded
  // ----------------------------------
  	sId    := Context.Request.ContentFields.Items['emp_code'];
  	sName  := Context.Request.ContentFields.Items['emp_name'];
    sPhone := '';
    sImage := '';
    if RequestFindKey('emp_phone') then
  	   sPhone := Context.Request.ContentFields.Items['emp_phone'];
    if RequestFindKey('emp_image') then
  	   sImage := Context.Request.ContentFields.Items['emp_image'];

    sql := 'insert into employee (emp_code,emp_name,emp_phone,emp_image) values ('+
            #39+sId+#39+','+
            #39+sName+#39+','+
            #39+sPhone+#39+','+
            #39+sImage+#39+')';

    result := ExecSQL('Create',sql);

  	Render(result);
end;

procedure TEmployeeController.UpdateEmployee(id: Integer);
var //sId,
	sName,sPhone,sImage,sql : String;
	result : string;
    iNeedUpdate : smallint;

    function checkNeedUpdate(fieldname,value : String) : string;
    begin
        result := '';
        if Trim(value) <> '' then
           begin
              if iNeedUpdate = 0 then
                result := ' '+fieldname+' = '+#39+value+#39
              else
                result := ' , '+fieldname+' = '+#39+value+#39;

              iNeedUpdate := iNeedUpdate + 1;
           end;
    end;

begin
  //todo: update Employee by id
    //-------------------------------
	// uses x-www-form-urlencoded
    //-------------------------------
  iNeedUpdate := 0;

  // get Value from Form
  if RequestFindKey('emp_name') then
     sName  := Context.Request.ContentFields.Items['emp_name'];
  if RequestFindKey('emp_phone') then
	 sPhone := Context.Request.ContentFields.Items['emp_phone'];
  if RequestFindKey('emp_image') then
     sImage := Context.Request.ContentFields.Items['emp_image'];

    sql := 'update employee set  '+
            checkNeedUpdate('emp_name',sName)+
            checkNeedUpdate('emp_phone',sPhone)+
            checkNeedUpdate('emp_image',sImage)+
		    ' where emp_code = '+IntToStr(id) ;

	result := '';
	if iNeedUpdate > 0 then
       result := ExecSQL('Update',sql);

  Render(result);
end;

procedure TEmployeeController.DeleteEmployee(id: Integer);
var sql,result : String;
begin
  //todo: delete Employee by id
	sql := 'delete from employee where emp_code = '+IntToStr(id);
	result := ExecSQL('Delete',sql);
  	Render(result);
end;

procedure TEmployeeController.UploadFile(imageType : String;id: Integer);
var FileName: string;
    FileStream: TFileStream; //System.Classes.TFileStream
    I : Integer;
    DestFolder : string; //System.IOUtils.TFile

begin
    // 6503-04 21.30
    // แยกโฟลเดอร์ ในการทำงานโดยให้ส่ง imageType เข้ามา
	// imageType >> 'emp' , 'product' , 'member'
    // กำหนด Foloder ตามต้องการ
	DestFolder := 'D:\delphi_basic\delphi_rest_api\DMVC\Win32\Debug\images\'+imageType+'\';
    //-------------------------------
    // use Form-Data Only !!
    //-------------------------------
  	for I := 0 to Context.Request.RawWebRequest.Files.Count - 1 do
  	   begin
    		FileName := String(Context.Request.Files[I].FileName);
    		FileStream := TFile.Create(DestFolder+FileName);
    		try
      			FileStream.CopyFrom(Context.Request.Files[I].Stream, 0);
    		finally
      			FileStream.Free;

                // Notify to client
                Render('File "'+FileName+'" is Uploaded ..');

//               test send Image to client
//                if (ExtractFileExt(FileName) = '.png') or
//                   (ExtractFileExt(FileName) = '.jpg') then
//                	// render to client
//                	RequestImage(DestFolder+FileName);
    		end;
  		end;

end;

procedure TEmployeeController.DownloadFile(AHttpContentType,AFoloder,AFileName : String);
var LFile: TFileStream;
begin
    LFile := TFileStream.Create(AFoloder+AFileName, fmOpenRead or fmShareDenyWrite);
    //LFile.Position := 0;
    //LFile.Seek(0, 0);

    ContentType := AHttpContentType;
	// https://www.geeksforgeeks.org/http-headers-content-type/
    // Application ,Audio ,Image ,Image , Video
    // 'image/jpeg'  'image/png'  'text/csv'

    // Error ' Invalid ZStream operation ' >> Ignore !!
    // Delphi bug >> https://quality.embarcadero.com/browse/RSP-35516
    Render(LFile, True);
end;

procedure TEmployeeController.RequestImage(FullPathFileName : String);
begin
	DownloadFile('image/png','',FullPathFileName);
end;

procedure TEmployeeController.RequestImageFileName(imageType : String;id : integer;FileName : String);
var DestFolder : string;
begin
    // 6503-04 21.30
    // แยกโฟลเดอร์ ในการทำงานโดยให้ส่ง imageType เข้ามา
	// imageType >> 'emp' , 'product' , 'member'
	DestFolder := 'D:\delphi_basic\delphi_rest_api\DMVC\Win32\Debug\images\'+imageType+'\';
	DownloadFile('image/png',DestFolder,FileName);
end;

end.
