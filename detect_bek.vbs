Function GetRemovableDriveLetter (label)
    GetRemovableDriveLetter = ""
    Dim drive
    For Each drive In CreateObject("Scripting.FileSystemObject").Drives
        If drive.IsReady Then
            If drive.DriveType = 1 And drive.VolumeName = label Then
                GetRemovableDriveLetter = drive.DriveLetter
                Exit Function
            End If
        End If
    Next
End Function 

Do While GetRemovableDriveLetter("BEK")<>""
    MsgBox vbcrlf & "    You MUST remove the Bitlocker Startup USB Key.     " & _
      vbcrlf & vbcrlf & vbcrlf & vbcrlf & vbcrlf & _
      "    Remove the USB key and press 'OK' to continue." & _
      vbcrlf & vbcrlf & vbcrlf, 4112, "Security Error"
Loop
