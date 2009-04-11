'Source Code created on 11 Apr 2009 02:26:04 with Logic Gui Version 4.1 Build 366
'Christiaan Kras
'Start of external Header File
SuperStrict

Import MaxGui.Drivers			'Comment this line if you don't want to use the new MaxGuiEx
'Import LogicZone.SmartButtons	'Uncomment this line when you want to use SmartButtons	
'Import MaxGUI.ProxyGadgets 		'Uncomment when using a proxy gadget
Import htbaapub.xmlrpc

'End Of external Header File


Local	GadgetList:TList = New TList
Const	Disable:Int=1
Const	Enable:Int=2
Const	Hide:Int=3
Const	Show:Int=4
Const	Check:Int=5
Const	Uncheck:Int=6
Const	Free:Int=7
Const	SetText:Int=8
Const	Activate:Int=9
Const	Redraw:Int=10
Const	RemoveFromList:Int=11
Const	GetGadgetHandle:Int=12

Local Window1:TGadget = CreateWindow:TGadget("XML-RPC GUI - ",444,154,448,499,Null,WINDOW_TITLEBAR|WINDOW_STATUS |WINDOW_CLIENTCOORDS )
	GadgetList.AddLast( Window1:TGadget ) ; Window1.Context="Window1"
	Local Group2:TGadget = CreatePanel:TGadget(4,7,237,160,Window1:TGadget,PANEL_GROUP|PANEL_ACTIVE,"XML-RPC Service")
		GadgetList.AddLast( Group2:TGadget ) ; Group2.Context="Group2"
		SetGadgetLayout( Group2:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local TxtHost:TGadget = CreateTextField:TGadget(70,19,153,18,Group2:TGadget,Null)
			SetGadgetText( TxtHost:TGadget,"php.htbaa.com")
			GadgetList.AddLast( TxtHost:TGadget ) ; TxtHost.Context="TxtHost"
			SetGadgetLayout( TxtHost:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local TxtPath:TGadget = CreateTextField:TGadget(70,53,153,18,Group2:TGadget,Null)
			SetGadgetText( TxtPath:TGadget,"/xmlrpc")
			GadgetList.AddLast( TxtPath:TGadget ) ; TxtPath.Context="TxtPath"
			SetGadgetLayout( TxtPath:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local TxtFunction:TGadget = CreateTextField:TGadget(70,87,153,18,Group2:TGadget,Null)
			SetGadgetText( TxtFunction:TGadget,"funcs.somefunc4")
			GadgetList.AddLast( TxtFunction:TGadget ) ; TxtFunction.Context="TxtFunction"
			SetGadgetLayout( TxtFunction:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local Button1:TGadget = CreateButton:TGadget("Execute command",112,109,111,23,Group2:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( Button1:TGadget ) ; Button1.Context="Button1"
		Local Label1_c2_c3:TGadget = CreateLabel:TGadget("Function",13,91,47,14,Group2:TGadget,Null)
			GadgetList.AddLast( Label1_c2_c3:TGadget ) ; Label1_c2_c3.Context="Label1_c2_c3"
			SetGadgetLayout( Label1_c2_c3:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local Label1_c2:TGadget = CreateLabel:TGadget("Path",13,57,24,14,Group2:TGadget,Null)
			GadgetList.AddLast( Label1_c2:TGadget ) ; Label1_c2.Context="Label1_c2"
			SetGadgetLayout( Label1_c2:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
		Local Label1:TGadget = CreateLabel:TGadget("Host",13,23,28,14,Group2:TGadget,Null)
			GadgetList.AddLast( Label1:TGadget ) ; Label1.Context="Label1"
			SetGadgetLayout( Label1:TGadget,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE )
	Local Group3:TGadget = CreatePanel:TGadget(246,7,193,161,Window1:TGadget,PANEL_GROUP,"Parameters")
		GadgetList.AddLast( Group3:TGadget ) ; Group3.Context="Group3"
		Local TxtParameters:TGadget = CreateTextArea:TGadget(0,0,185,140,Group3:TGadget,Null)
			GadgetList.AddLast( TxtParameters:TGadget ) ; TxtParameters.Context="TxtParameters"
			SetGadgetLayout( TxtParameters:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local Font_TxtParameters:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
			SetGadgetFont( TxtParameters:TGadget, Font_TxtParameters:TGuiFont )
			SetTextAreaText( TxtParameters:TGadget , "int::10~nstring::some test String~ndouble::1.02~nbase64:myId:some test string..." )
	Local Tabber1:TGadget = CreateTabber:TGadget(4,175,435,321,Window1:TGadget,Null)
		GadgetList.AddLast( Tabber1:TGadget ) ; Tabber1.Context="Tabber1"
		AddGadgetItem( Tabber1:TGadget,"XML",GADGETITEM_DEFAULT )
		Local Tabber1_Tab1:TGadget = CreatePanel( 0,0,ClientWidth(Tabber1:TGadget),ClientHeight(Tabber1:TGadget),Tabber1:TGadget )
			Tabber1.items[0].extra = Tabber1_Tab1:TGadget
			SetGadgetLayout( Tabber1_Tab1,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local Group4:TGadget = CreatePanel:TGadget(5,3,419,146,Tabber1_Tab1:TGadget,PANEL_GROUP,"Request")
				GadgetList.AddLast( Group4:TGadget ) ; Group4.Context="Group4"
				Local TextAreaRequest:TGadget = CreateTextArea:TGadget(0,0,411,125,Group4:TGadget,TEXTAREA_READONLY)
					GadgetList.AddLast( TextAreaRequest:TGadget ) ; TextAreaRequest.Context="TextAreaRequest"
					SetGadgetLayout( TextAreaRequest:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					Local Font_TextAreaRequest:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
					SetGadgetFont( TextAreaRequest:TGadget, Font_TextAreaRequest:TGuiFont )
					SetTextAreaText( TextAreaRequest:TGadget , "" )
			Local Group4_c5:TGadget = CreatePanel:TGadget(5,149,419,146,Tabber1_Tab1:TGadget,PANEL_GROUP,"Response")
				GadgetList.AddLast( Group4_c5:TGadget ) ; Group4_c5.Context="Group4_c5"
				Local TextAreaResponse:TGadget = CreateTextArea:TGadget(0,0,411,125,Group4_c5:TGadget,TEXTAREA_READONLY)
					GadgetList.AddLast( TextAreaResponse:TGadget ) ; TextAreaResponse.Context="TextAreaResponse"
					SetGadgetLayout( TextAreaResponse:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					Local Font_TextAreaResponse:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
					SetGadgetFont( TextAreaResponse:TGadget, Font_TextAreaResponse:TGuiFont )
					SetTextAreaText( TextAreaResponse:TGadget , "" )
		AddGadgetItem( Tabber1:TGadget," BlitzMax",GADGETITEM_NORMAL )
		Local Tabber1_Tab2:TGadget = CreatePanel( 0,0,ClientWidth(Tabber1:TGadget),ClientHeight(Tabber1:TGadget),Tabber1:TGadget )
			Tabber1.items[1].extra = Tabber1_Tab2:TGadget
			SetGadgetLayout( Tabber1_Tab2,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local Group6:TGadget = CreatePanel:TGadget(5,3,419,292,Tabber1_Tab2:TGadget,PANEL_GROUP,"Response")
				GadgetList.AddLast( Group6:TGadget ) ; Group6.Context="Group6"
				SetGadgetLayout( Group6:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
				Local TextAreaBlitzMax:TGadget = CreateTextArea:TGadget(0,0,411,271,Group6:TGadget,Null)
					GadgetList.AddLast( TextAreaBlitzMax:TGadget ) ; TextAreaBlitzMax.Context="TextAreaBlitzMax"
					SetGadgetLayout( TextAreaBlitzMax:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					SetTextAreaText( TextAreaBlitzMax:TGadget , "" )
		Tabber1_GA( Tabber1:TGadget , 0 )

Local Gadget7:TGadget, GadgetArray7$[] = ["Window1"] 
If GadgetList Gadget7:TGadget = GadgetCommander(GetGadgetHandle,GadgetArray7,GadgetList:TList)
SetGadgetText(Gadget7, GadgetText(Gadget7) + String.FromCString(XMLRPC_GetVersionString()))


Repeat
	WaitEvent()
	Select EventID()
		Case EVENT_WINDOWCLOSE
			Select EventSource()
				Case Window1	Window1_WC( Window1:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETACTION
			Select EventSource()
				Case TxtHost	TxtHost_GA( TxtHost:TGadget , GadgetList:TList )
				Case TxtPath	TxtPath_GA( TxtPath:TGadget , GadgetList:TList )
				Case TxtFunction	TxtFunction_GA( TxtFunction:TGadget , GadgetList:TList )
				Case Button1	Button1_GA( Button1:TGadget , GadgetList:TList )
				Case TxtParameters	TxtParameters_GA( TxtParameters:TGadget , GadgetList:TList )
				Case Tabber1	Tabber1_GA( Tabber1:TGadget , EventData() , GadgetList:TList )
				Case TextAreaResponse	TextAreaResponse_GA( TextAreaResponse:TGadget , GadgetList:TList )
				Case TextAreaRequest	TextAreaRequest_GA( TextAreaRequest:TGadget , GadgetList:TList )
				Case TextAreaBlitzMax	TextAreaBlitzMax_GA( TextAreaBlitzMax:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETMENU
			Select EventSource()
				Case TextAreaResponse	TextAreaResponse_GM( TextAreaResponse:TGadget , Window1:TGadget , GadgetList:TList )
				Case TextAreaRequest	TextAreaRequest_GM( TextAreaRequest:TGadget , Window1:TGadget , GadgetList:TList )
			End Select

		Case EVENT_MOUSEDOWN
			Select EventSource()
				Case Group2	Group2_MD( Group2:TGadget , EventData() , Window1:TGadget , GadgetList:TList )
			End Select

	End Select
Forever

Function Window1_WC( Window:TGadget , GadgetList:TList=Null )
	DebugLog "Window Window1 wants to be closed"
'	HideGadget( Window:TGadget )

	END
End Function

Function TxtHost_GA( TextField:TGadget , GadgetList:TList=Null )
	DebugLog "TextField TxtHost was modified"
	DebugLog "Text = "+ TextFieldText$( TextField:TGadget )
	
End Function

Function TxtPath_GA( TextField:TGadget , GadgetList:TList=Null )
	DebugLog "TextField TxtPath was modified"
	DebugLog "Text = "+ TextFieldText$( TextField:TGadget )
	
End Function

Function TxtFunction_GA( TextField:TGadget , GadgetList:TList=Null )
	DebugLog "TextField TxtFunction was modified"
	DebugLog "Text = "+ TextFieldText$( TextField:TGadget )
	
End Function

Function Button1_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button Button1 was pressed"
		Local Gadget6:TGadget, GadgetArray6$[] =["Window1"] 
	If GadgetList Gadget6:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray6,GadgetList:TList)

	Try
		Local Gadget2:TGadget, GadgetArray2$[] =["TxtPath"] 
		If GadgetList Gadget2:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray2,GadgetList:TList)

		Local Gadget3:TGadget, GadgetArray3$[] =["TxtHost"] 
		If GadgetList Gadget3:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray3,GadgetList:TList)

		Local Gadget4:TGadget, GadgetArray4$[] =["TxtFunction"] 
		If GadgetList Gadget4:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray4,GadgetList:TList)

		Local client:TXMLRPC_Client =New TXMLRPC_Client.Create()		client.SetTransport(New TXMLRPC_Transport_Http.Create(GadgetText(Gadget3), GadgetText(Gadget2)))

		Local Gadget9:TGadget, GadgetArray9$[] =["TxtParameters"] 
		If GadgetList Gadget9:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray9,GadgetList:TList)

		Local parameters:TXMLRPC_Call_Parameters =TXMLRPC_Call_Parameters.Create(xmlrpc_vector_mixed)
		ParseParameters(GadgetText(Gadget9), parameters)


		SetStatusText(Gadget6, "Executing XML-RPC request... Please wait")

		Local response:TXMLRPC_Response_Data =client.Call(GadgetText(Gadget4), parameters)
		SetStatusText(Gadget6, "XML-RPC request executed")

		Local pad:Int =0
		Local str:String =TXMLRPC_Response_Data.DebugData(response.data, pad)

		Local Gadget5:TGadget, GadgetArray5$[] =["TextAreaBlitzMax"] 
		If GadgetList Gadget5:TGadget =GadgetCommander(SetText,GadgetArray5,GadgetList:TList,str )

		Local Gadget7:TGadget, GadgetArray7$[] =["TextAreaResponse"] 
		If GadgetList Gadget7:TGadget =GadgetCommander(SetText,GadgetArray7,GadgetList:TList, client.xmlResponse )

		Local Gadget8:TGadget, GadgetArray8$[] =["TextAreaRequest"] 
		If GadgetList Gadget8:TGadget =GadgetCommander(SetText,GadgetArray8,GadgetList:TList, client.xmlRequest )

	Catch e:Object
		Notify(e.ToString(), True)
		SetStatusText(Gadget6, "Failed to execute XML-RPC request: " + e.ToString())
	End Try
End Function

Function TxtParameters_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TxtParameters was modified"
	
End Function

Function Tabber1_GA( Tabber:TGadget , Number:Int , GadgetList:TList=Null )
	DebugLog "Tabber Tabber1 selected Tab " + Number
	For Local i:int = 0 to Tabber.items.length -1
		HideGadget( TGadget( Tabber.items[i].extra ) )
	Next
	ShowGadget( TGadget( Tabber.items[Number].extra ) )
	
End Function

Function TextAreaResponse_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaResponse was modified"
	
End Function

Function TextAreaRequest_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaRequest was modified"
	
End Function

Function TextAreaBlitzMax_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaBlitzMax was modified"
	
End Function

Function TextAreaResponse_GM( TextArea:TGadget , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaResponse was right clicked"
	
End Function

Function TextAreaRequest_GM( TextArea:TGadget , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaRequest was right clicked"
	
End Function

Function Group2_MD( Panel:TGadget , MouseButton:Int , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "Panel Group2 detected Mouse Button "+ MouseButton +" pressed down"
	
End Function

Function GadgetCommander:TGadget( Action:Int , GadgetArray$[] , GadgetList:TList Var, Params:String=Null )
	For Local i$ = EachIn GadgetArray
		For Local ii:TGadget = EachIn GadgetList
			If String(ii.Context) = i$
				Select Action
					Case Disable			DisableGadget( ii:TGadget )
					Case Enable				EnableGadget( ii:TGadget )
					Case Hide				HideGadget( ii:TGadget )
					Case Show				ShowGadget( ii:TGadget )
					Case Check				SetButtonState( ii:TGadget , True )
					Case Uncheck			SetButtonState( ii:TGadget , False )
					Case Free				FreeGadget( ii:TGadget )
					Case SetText			SetGadgetText( ii:TGadget,Params$ )
					Case Activate			ActivateGadget( ii:TGadget )
					Case Redraw				RedrawGadget( ii:TGadget )
					Case RemoveFromList		GadgetList.Remove( ii:TGadget )
					Case GetGadgetHandle	Return ( ii:TGadget )
				End Select
				Exit
			End If
		Next
	Next
	Return Null
End Function

'Start of external Append File
'Your additional code should be here!

Function ParseParameters(text:String, parameters:TXMLRPC_Call_Parameters)

	Local lines:String[] = text.Split("~n")

	For Local line:String = EachIn lines
		If line.Length = 0
			Continue
		End If

		Local pos:Int = line.Find(":")
		Local pos2:Int = line.Find(":", pos + 1)
		Local dataTypeStr:String = line[..pos]
		Local key:String = line[pos+1..pos2]
		Local value:String = line[pos2+1..]

		Select dataTypeStr.ToLower()
			Case "string"
				parameters.AppendString(key, value)
			Case "base64"
				parameters.AppendBase64(key, value)
			Case "int"
				parameters.AppendInt(key, value.ToInt())
			Case "double"
				parameters.AppendDouble(key, value.ToDouble())
			Case "boolean"
				Local bool:Byte
				If value = "true"
					bool = True
				Else
					bool = False
				End If
				parameters.AppendBoolean(key, bool)
			Case "datetime"
				parameters.AppendDateTime(key, value.ToLong())
		End Select
	Next
End Function

'End Of external Append File

