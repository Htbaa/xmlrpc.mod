Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Interface Abstract
	Rem
		bbdoc:
	End Rem
	Method DoRequest:String(message:Byte Ptr) Abstract
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Transport_Dummy Extends TXMLRPC_Transport_Interface
	Rem
		bbdoc:
	End Rem
	Method DoRequest:String(message:Byte Ptr)
		Return convertUTF8toISO8859(message)
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
	Method DoRequest:String(message:Byte Ptr)
		Local xmlMessage:String = convertUTF8toISO8859(message)
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
		WriteLine(stream, "Content-length: " + xmlMessage.Length + "~n")

		WriteLine(stream, xmlMessage + "~n~n")

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
