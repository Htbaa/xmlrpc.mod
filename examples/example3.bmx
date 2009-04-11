SuperStrict
Import htbaapub.xmlrpc

GCCollect()
Print GCMemAlloced()
GCSuspend()
'Print "Version: " + String.FromCString(XMLRPC_GetVersionString())
'Other serivce: http://www.upcdatabase.com/rpc method:help

For Local i:Int = 0 To 20
	testXMLRPC()
Next

Print "Done"
GCResume()
GCCollect()
Print GCMemAlloced()

'For Local val:TXMLRPC_Data_Type_Abstract = EachIn response.data
'	Print val.key + ": " + val.ToString()
'Next


Function testXMLRPC()
	Print "."
'	Try
	Local client:TXMLRPC_Client = New TXMLRPC_Client.Create()
	client.SetTransport(New TXMLRPC_Transport_Http.Create("php.htbaa.com", "/xmlrpc"))
'	client.SetTransport(New TXMLRPC_Transport_Http.Create("www.upcdatabase.com", "/rpc"))
	
	Local parameters:TXMLRPC_Call_Parameters = TXMLRPC_Call_Parameters.Create(xmlrpc_vector_mixed)
	parameters.AppendString("tadaa", "bladibla")
	parameters.AppendString(Null, "jalala")
	parameters.AppendBase64(Null, "HTBAA!")
'	parameters.AppendBoolean("who_rocks", False)
'	parameters.AppendDateTime_ISO8601("update_date", "2009-04-05T17:37:02")
'	parameters.AppendDouble("modifier", 2.3845)
'	parameters.AppendInt(Null, 4)
	
	Local response:TXMLRPC_Response_Data = client.Call("funcs.somefunc4", parameters)
'	Local response:TXMLRPC_Response_Data = client.Call("help", parameters)
	
'	Print client.xmlRequest
'	Print client.xmlResponse
	
	'Local test:TXMLRPC_Data_Type_Abstract = TXMLRPC_Data_Type_Abstract(response.data.ValueForKey("myId"))
	'DebugLog test.ToString()
	
'	Local pad:Int = 0
'	Print TXMLRPC_Response_Data.DebugData(response.data, pad)
'	Catch e:Object
'	End Try
End Function