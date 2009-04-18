SuperStrict
Import htbaapub.xmlrpc

For Local i:Int = 0 To 5
	testXMLRPC()
Next

Print "Done"

Function testXMLRPC()
	Print "."
	Try
		Local client:TXMLRPC_Client = New TXMLRPC_Client.Create()
		client.SetTransport(New TXMLRPC_Transport_Http.Create("www.upcdatabase.com", "/rpc"))
		Local response:TXMLRPC_Response_Data = client.Call("help", Null)
	Catch e:TXMLRPC_Transport_Http_Exception
		Print "TXMLRPC_Transport_Http_Exception: " + e.ToString()
	Catch e:Object
		Print e.ToString()
	End Try
End Function
