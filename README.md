# ทดสอบ DMVC RestAPI
## ทดสอบเครื่องมือของเดลไฟ ที่ใช้พัฒนา
Rest API ด้วย DelphiMVCFramework <BR>

📌 GitHub >> [Delphimvcframework](https://github.com/danieleteti/delphimvcframework)    
  
รูปแบบ
- ไม่ใช้ Model  
- Render โดยใช้ TDataset

    โค้ดในส่วนของการอัพโหลดไฟล์ <BR>
    #UploadFile <BR>
  ``` pascal
    procedure TEmployeeController.UploadFile(imageType : String;id:> Integer);
    var FileName: string;
        FileStream: TFileStream; //System.Classes.TFileStream
        I : Integer;
        DestFolder : string; //System.IOUtils.TFile
    begin
         // 6503-04 21.30<BR>
         // แยกโฟลเดอร์ ในการทำงานโดยให้ส่ง imageType เข้ามา
         // imageType >> 'emp' , 'product' , 'member'
         // กำหนด Foloder ตามต้องการ
         DestFolder := '...\images\\'+imageType+'\\';
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
     		    end;
     	    end;
         end;
    ```


🔷 แผนภูมิระบบ<BR>

<img src="https://user-images.githubusercontent.com/6521378/156784812-e15176d8-fa5f-4d66-ab73-9e52fcd8b8d5.png" alt="drawing" width="450"/>

* สามารถกำหนด รูปแบบ Controller และ Method.Handler ได้เอง
- รวมใน 1 ไฟล์ หรือ แยกกัน



<BR>

🔷 Video Youtube <BR>
📌 วีดีโอ EP16 ตอน 5 ทดสอบ Rest API <BR>
[![cover](http://img.youtube.com/vi/f44fSrBcUXM/0.jpg)](http://www.youtube.com/watch?v=f44fSrBcUXM "Click to Play Video")

  
📌 วีดีโอ EP16 ตอน 6 อธิบายโค้ด <BR>
[![cover](http://img.youtube.com/vi/n6vTwOf1lz0/0.jpg)](http://www.youtube.com/watch?v=n6vTwOf1lz0 "Click to Play Video")

  
🔷 FaceBook <BR>
https://www.facebook.com/born2dev

🔷 YouTube <BR>
https://www.youtube.com/c/HowToCodeDelphi
