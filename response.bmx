Rem
	bbdoc:
End Rem
Type TXMLRPC_Response_Data_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: Data returned from XML-RPC server
End Rem
Type TXMLRPC_Response_Data
	Field data:TMap
	
	Rem
		bbdoc:
	End Rem
	Method Create:TXMLRPC_Response_Data(message:String, options:Byte Ptr)
'		message = "<?xml version=~q1.0~q encoding=~qUTF-8~q?><methodResponse><params><param><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></param></params></methodResponse>"
'		message = "<?xml version=~q1.0~q encoding=~qUTF-8~q?><methodResponse><params><param><value><struct><member><name>test1</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member><member><name>test2</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member></struct></value></param></params></methodResponse>"
'		message = "<?xml version=~q1.0~q encoding=~qUTF-8~q?><methodResponse><params><param><value><struct><member><name>test1</name><value><struct><member><name>a1</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member><member><name>a2</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member></struct></value></member><member><name>test2</name><value><struct><member><name>a1</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member><member><name>a2</name><value><array><data><value><int>1</int></value><value><int>2</int></value><value><string>a</string></value><value><string>c</string></value></data></array></value></member></struct></value></member><member><name>0</name><value><double>1.01</double></value></member><member><name>1</name><value><string>test de la test</string></value></member><member><name>2</name><value><nil/></value></member><member><name>3</name><value><string>20090410T22:34:12</string></value></member><member><name>myId</name><value><string>test de la test</string></value></member><member><name>test</name><value><array><data><value><array><data><value><int>1</int></value><value><int>2</int></value><value><int>3</int></value><value><int>4</int></value><value><string>test</string></value></data></array></value><value><array><data><value><int>5</int></value><value><int>2</int></value><value><int>1</int></value><value><double>3.3</double></value><value><string>another test</string></value></data></array></value></data></array></value></member><member><name>4</name><value><struct><member><name>a</name><value><int>2</int></value></member><member><name>b</name><value><int>3</int></value></member><member><name>c</name><value><int>6</int></value></member></struct></value></member></struct></value></param></params></methodResponse>"
		Local request:Byte Ptr = XMLRPC_REQUEST_FromXML(message, Null, options)
		DebugLog message
		
		Local el:Byte Ptr = XMLRPC_RequestGetData(request)

		Self.data = TXMLRPC_Response_Data.IterateVector(el)
		
		XMLRPC_RequestFree(request, 1)
		Return Self
	End Method

	Rem
		bbdoc: Iterate over an XMLRPC vector and add it to a TMap
	End Rem	
	Function IterateVector:TMap(el:Byte Ptr)
		Local data:TMap = New TMap

		If el
			'Rewind vector
			Local itr:Byte Ptr = XMLRPC_VectorRewind(el)
			If Not itr
				data.Insert("0", TXMLRPC_Data_Type_Abstract.XMLRPC_To_BlizMax(el))
			Else
				Local dataCounter:Int = 0
				While itr
					Local dataType:Int = XMLRPC_GetValueType(itr)
					Local id:String = String.FromCString(XMLRPC_GetValueID(itr))
					
					If id.Length = 0
						id = String.FromInt(dataCounter)
						dataCounter:+1
					End If
					
					data.Insert(id, TXMLRPC_Data_Type_Abstract.XMLRPC_To_BlizMax(itr))
	
					'Next element
					itr = XMLRPC_VectorNext(el)
				Wend
			End If
		End If
		
		Return data
	End Function
	
	Rem
		bbdoc: Helper function to show what's inside the map
	End Rem
	Function DebugData(map:TMap, pad:Int Var)
		Local prefix:String
		For Local i:Int = 0 To pad
			prefix:+"-"
		Next
		
		For Local val:TXMLRPC_Data_Type_Abstract = EachIn map.Values()
			DebugLog prefix + " " + TTypeId.ForObject(val).Name() + " (" + val.name + ") = " + val.ToString()
			If TXMLRPC_Data_Type_Collection(val)
				pad:+1
				TXMLRPC_Response_Data.DebugData(TXMLRPC_Data_Type_Collection(val).data, pad)
				pad:-1
			End If
		Next
		
	End Function
End Type
