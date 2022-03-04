# ทดสอบ DMVC RestAPI
## ทดสอบเครื่องมือของเดลไฟ ที่ใช้พัฒนา
Rest API ด้วย DelphiMVCFramework <BR>

📌 GitHub >> [Delphimvcframework](https://github.com/danieleteti/delphimvcframework)    
  
รูปแบบ
- ไม่ใช้ Model  
- Render โดยใช้ TDataset

    โค้ดในส่วนของการอัพโหลดไฟล์ <BR>
    #UploadFile <BR>
    procedure TEmployeeController.UploadFile(imageType : String;id: Integer);<BR>
    var FileName: string;<BR>
        FileStream: TFileStream; //System.Classes.TFileStream<BR>
        I : Integer;<BR>
        DestFolder : string; //System.IOUtils.TFile<BR>
    <BR>
    begin<BR>
        // 6503-04 21.30<BR>
        // แยกโฟลเดอร์ ในการทำงานโดยให้ส่ง imageType เข้ามา<BR>
	    // imageType >> 'emp' , 'product' , 'member'<BR>
        // กำหนด Foloder ตามต้องการ<BR>
	    DestFolder := '...\images\'+imageType+'\';<BR>
        //-------------------------------<BR>
        // use Form-Data Only !!<BR>
        //-------------------------------<BR>
  	    for I := 0 to Context.Request.RawWebRequest.Files.Count - 1 do<BR>
  	        begin<BR>
    		    FileName := String(Context.Request.Files[I].FileName);<BR>
    		    FileStream := TFile.Create(DestFolder+FileName);<BR>
    		    try<BR>
      			    FileStream.CopyFrom(Context.Request.Files[I].Stream, 0);<BR>
    		    finally<BR>
      			    FileStream.Free;<BR>
                    <BR>
                    // Notify to client<BR>
                    Render('File "'+FileName+'" is Uploaded ..');<BR>
    		    end;<BR>
  		    end;<BR>
        end;<BR>



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
