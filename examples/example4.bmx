SuperStrict
Import htbaapub.xmlrpc

'Create a new XML-RPC server
Local server:TXMLRPC_Server = New TXMLRPC_Server
'Register 2 functions
server.RegisterMethod("GetGameList", rpc_GetGameList)
server.RegisterMethod("CheckGameExists", rpc_CheckGameExists)

'First lets get the game list
Local responseData1:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>GetGameList</methodName><params/></methodCall>")
Local pad:Int = 0
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData1.data, pad)

DebugLog "------------------------------------------~n~n"

'Now lets see if the game "Game C" exists
Local responseData2:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>CheckGameExists</methodName><params><string id=~qgameName~q>Game C</string></params></methodCall>")
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData2.data, pad)

DebugLog "------------------------------------------~n~n"

'And lets see if the game "Game K" exists
Local responseData3:TXMLRPC_Response_Data = server.HandleInput("<?xml version=~q1.0~q?><methodCall><methodName>CheckGameExists</methodName><params><string id=~qgameName~q>Game K</string></params></methodCall>")
DebugLog "Output:~n~n" + TXMLRPC_Response_Data.DebugData(responseData3.data, pad)

'We're done, shutdown server
server.Shutdown()


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
	
	Local pad:Int = 0
	DebugLog "Input:~n~n" + TXMLRPC_Response_Data.DebugData(responseData.data, pad)
	
	XMLRPC_Free(xmlMessage)

	Return responseData
End Function
