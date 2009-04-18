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
	about: Needs HTTP error handling. Implementation is very simple at the moment. Only a simple HTTP request is possible. Authenticated pages or HTTPS isn't supported. For HTTPS, write your own.
End Rem
Type TXMLRPC_Transport_Http Extends TXMLRPC_Transport_Interface
	Field host:String
	Field path:String
	Field port:Int

	Rem
		bbdoc: Set useragent for HTTP request.
		about: This string will be used to identify the client with the XML-RPC server
	End rem
	Field userAgent:String = "htbaapub.mod/xmlrpc.mod"
	
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
		Local socket:TSocket = CreateTCPSocket()
		
		If Not ConnectSocket(socket, HostIp(Self.host), Self.port)
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

		CloseSocket(socket)
		Return buffer
	End Method
End Type
