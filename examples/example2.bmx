SuperStrict
Import htbaapub.xmlrpc

Local client:TXMLRPC_Client = New TXMLRPC_Client.Create()
client.SetTransport(New TXMLRPC_Transport_Http.Create("www.upcdatabase.com", "/rpc"))

Local parameters:TXMLRPC_Call_Parameters = TXMLRPC_Call_Parameters.Create(xmlrpc_vector_array)
parameters.AppendString(Null, "0045496718749")

Local response:TXMLRPC_Response_Data = client.Call("lookupEAN", parameters)

Local description:TXMLRPC_Value_String = TXMLRPC_Value_String(response.data.ValueForKey("description"))
Local issuerCountry:TXMLRPC_Value_String = TXMLRPC_Value_String(response.data.ValueForKey("issuerCountry"))
Local ean:TXMLRPC_Value_String = TXMLRPC_Value_String(response.data.ValueForKey("ean"))

Print description.name + ": " + description.ToString()
Print issuerCountry.name + ": " + issuerCountry.ToString()
Print ean.name + ": " + ean.ToString()