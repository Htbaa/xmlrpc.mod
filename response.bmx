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
		Local request:Byte Ptr = XMLRPC_REQUEST_FromXML(message, Null, options)
		
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
	Function DebugData:String(map:TMap, pad:Int Var)
		Local str:String
		Local prefix:String
		For Local i:Int = 0 To pad
			prefix:+"-"
		Next
		
		For Local val:TXMLRPC_Data_Type_Abstract = EachIn map.Values()
			str:+prefix + " " + TTypeId.ForObject(val).Name() + " (" + val.name + ") = " + val.ToString() + "~n"
			If TXMLRPC_Data_Type_Collection(val)
				pad:+1
				str:+TXMLRPC_Response_Data.DebugData(TXMLRPC_Data_Type_Collection(val).data, pad) + "~n"
				pad:-1
			End If
		Next
		Return str
	End Function
End Type
