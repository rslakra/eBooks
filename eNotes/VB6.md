# VB-6 (VISUAL BASIC 6)

---

## Visual Basic


--- 
#### To add Data Report in Visual Basic 6.0 follow the steps:

    1. Properties Window -> Data Environment by Right Clicking -> Add
    2. In Data Link Properties dialog box Set Connection By Jet 4.0 OLE DB Provider.
    3. Select Database.
    4. Right Click on Connection and choose
        - Add Command Button
        - Command Properties Dialog Box
        - Command Name -> Link <Table Name>
        - Choose option 'SQL Statement; and Write Query
            - (Write Table Name in query not of database with ';')
        - Apply Click and Ok
    5. Right Click in Project Explorer.
    - Add Report by Clicking on Data Report Option
    - Set Properties of Data Report
    - Choose Data Source, Member

---
#### Database ```Form_Load``` Event

```shell
  private sub Form_Load()
  dim db as Database
  dim rs as RecordSource
  Dim dbName, tableName as String
  dbName = app.path & "\Users.mdb"
  tableName = "Users"

  set db = DBEngine.OpenDatabase(dbName)
  set rs = db.openrecordset(tableName, dbopendynaset)
  with rs
  .movelast
  int recCount = .recordcount
  end with
  End Sub
```

---
######## Use the ```seek``` method to locate a record
```shell
'
' use the seek method to locate a record
'
Private Sub cmdSeek_Click()
    Dim findText As String
  
    findText = InputBox("Enter an Author ID Seek Value:", "Table Seek", "10")
    findText = Trim(findText)
    
    If findText <> "" Then
        rs.Seek "=", findText
        If rs.NoMatch = True Then
            MsgBox "Unable to locate [" & findText & "]", vbExclamation, "Table Seek Failed"
        Else
            ReadRow
            MsgBox "Found [" & findText & "]", vbInformation, "Table Seek Succeeded"
        End If
    End If
    
End Sub 
```


---

# Author

- Rohtash Lakra
