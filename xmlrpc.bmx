SuperStrict

Rem
	bbdoc: htbaapub.xmlrpc
	about: 
EndRem
Module htbaapub.xmlrpc
ModuleInfo "Name: htbaapub.xmlrpc"
ModuleInfo "Version: 0.1"
ModuleInfo "Author: Christiaan Kras"


Import brl.blitz
Import brl.basic
Import brl.socket

Import bah.expat
Import "../../bah.mod/expat.mod/src/*.h"
Import "xmlrpc-epi-0.54/src/*.h"

Import "glue.cpp"

?Win32
	Import "win32.cpp"
	ModuleInfo "LD_OPTS: -L%PWD%/iconv-1.9.2.win32/lib"
	Import "iconv-1.9.2.win32/include/*.h"	'http://www.zlatkovic.com/pub/libxml
?

Import "-liconv"

Import "xmlrpc-epi-0.54/src/xmlrpc.c"
Import "xmlrpc-epi-0.54/src/base64.c"
Import "xmlrpc-epi-0.54/src/encodings.c"
Import "xmlrpc-epi-0.54/src/queue.c"
Import "xmlrpc-epi-0.54/src/simplestring.c"
Import "xmlrpc-epi-0.54/src/system_methods.c"
Import "xmlrpc-epi-0.54/src/xml_element.c"
Import "xmlrpc-epi-0.54/src/xml_to_dandarpc.c"
Import "xmlrpc-epi-0.54/src/xml_to_soap.c"
Import "xmlrpc-epi-0.54/src/xml_to_xmlrpc.c"
Import "xmlrpc-epi-0.54/src/xmlrpc_introspection.c"

Include "wrapper.bmx"

Rem
	bbdoc:
End Rem
Type TXMLRPC_Exception
	Field message:String
	Rem
		bbdoc:
	End Rem
	Method Create:TXMLRPC_Exception(message:String)
		Self.message = message
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method ToString:String()
		Return Self.message
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Call_Parameters
	Field vector:Byte Ptr

	Rem
		bbdoc:
	End Rem
	Function Create:TXMLRPC_Call_Parameters(vectorType:Int = xmlrpc_vector_mixed)
		Local parameters:TXMLRPC_Call_Parameters = New TXMLRPC_Call_Parameters
		parameters.vector = XMLRPC_CreateVector(Null, vectorType)
		Return parameters
	End Function
	
	Rem
		bbdoc:
	End Rem
	Method AppendString:Int(id:String, s:String)
		Return XMLRPC_VectorAppendString(Self.vector, id, s)
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method AppendBase64:Int(id:String, s:String)
		Return XMLRPC_VectorAppendBase64(Self.vector, id, s)
	End Method
	
'	Rem
'		bbdoc:
'	End Rem
'	Method AppendDateTime:Int(s:String)
'	End Method

	Rem
		bbdoc:
	End Rem
	Method AppendDateTime_ISO8601:Int(id:String, s:String)
		Return XMLRPC_VectorAppendDateTime_ISO8601(Self.vector, id, s)
	End Method

	Rem
		bbdoc:
	End Rem
	Method AppendDouble:Int(id:String, f:Double)
		Return XMLRPC_VectorAppendDouble(Self.vector, id, f)
	End Method

	Rem
		bbdoc:
	End Rem
	Method AppendInt:Int(id:String, i:Int)
		Return XMLRPC_VectorAppendInt(Self.vector, id, i)
	End Method

	Rem
		bbdoc:
	End Rem
	Method AppendBoolean:Int(id:String, i:Byte)
		Return XMLRPC_VectorAppendBoolean(Self.vector, id, i)
	End Method
End Type

Rem
	bbdoc: Data returned from XML-RPC server
End Rem
Type TXMLRPC_Response_Data
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Client
	Rem
		bbdoc: URL of webservice
	End Rem
	Field transport:TXMLRPC_Transport_Interface
	Field outputVersion:Int = xmlrpc_version_1_0
	
	Rem
		bbdoc:
	End Rem
	Method Create:TXMLRPC_Client()
		Return Self
	End Method
	
	Rem
		bbdoc: Set a transport interface
	End Rem
	Method SetTransport(transport:TXMLRPC_Transport_Interface)
		Self.transport = transport
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method Call(command:String, data:TXMLRPC_Call_Parameters = Null)
		If Not Self.transport
			Throw New TXMLRPC_Exception.Create("No transport object has been assigned yet!")
		End If
		
		Local request:Byte Ptr = XMLRPC_RequestNew()
	
		'Set the method name and tell it we are making a request
		XMLRPC_RequestSetMethodName(request, command.ToCString())
		XMLRPC_RequestSetRequestType(request, xmlrpc_request_call)
	
		'tell it to write out in the specified format, defaults to xmlrpc_version_1_0
		Local output:Byte Ptr = XMLRPC_Create_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS(Self.outputVersion)
		XMLRPC_RequestSetOutputOptions(request, output)
		
		'If data has been given, then add it to the request
		If data
			XMLRPC_RequestSetData(request, data.vector)
		End If
		
		'Generate XML Message
		Local xmlMessage:Byte Ptr = XMLRPC_REQUEST_ToXML(request, Null)
		
		'Free Request object
		XMLRPC_RequestFree(request, 1)

		'And pass our XML message to the transport layer
		Local xmlResponse:String = Self.transport.Send(convertUTF8toISO8859(xmlMessage))
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Interface Abstract
	Rem
		bbdoc:
	End Rem
	Method Send:String(message:String) Abstract
'	Method Retrieve:String() Abstract
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Dummy Extends TXMLRPC_Transport_Interface
	Rem
		bbdoc:
	End Rem
	Method Send:String(message:String)
		Print message
	End Method

End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Http_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Http Extends TXMLRPC_Transport_Interface
	Field host:String
	Field path:String
	Field port:Int
	Field userAgent:String = "htbaa.mod/xmlrpc.mod"
	
	Rem
		bbdoc: Create TXMLRPC_Transport_Http object
	End Rem
	Method Create:TXMLRPC_Transport_Http(host:String, path:String, port:Int = 80)
		Self.host = host
		Self.path = path
		Self.port = port
		Return Self
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method Send:String(message:String)
		DebugLog message
		Local socket:TSocket = CreateTCPSocket()

		ConnectSocket(socket, HostIp(Self.host), Self.port)
		If Not SocketConnected(socket)
			Throw New TXMLRPC_Transport_Http_Exception.Create("Couldn't open socket to " + Self.host)
		End If
		
		Local stream:TSocketStream = CreateSocketStream(socket)

		WriteLine(stream, "POST " + Self.path + " HTTP/1.0")
		WriteLine(stream, "Accept: */*")
		WriteLine(stream, "Host: " + Self.host)
		WriteLine(stream, "Content-type: application/x-www-form-urlencoded")
		WriteLine(stream, "User-agent: " + Self.userAgent)
		WriteLine(stream, "Pragma: no-cache")
		WriteLine(stream, "Connection: keep-alive")
		WriteLine(stream, "Content-length: " + message.Length + "~n")

		WriteLine(stream, message + "~n~n")

		FlushStream(stream)

		Local buffer:String
		While Not Eof(stream)
			Local line:String = ReadLine(stream)
			buffer:+line + "~n"
		Wend

		DebugLog buffer

		CloseSocket(socket)
		Return buffer
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Server
	Method New()
		Throw New TXMLRPC_Exception.Create("TXMLRPC_Server not yet implemented!")
	End Method
End Type