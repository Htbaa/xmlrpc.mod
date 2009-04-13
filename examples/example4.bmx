SuperStrict
Import htbaapub.xmlrpc

Local server:TXMLRPC_Server = New TXMLRPC_Server
server.RegisterMethod("GetGameList", rpc_GetGameList)
server.RegisterMethod("CheckGameExists", rpc_CheckGameExists)

'server.CallMethod()
Local responseData1:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>GetGameList</methodName><params><int>200</int></params></methodCall>")
Local pad:Int = 0
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData1.data, pad)

DebugLog "------------------------------------------"

Local responseData2:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>CheckGameExists</methodName><params><string id=~qgameName~q>Game C</string></params></methodCall>")
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData2.data, pad)

DebugLog "------------------------------------------"

Local responseData3:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>CheckGameExists</methodName><params><string id=~qgameName~q>Game K</string></params></methodCall>")
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData3.data, pad)
server.Shutdown()


Function GetGameList:String[] ()
	Return["Game A", "Game B", "Game C", "Game D", "Game E", "Game F"]
End Function

Function CheckGameExists:Byte(name:String)
	For Local str:String = EachIn GetGameList()
		If str = name
			Return True
		End If
	Next
	Return False
End Function


Function rpc_GetGameList:Byte Ptr(server:Byte Ptr, request:Byte Ptr, userData:Byte Ptr)
	Local requestData:TXMLRPC_Response_Data = RequestToResponseData(request)
	Local parameters:TXMLRPC_Call_Parameters = New TXMLRPC_Call_Parameters.Create(xmlrpc_vector_array)
	 
	For Local str:String = EachIn GetGameList()
		parameters.AppendString(Null, str)
	Next
	Return parameters.vector
End Function

Function rpc_CheckGameExists:Byte Ptr(server:Byte Ptr, request:Byte Ptr, userData:Byte Ptr)
	Local requestData:TXMLRPC_Response_Data = RequestToResponseData(request)
	
	Local gameName:String = TXMLRPC_Value_String(requestData.data.ValueForKey("0")).GetString()
	If CheckGameExists(gameName)
		Return XMLRPC_CreateValueBoolean(Null, True)
	Else
		Return XMLRPC_CreateValueBoolean(Null, False)
	End If
End Function


Function RequestToResponseData:TXMLRPC_Response_Data(request:Byte Ptr)
	Local xmlMessage:Byte Ptr = XMLRPC_REQUEST_ToXML(request, Null)
	Local output:Byte Ptr = XMLRPC_RequestGetOutputOptions(request)
	
	Local xml:String = convertUTF8toISO8859(xmlMessage)
	Local responseData:TXMLRPC_Response_Data = New TXMLRPC_Response_Data.Create(xml, output)
	
	Local pad:Int = 0
	DebugLog "Input:~n~n" + TXMLRPC_Response_Data.DebugData(responseData.data, pad)
	
	XMLRPC_Free(xmlMessage)

	Return responseData
End Function
