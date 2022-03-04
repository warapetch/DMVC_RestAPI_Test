object DMmain: TDMmain
  Height = 201
  Width = 389
  PixelsPerInch = 96
  object FDconn: TFDConnection
    Params.Strings = (
      
        'Database=D:\delphi_basic\dmvc_rest_api\DMVC\Win32\Debug\data\EMP' +
        '.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
end
