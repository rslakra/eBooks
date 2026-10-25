# Visual Basic 6 Notes

Quick notes and code snippets for working with databases and reports in VB6.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Connect to a database (DAO)](#connect-to-a-database-dao)
- [Find a record](#find-a-record)
- [Create a Data Report](#create-a-data-report)
- [Common mistakes](#common-mistakes)
- [Helpful Links](#helpful-links)

---

## Prerequisites

Add the DAO library before using `Database` and `Recordset`:

**Project > References > Microsoft DAO 3.6 Object Library** (or 3.51 for older Access 97 databases)

The examples use an Access database named `Forests.mdb`, with a table named `Circles`, in the application folder.

---

## Connect to a database (DAO)

Open the database and a recordset in the form's `Load` event. Declare `db` and `rs` at **module level** (the top of the form) so other procedures, such as the seek example below, can use them.

```vb
' Form-level (General Declarations)
Private db As Database
Private rs As Recordset

Private Sub Form_Load()
    Dim strDbName As String
    Dim strRsName As String
    Dim recCount  As Long

    strDbName = App.Path & "\Forests.mdb"
    strRsName = "Circles"

    Set db = DBEngine.OpenDatabase(strDbName)
    Set rs = db.OpenRecordset(strRsName, dbOpenDynaset)

    With rs
        If Not (.BOF And .EOF) Then   ' make sure the recordset isn't empty
            .MoveLast                 ' needed to get an accurate RecordCount
            recCount = .RecordCount
            .MoveFirst
        End If
    End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ' Release resources
    If Not rs Is Nothing Then rs.Close
    If Not db Is Nothing Then db.Close
End Sub
```

### Recordset types

| Constant | Type | Notes |
|---|---|---|
| `dbOpenTable` | Table | Fastest; supports `Seek` and indexes |
| `dbOpenDynaset` | Dynaset | Updatable query results; supports `FindFirst` |
| `dbOpenSnapshot` | Snapshot | Read-only copy; good for reports and lists |

---

## Find a record

### Option 1: `Seek` (table recordsets only)

`Seek` is the fastest search, but it **only works on a `dbOpenTable` recordset and needs an index set first**. It won't work on the dynaset opened above.

```vb
Private Sub cmdSeek_Click()
    ' Use the Seek method to locate a record
    Dim strSeek As String

    strSeek = Trim(InputBox("Enter an Author ID Seek Value:", "Table Seek", "10"))

    If strSeek <> "" Then
        rs.Index = "PrimaryKey"          ' the index to search on
        rs.Seek "=", strSeek

        If rs.NoMatch Then
            MsgBox "Unable to locate [" & strSeek & "]", vbExclamation, "Table Seek Failed"
        Else
            ReadRow                      ' your own routine that loads the current row into the form
            MsgBox "Found [" & strSeek & "]", vbInformation, "Table Seek Succeeded"
        End If
    End If
End Sub
```

To use it, open the recordset as a table:

```vb
Set rs = db.OpenRecordset("Circles", dbOpenTable)
```

### Option 2: `FindFirst` (dynaset or snapshot)

```vb
Private Sub cmdFind_Click()
    Dim strFind As String

    strFind = Trim(InputBox("Enter an Author ID:", "Find", "10"))

    If strFind <> "" Then
        rs.FindFirst "AuthorID = " & strFind      ' numeric field
        ' rs.FindFirst "Name = '" & strFind & "'" ' text field: wrap in single quotes

        If rs.NoMatch Then
            MsgBox "Unable to locate [" & strFind & "]", vbExclamation, "Find Failed"
        Else
            ReadRow
        End If
    End If
End Sub
```

| Method | Works on | Speed | Needs index |
|---|---|---|---|
| `Seek` | Table | Fast | Yes |
| `FindFirst` / `FindNext` | Dynaset, Snapshot | Slower | No |

---

## Create a Data Report

### Step 1: Add a Data Environment

1. In the **Project Explorer**, right-click the project and choose **Add > Data Environment**.
   (If it isn't listed, enable it under **Project > Components > Designers > Data Environment**.)
2. In the **Data Link Properties** dialog, on the **Provider** tab, select **Microsoft Jet 4.0 OLE DB Provider**.
3. On the **Connection** tab, select your database (e.g. `Forests.mdb`), then click **Test Connection** and **OK**.

### Step 2: Add a command

1. Right-click the **Connection** and choose **Add Command**.
2. Right-click the new command and choose **Properties**.
3. Set the command name, e.g. `cmdCircles`.
4. Select **SQL Statement** and write the query:
   ```sql
   SELECT * FROM Circles;
   ```
   Use the **table name** from the database here.
5. Click **Apply**, then **OK**.

### Step 3: Add the Data Report

1. In the **Project Explorer**, right-click the project and choose **Add > Data Report**.
2. Set these properties of the report:

   | Property | Value |
   |---|---|
   | `DataSource` | Your Data Environment, e.g. `DataEnvironment1` |
   | `DataMember` | The command name, e.g. `cmdCircles` |

3. Drag fields from the command in the Data Environment onto the report's **Detail** section, or add `RptTextBox` controls and set their `DataField`.
4. Show the report from code:

   ```vb
   Private Sub cmdReport_Click()
       DataReport1.Show
   End Sub
   ```

---

## Common mistakes

| Mistake | Fix |
|---|---|
| Comments written with a backtick (`` ` ``) | VB6 comments start with an apostrophe (`'`) |
| `Dim rs As RecordSource` | The type is `Recordset` |
| `Dim a, b As String` | Only `b` is a `String`; `a` is a `Variant`. Declare each variable with its own type |
| `int recCount = .RecordCount` | Not VB syntax. Use `Dim recCount As Long` then `recCount = .RecordCount` |
| `dbopendynaset` | Constants are written `dbOpenDynaset` (VB is case-insensitive, but keep the standard casing) |
| `Seek` on a dynaset | Use a `dbOpenTable` recordset with `.Index` set, or use `FindFirst` |
| Reading `RecordCount` without `MoveLast` | Call `.MoveLast` first, or the count may be too low |
| Not closing the recordset and database | Call `.Close` in `Form_Unload` |

---

## Helpful Links

| Resource | Description |
|---|---|
| [DevGuru VBScript reference (archived, 2012)](https://web.archive.org/web/20121226171440/http://devguru.com:80/technologies/vbscript/home.asp) | VBScript reference with examples. The original site, `devguru.com`, is gone, and this is a dated Wayback Machine snapshot |
| [VBScript language reference (Microsoft Learn)](https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/d1wf56tt%28v=vs.84%29) | Official VBScript reference (archived) |
| [Visual Basic 6.0 documentation (Microsoft Learn)](https://learn.microsoft.com/en-us/previous-versions/visualstudio/visual-basic-6/visual-basic-6.0-documentation) | Official VB6 documentation (archived) |
| [VBA language reference (Microsoft Learn)](https://learn.microsoft.com/en-us/office/vba/api/overview/) | Reference for VBA, which shares most of its syntax with VB6 |
