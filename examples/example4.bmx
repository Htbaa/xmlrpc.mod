SuperStrict
Import htbaapub.xmlrpc

Local server:TXMLRPC_Server = New TXMLRPC_Server
'server.RegisterMethod("func1", testfunc1)
server.RegisterMethod("func2", testfunc2)

server.CallMethod()

'server.RegisterMethod("func1", "WrappedFunctions.testfunc1")
'server.RegisterMethod("func1", "WrappedFunctionss.testfunc1")
server.Shutdown()

Function testfunc2:Byte Ptr(server:Byte Ptr, request:Byte Ptr, userData:Byte Ptr)
'	DebugLog a
'	DebugLog b
'	DebugLog c
'	DebugLog String.FromCString(c)

'	Local in:Byte Ptr =



	Local xmlMessage:Byte Ptr = XMLRPC_REQUEST_ToXML(request, Null)

	Local xml:String = convertUTF8toISO8859(xmlMessage)
		
	Local responseData:TXMLRPC_Response_Data
	Local output:Byte Ptr = XMLRPC_RequestGetOutputOptions(request)
	responseData = New TXMLRPC_Response_Data.Create(xml, output)
	
	Local pad:Int = 0
	DebugLog TXMLRPC_Response_Data.DebugData(responseData.data, pad)
	
	XMLRPC_Free(xmlMessage)

'	Return XMLRPC_CreateValueBoolean(Null, True)
	Return XMLRPC_CreateValueInt(Null, 500)
End Function

