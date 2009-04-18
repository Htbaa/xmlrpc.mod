Rem
	bbdoc: Exception for TXMLRPC_Response_Data
End Rem
Type TXMLRPC_Response_Data_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: Data returned from XML-RPC server
End Rem
Type TXMLRPC_Response_Data
	Rem
		bbdoc: This field contains all data returned from a response. If a response value was given an ID it can be accessed by its ID. If not it can be accessed with an ID of 0..inf
	End Rem
	Field data:TMap
	
	Rem
		bbdoc: Create a TXMLRPC_Response_Data object by passing the response XML message and the output options.
	End Rem
	Method Create:TXMLRPC_Response_Data(xmlMessage:String, options:Byte Ptr)
		Local message:Byte Ptr = xmlMessage.ToCString()
		Local request:Byte Ptr = XMLRPC_REQUEST_FromXML(message, 0, options)

		Local el:Byte Ptr = XMLRPC_RequestGetData(request)

		Self.data = TXMLRPC_Response_Data.IterateVector(el)

		MemFree(message)
		XMLRPC_RequestFree(request, 1)
		
		Return Self
	End Method

	Rem
		bbdoc: Iterate over an XMLRPC vector and add it to a TMap. Private function
	End Rem	
	Function IterateVector:TMap(el:Byte Ptr)
		Local data:TMap = New TMap

		If el
			'Rewind vector
			Local itr:Byte Ptr = XMLRPC_VectorRewind(el)
			If Not itr
				Local cStr:Byte Ptr = XMLRPC_GetValueID(itr)
				Local id:String = "0"
				If cStr
					id = String.FromCString(cStr)
					XMLRPC_Free(cstr)
				End If

				data.Insert(id, TXMLRPC_Value_Abstract.XMLRPC_To_BlizMax(el))
			Else
				Local dataCounter:Int = 0
				While itr
					Local cStr:Byte Ptr = XMLRPC_GetValueID(itr)
					Local id:String = String.FromCString(cStr)
					
					If id.Length = 0
						id = String.FromInt(dataCounter)
						dataCounter:+1
					End If

					data.Insert(id, TXMLRPC_Value_Abstract.XMLRPC_To_BlizMax(itr))
					XMLRPC_Free(cStr)

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
		
		For Local val:TXMLRPC_Value_Abstract = EachIn map.Values()
			str:+prefix + " " + TTypeId.ForObject(val).Name() + " (" + val.name + ") = " + val.ToString() + "~n"
			If TXMLRPC_Value_Collection(val)
				pad:+1
				str:+TXMLRPC_Response_Data.DebugData(TXMLRPC_Value_Collection(val).data, pad) + "~n"
				pad:-1
			End If
		Next
		Return str
	End Function
End Type
