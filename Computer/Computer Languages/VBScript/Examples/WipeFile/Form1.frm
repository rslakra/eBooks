VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "WipeFile - For a secure file deletion!"
   ClientHeight    =   510
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3315
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   510
   ScaleWidth      =   3315
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2880
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Delete File After Prepared"
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   240
      Value           =   1  'Checked
      Width           =   3375
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Prepare File for Secure Deletion"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   3375
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Sub Wipe(FileName As String)
On Error GoTo err
  Dim Part1 As String
  Dim hFileHandle As Integer, i As Long
  Const SIZE = 1024
  Part1 = String(SIZE, "#")
  hFileHandle = FreeFile
    
    Open FileName For Binary As hFileHandle
    For i = 1 To hFileHandle
    Put hFileHandle, , Part1
    Next i
    Close hFileHandle
Exit Sub
err:
   Exit Sub
End Sub

Private Sub Command1_Click()
CommonDialog1.ShowOpen
Wipe CommonDialog1.FileName
MsgBox "Task Preparation Completed", vbInformation, "WipeFile"
If Check1.Value = 1 Then
Kill CommonDialog1.FileName
MsgBox "File Deleted Safely", vbInformation, "WipeFile"
End If
End Sub
