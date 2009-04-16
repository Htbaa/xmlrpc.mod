'Source Code created on 16 Apr 2009 20:38:58 with Logic Gui Version 4.2 Build 384
'Christiaan Kras
'Start of external Header File
SuperStrict

Import MaxGui.Drivers			'Comment this line if you don't want to use the new MaxGuiEx
'Import LogicZone.SmartButtons		'Uncomment this line when you want to use SmartButtons	
'Import MaxGUI.ProxyGadgets 		'Uncomment when using a proxy gadget
'GLShareContexts			'Uncomment when using multiple canvases and BMax 1.32b and up

Import htbaapub.xmlrpc


Global serverSocket:TSocket
'Create a new XML-RPC server
Global server:TXMLRPC_Server = New TXMLRPC_Server
'Register 2 functions
server.RegisterMethod("GetGameList", rpc_GetGameList)
server.RegisterMethod("CheckGameExists", rpc_CheckGameExists)


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

Local IncomingConnections:TTimer = CreateTimer:TTimer( 10 )

Local Window1:TGadget = CreateWindow:TGadget("XML-RPC Server",424,140,294,292,Null,WINDOW_TITLEBAR|WINDOW_STATUS |WINDOW_CLIENTCOORDS |WINDOW_CENTER)
	GadgetList.AddLast( Window1:TGadget ) ; Window1.Context="Window1"
	Local GroupServerSettings:TGadget = CreatePanel:TGadget(1,1,292,80,Window1:TGadget,PANEL_GROUP,"XML-RPC Server Settings")
		GadgetList.AddLast( GroupServerSettings:TGadget ) ; GroupServerSettings.Context="GroupServerSettings"
		SetGadgetLayout( GroupServerSettings:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
		Local ButtonStart:TGadget = CreateButton:TGadget("Start",189,7,75,45,GroupServerSettings:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( ButtonStart:TGadget ) ; ButtonStart.Context="ButtonStart"
		Local TextFieldPort:TGadget = CreateTextField:TGadget(79,9,44,18,GroupServerSettings:TGadget,Null)
			SetGadgetText( TextFieldPort:TGadget,"80")
			GadgetList.AddLast( TextFieldPort:TGadget ) ; TextFieldPort.Context="TextFieldPort"
		Local LabelPort:TGadget = CreateLabel:TGadget("Port",14,13,41,14,GroupServerSettings:TGadget,Null)
			GadgetList.AddLast( LabelPort:TGadget ) ; LabelPort.Context="LabelPort"
	Local Tabber1:TGadget = CreateTabber:TGadget(1,88,292,202,Window1:TGadget,Null)
		GadgetList.AddLast( Tabber1:TGadget ) ; Tabber1.Context="Tabber1"
		SetGadgetLayout( Tabber1:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
		AddGadgetItem( Tabber1:TGadget,"Incoming",GADGETITEM_DEFAULT )
		Local Tabber1_Tab1:TGadget = CreatePanel( 0,0,ClientWidth(Tabber1:TGadget),ClientHeight(Tabber1:TGadget),Tabber1:TGadget )
			Tabber1.items[0].extra = Tabber1_Tab1:TGadget
			SetGadgetLayout( Tabber1_Tab1,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local TextAreaIncoming:TGadget = CreateTextArea:TGadget(0,0,288,180,Tabber1_Tab1:TGadget,TEXTAREA_READONLY)
				GadgetList.AddLast( TextAreaIncoming:TGadget ) ; TextAreaIncoming.Context="TextAreaIncoming"
				SetGadgetLayout( TextAreaIncoming:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
				Local Font_TextAreaIncoming:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
				SetGadgetFont( TextAreaIncoming:TGadget, Font_TextAreaIncoming:TGuiFont )
				SetTextAreaText( TextAreaIncoming:TGadget , "" )
		AddGadgetItem( Tabber1:TGadget,"Outgoing",GADGETITEM_NORMAL )
		Local Tabber1_Tab2:TGadget = CreatePanel( 0,0,ClientWidth(Tabber1:TGadget),ClientHeight(Tabber1:TGadget),Tabber1:TGadget )
			Tabber1.items[1].extra = Tabber1_Tab2:TGadget
			SetGadgetLayout( Tabber1_Tab2,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local TextAreaOutgoing:TGadget = CreateTextArea:TGadget(0,0,288,180,Tabber1_Tab2:TGadget,TEXTAREA_READONLY)
				GadgetList.AddLast( TextAreaOutgoing:TGadget ) ; TextAreaOutgoing.Context="TextAreaOutgoing"
				SetGadgetLayout( TextAreaOutgoing:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
				Local Font_TextAreaOutgoing:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
				SetGadgetFont( TextAreaOutgoing:TGadget, Font_TextAreaOutgoing:TGuiFont )
				SetTextAreaText( TextAreaOutgoing:TGadget , "" )
		AddGadgetItem( Tabber1:TGadget,"Log",GADGETITEM_NORMAL )
		Local Tabber1_Tab3:TGadget = CreatePanel( 0,0,ClientWidth(Tabber1:TGadget),ClientHeight(Tabber1:TGadget),Tabber1:TGadget )
			Tabber1.items[2].extra = Tabber1_Tab3:TGadget
			SetGadgetLayout( Tabber1_Tab3,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local TextAreaLog:TGadget = CreateTextArea:TGadget(0,0,288,180,Tabber1_Tab3:TGadget,TEXTAREA_READONLY)
				GadgetList.AddLast( TextAreaLog:TGadget ) ; TextAreaLog.Context="TextAreaLog"
				SetGadgetLayout( TextAreaLog:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
				Local Font_TextAreaLog:TGuiFont = LoadGuiFont:TGuiFont( "Courier New" , 8 , False , False , False )
				SetGadgetFont( TextAreaLog:TGadget, Font_TextAreaLog:TGuiFont )
				SetTextAreaText( TextAreaLog:TGadget , "" )
		Tabber1_GA( Tabber1:TGadget , 0 )

'Start of external GadgetIni File
'Your additional code should be here!

'End Of external GadgetIni File


Repeat
	WaitEvent()
	Select EventID()
		Case EVENT_WINDOWCLOSE
			Select EventSource()
				Case Window1	Window1_WC( Window1:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETACTION
			Select EventSource()
				Case ButtonStart	ButtonStart_GA( ButtonStart:TGadget , GadgetList:TList )
				Case TextFieldPort	TextFieldPort_GA( TextFieldPort:TGadget , GadgetList:TList )
				Case Tabber1	Tabber1_GA( Tabber1:TGadget , EventData() , GadgetList:TList )
				Case TextAreaIncoming	TextAreaIncoming_GA( TextAreaIncoming:TGadget , GadgetList:TList )
				Case TextAreaOutgoing	TextAreaOutgoing_GA( TextAreaOutgoing:TGadget , GadgetList:TList )
				Case TextAreaLog	TextAreaLog_GA( TextAreaLog:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETMENU
			Select EventSource()
				Case TextAreaIncoming	TextAreaIncoming_GM( TextAreaIncoming:TGadget , Window1:TGadget , GadgetList:TList )
				Case TextAreaOutgoing	TextAreaOutgoing_GM( TextAreaOutgoing:TGadget , Window1:TGadget , GadgetList:TList )
			End Select

		Case EVENT_TIMERTICK
			Select EventSource()
				Case IncomingConnections	IncomingConnections_Timer( IncomingConnections:TTimer , GadgetList:TList )
			End Select

	End Select

'Start of external RawEvent File
'Your additional code should be here!
'End Of external RawEvent File

Forever

Function Window1_WC( Window:TGadget , GadgetList:TList=Null )
	DebugLog "Window Window1 wants to be closed"
'	HideGadget( Window:TGadget )

		If serverSocket
		CloseSocket(serverSocket)
	End If
	If server
		'We're done, shutdown server
		server.Shutdown()
	End If
	End
End Function

Function ButtonStart_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button ButtonStart was pressed"
		Local Gadget3:TGadget, GadgetArray3$[] =["Window1"] 
	If GadgetList Gadget3:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray3,GadgetList:TList)


	Select GadgetText(Button)
		Case "Start"
			Local Gadget2:TGadget, GadgetArray2$[] =["TextFieldPort"] 
			If GadgetList Gadget2:TGadget =GadgetCommander(GetGadgetHandle,GadgetArray2,GadgetList:TList)

			Local port:String =GadgetText(Gadget2)

			serverSocket =CreateTCPSocket()
			If Not BindSocket(serverSocket, port.ToInt())
				Local errorMsg:String ="Unable to bind socket to port " + port
				Notify(errorMsg, True)
				SetStatusText(Gadget3, errorMsg)
				CloseSocket(serverSocket)
				Return
			End If

			SocketListen(serverSocket)

			Local str:String ="Server now listening at port " + port
			WriteLog(str, GadgetList)
			SetStatusText(Gadget3, str)

			SetGadgetText(Button, "Stop")
		Case "Stop"
			If serverSocket
				CloseSocket(serverSocket)
			End If
			SetStatusText(Gadget3, "Server stopped")
			SetGadgetText(Button, "Start")
	End Select
End Function

Function TextFieldPort_GA( TextField:TGadget , GadgetList:TList=Null )
	DebugLog "TextField TextFieldPort was modified"
	DebugLog "Text = "+ TextFieldText$( TextField:TGadget )
	
End Function

Function Tabber1_GA( Tabber:TGadget , Number:Int , GadgetList:TList=Null )
	DebugLog "Tabber Tabber1 selected Tab " + Number
	For Local i:int = 0 to Tabber.items.length -1
		HideGadget( TGadget( Tabber.items[i].extra ) )
	Next
	ShowGadget( TGadget( Tabber.items[Number].extra ) )
	
End Function

Function TextAreaIncoming_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaIncoming was modified"
	
End Function

Function TextAreaOutgoing_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaOutgoing was modified"
	
End Function

Function TextAreaLog_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaLog was modified"
	
End Function

Function TextAreaIncoming_GM( TextArea:TGadget , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaIncoming was right clicked"
	
End Function

Function TextAreaOutgoing_GM( TextArea:TGadget , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "TextArea TextAreaOutgoing was right clicked"
	
End Function

Function IncomingConnections_Timer( Timer:TTimer , GadgetList:TList=Null )
	DebugLog "Timer IncomingConnections ticked"
		HandleIncomingRequest(GadgetList)
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

Rem
	bbdoc: Write a message to the log file
End Rem
Function WriteLog(message:String, GadgetList:TList = Null)
	Local Gadget4:TGadget, GadgetArray4$[] = ["TextAreaLog"] 
	If GadgetList Gadget4:TGadget = GadgetCommander(GetGadgetHandle,GadgetArray4,GadgetList:TList)
	SetGadgetText(Gadget4, CurrentDate() + " " + CurrentTime() + ": " + message + "~n" + GadgetText(Gadget4))
End Function

Rem
	bbdoc: Handle incoming XML request and return an XML response
End Rem
Function HandleIncomingRequest(GadgetList:TList = Null)
	If serverSocket
		Local socket:TSocket = SocketAccept(serverSocket, 0)
		If socket
			Local clientIp:String = DottedIP(SocketRemoteIP(socket))
			WriteLog("Client " + clientIp + " connected", GadgetList)
			Local stream:TSocketStream = CreateSocketStream(socket)
			
			Local incoming:String

			Repeat
				Local line:String = ReadLine(stream)
				incoming :+ line
			Until SocketReadAvail(socket) = 0

			Local startPos:Int = incoming.Find("<?xml")
			'Extract XML message
			incoming = incoming[startPos..]

			Local Gadget1:TGadget, GadgetArray1$[] = ["TextAreaIncoming"] 
			If GadgetList Gadget1:TGadget = GadgetCommander(SetText,GadgetArray1,GadgetList:TList, incoming )
			
			Local response:String = String(server.HandleInput(incoming))

			Local Gadget2:TGadget, GadgetArray2$[] = ["TextAreaOutgoing"] 
			If GadgetList Gadget2:TGadget = GadgetCommander(SetText,GadgetArray2,GadgetList:TList, response )
			
			WriteLine(stream, response)

			FlushStream(stream)
			CloseSocket(socket)

			WriteLog("Client " + clientIp + " disconnected", GadgetList)
		End If
	End If
End Function


Rem
	bbdoc: A function that returns a list of games
End Rem
Function GetGameList:String[] ()
	Return["Game A", "Game B", "Game C", "Game D", "Game E", "Game F"]
End Function

Rem
	bbdoc: A function that checks if name exists in the gamelist
End Rem
Function CheckGameExists:Byte(name:String)
	For Local str:String = EachIn GetGameList()
		If str = name
			Return True
		End If
	Next
	Return False
End Function

Rem
	bbdoc: XML-RPC exposed function of GetGameList
End Rem
Function rpc_GetGameList:Byte Ptr(server:Byte Ptr, request:Byte Ptr, userData:Byte Ptr)
	Local parameters:TXMLRPC_Call_Parameters = New TXMLRPC_Call_Parameters.Create(xmlrpc_vector_array)
	 
	For Local str:String = EachIn GetGameList()
		parameters.AppendString(Null, str)
	Next
	Return parameters.vector
End Function

Rem
	bbdoc: XML-RPC exposed function of CheckGameExists
End Rem
Function rpc_CheckGameExists:Byte Ptr(server:Byte Ptr, request:Byte Ptr, userData:Byte Ptr)
	Local requestData:TXMLRPC_Response_Data = RequestToResponseData(request)
	
	Local gameName:String = TXMLRPC_Value_String(requestData.data.ValueForKey("0")).GetString()
	If CheckGameExists(gameName)
		Return XMLRPC_CreateValueBoolean(Null, True)
	Else
		Return XMLRPC_CreateValueBoolean(Null, False)
	End If
End Function


Rem
	bbdoc: Helper function to convert the request to a TXMLRPC_Response_Data object
End Rem
Function RequestToResponseData:TXMLRPC_Response_Data(request:Byte Ptr)
	Local xmlMessage:Byte Ptr = XMLRPC_REQUEST_ToXML(request, Null)
	Local output:Byte Ptr = XMLRPC_RequestGetOutputOptions(request)
	
	Local xml:String = convertUTF8toISO8859(xmlMessage)
	Local responseData:TXMLRPC_Response_Data = New TXMLRPC_Response_Data.Create(xml, output)
	
	XMLRPC_Free(xmlMessage)

	Return responseData
End Function


'End Of external Append File

