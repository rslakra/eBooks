VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   735
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4110
   LinkTopic       =   "Form1"
   ScaleHeight     =   735
   ScaleWidth      =   4110
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command3 
      Caption         =   "Ignore Error"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   360
      Width           =   4095
   End
   Begin VB.CommandButton Command2 
      Caption         =   "If number then Description"
      Height          =   375
      Left            =   1920
      TabIndex        =   1
      Top             =   0
      Width           =   2175
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Number and Description"
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   1935
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
On Error GoTo ErrorHandler
Error 424 'This error is displayed when there is a missing object
Exit Sub
ErrorHandler:
MsgBox "Error Number: " & Err.Number & " With The Description ->> " & Err.Description & " <<- Occured."
End Sub

Private Sub Command2_Click()
On Error GoTo ErrorHandler
Error 424
Exit Sub
ErrorHandler:
If Err.Number = 424 Then
MsgBox "A missing object in your form is needed!, Please refer to the code and arrange accordingly!"
Else: MsgBox "Error Number: " & Err.Number & " With The Description ->> " & Err.Description & " <<- Occured."
End If
End Sub

Private Sub Command3_Click()
On Error Resume Next
Error 424 'This error is displayed when there is a missing object
MsgBox "error ignored!"
End Sub
