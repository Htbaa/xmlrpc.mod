SuperStrict
Import htbaapub.xmlrpc

Print "Version: " + String.FromCString(XMLRPC_GetVersionString())

Local client:TXMLRPC_Client = New TXMLRPC_Client.Create()
client.SetTransport(New TXMLRPC_Transport_Http.Create("php.htbaa.com", "/xmlrpc"))

Local parameters:TXMLRPC_Call_Parameters = TXMLRPC_Call_Parameters.Create(xmlrpc_vector_mixed)
'parameters.AppendString("tadaa", "bladibla")
'parameters.AppendString(Null, "jalala")
'parameters.AppendBase64(Null, "HTBAA!")
'parameters.AppendBoolean("who_rocks", False)
'parameters.AppendDateTime_ISO8601("update_date", "2009-04-05T17:37:02")
'parameters.AppendDouble("modifier", 2.3845)
'parameters.AppendInt(Null, 4)

Local response:TXMLRPC_Response_Data = client.Call("funcs.somefunc2")

'For Local val:TXMLRPC_Data_Type_Abstract = EachIn response.data
'	Print val.key + ": " + val.ToString()
'Next