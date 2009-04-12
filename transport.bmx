Rem
	bbdoc: Transport interface. Use this as a blueprint for any other transport layers
End Rem
Type TXMLRPC_Transport_Interface Abstract
	Rem
		bbdoc: Send request to XML-RPC server
	End Rem
	Method DoRequest:String(message:String) Abstract
End Type

Rem
	bbdoc: A Dummy transport type. Do not use, deprecated
End Rem
Type TXMLRPC_Transport_Dummy Extends TXMLRPC_Transport_Interface
	Rem
		bbdoc:
	End Rem
	Method DoRequest:String(message:String)
		Return message
	End Method

End Type

Rem
	bbdoc: Exception for TXMLRPC_Transport_Http
End Rem
Type TXMLRPC_Transport_Http_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: Simple HTTP transport
	about: Needs HTTP error handling, as well as a time out
End Rem
Type TXMLRPC_Transport_Http Extends TXMLRPC_Transport_Interface
	Field host:String
	Field path:String
	Field port:Int
	Rem
		bbdoc: Set useragent for HTTP request. Defaults to htbaa.mod/xmlrpc.mod
	End rem
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
		bbdoc: Send request over HTTP
	End Rem
	Method DoRequest:String(message:String)
'		Local xmlMessage:String = convertUTF8toISO8859(message)
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

'		DebugLog buffer

		CloseSocket(socket)
		Return buffer
	End Method
End Type
