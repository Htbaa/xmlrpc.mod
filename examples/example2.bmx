SuperStrict
Import htbaa.xmlrpc

Local client:TXMLRPC_Client = New TXMLRPC_Client.Create("http://php.htbaa.com/xmlrpc/")
client.SetTransport(New TXMLRPC_Transport_Dummy)

Local parameters:TXMLRPC_Call_Parameters = TXMLRPC_Call_Parameters.Create(xmlrpc_vector_mixed)
parameters.AppendString("tadaa", "bladibla")
parameters.AppendString(Null, "jalala")
parameters.AppendBase64(Null, "HTBAA!")
parameters.AppendBoolean("who_rocks", False)
parameters.AppendDateTime_ISO8601("update_date", "2009-04-05T17:37:02")
parameters.AppendDouble("modifier", 2.3845)
parameters.AppendInt(Null, 4)

client.Call("funcs.somefunc", parameters)