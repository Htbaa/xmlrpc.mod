Rem
	bbdoc: Exception for TXMLRPC_Server
End Rem
Type TXMLRPC_Server_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: XML-RPC Server
	about: This type will allow you to create an XML-RPC server. Currently not yet implemented.
End Rem
Type TXMLRPC_Server

	Field server:Byte Ptr

	Rem
		bbdoc:
	End Rem
	Method New()
		Self.server = XMLRPC_ServerCreate()
	End Method
	
	Rem
		bbdoc: Call this method when your done with the server
	End Rem
	Method Shutdown()
		If Self.server
			XMLRPC_ServerDestroy(Self.server)
		End If
	End Method

	
	Method CallMethod()
		Local xmlRequest:Byte Ptr = String("<?xml version=~q1.0~q?><methodCall><methodName>func2</methodName><params><int>200</int></params></methodCall>").ToCString()
		Local request:Byte Ptr = XMLRPC_REQUEST_FromXML(xmlRequest, Null, Null)
		MemFree(xmlRequest)
		
		Local test:Byte Ptr = XMLRPC_REQUEST_ToXML(request, Null)
		DebugLog convertUTF8toISO8859(test)
		XMLRPC_Free(test)
		
		Local response:Byte Ptr = XMLRPC_RequestNew()
		XMLRPC_RequestSetRequestType(response, xmlrpc_request_response)
		
		XMLRPC_RequestSetData(response, XMLRPC_ServerCallMethod(Self.server, request, Null))
		
		XMLRPC_RequestSetOutputOptions(response, XMLRPC_RequestGetOutputOptions(request))
		
		Local xmlResponse:Byte Ptr = XMLRPC_REQUEST_ToXML(response, Null)
		
		DebugLog convertUTF8toISO8859(xmlResponse)
		XMLRPC_Free(xmlResponse)

		
		XMLRPC_RequestFree(request, 1)
		XMLRPC_RequestFree(response, 1)
	End Method
	
	Rem
		bbdoc: Register a function to the XML-RPC server
		about: functionName will be the identifier. callBack is a pointer to a function
	End Rem
	Method RegisterMethod(functionName:String, callBack:Byte Ptr)
		Local cStr:Byte Ptr = functionName.ToCString()
		XMLRPC_ServerRegisterMethod(Self.server, cStr, callBack)
		MemFree(cStr)
	End Method
End Type
