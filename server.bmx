Rem
	Copyright (c) 2010 Christiaan Kras
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
End Rem

Rem
	bbdoc: Exception for TXMLRPC_Server
End Rem
Type TXMLRPC_Server_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: XML-RPC Server
	about: This type will allow you to create an XML-RPC server.
End Rem
Type TXMLRPC_Server
	Const RETURN_STRING:Byte = 0
	Const RETURN_RESPONSE_DATA:Byte = 1

	Field server:Byte Ptr

	Rem
		bbdoc: Creates a new XML-RPC server
		about: After calling the constructor you might want to use RegisterMethod() to add methods to the server. Be sure to call Shutdown() when you're done.
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

	Rem
		bbdoc: Handles an request
		about: Will process the xmlMessage and returns an object that can be casted to a TXMLRPC_Response_Data object or to a String, which will be containing the returned values by the callback function
	End Rem
	Method HandleInput:Object(xmlMessage:String, returnType:Byte = TXMLRPC_Server.RETURN_STRING)
		Local xmlRequest:Byte Ptr = xmlMessage.ToCString()
		'Create XMLRPC_REQUEST object from given xmlMessage
		Local request:Byte Ptr = XMLRPC_REQUEST_FromXML(xmlRequest, Null, Null)
		MemFree(xmlRequest)
		
		'Create response
		Local response:Byte Ptr = XMLRPC_RequestNew()
		XMLRPC_RequestSetRequestType(response, xmlrpc_request_response)
		'Set response data by calling the callback function
		XMLRPC_RequestSetData(response, XMLRPC_ServerCallMethod(Self.server, request, Null))
		'Copy output options from request
		XMLRPC_RequestSetOutputOptions(response, XMLRPC_RequestGetOutputOptions(request))
		
		'Convert response to XML message
		Local xmlResponse:Byte Ptr = XMLRPC_REQUEST_ToXML(response, Null)
		Local responseData:Object
		'Create workable response data out of it
		Select returnType
			Case TXMLRPC_Server.RETURN_STRING
				responseData = convertUTF8toISO8859(xmlResponse)
			Case TXMLRPC_Server.RETURN_RESPONSE_DATA
				responseData = New TXMLRPC_Response_Data.Create(convertUTF8toISO8859(xmlResponse), XMLRPC_RequestGetOutputOptions(response))
		End Select
		
		
		XMLRPC_Free(xmlResponse)
		
		XMLRPC_RequestFree(request, 1)
		XMLRPC_RequestFree(response, 1)
		
		Return responseData
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
