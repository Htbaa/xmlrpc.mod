Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Exception Extends TXMLRPC_Exception   
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Abstract Abstract
	Field _type:Int
	Field name:String
	
'	Rem
'		bbdoc:
'	End Rem	
'	Function Factory:TXMLRPC_Data_Type_Abstract(dataType:Int) Final
'		Select dataType
'			Case xmlrpc_none
'				Return New TXMLRPC_Data_Type_None
'			Case xmlrpc_empty
'				Return New TXMLRPC_Data_Type_Empty
'			Case xmlrpc_base64
'				Return New TXMLRPC_Data_Type_Base64
'			Case xmlrpc_boolean
'				Return New TXMLRPC_Data_Type_Boolean
'			Case xmlrpc_datetime
'				Return New TXMLRPC_Data_Type_Datetime
'			Case xmlrpc_double
'				Return New TXMLRPC_Data_Type_Double
'			Case xmlrpc_int
'				Return New TXMLRPC_Data_Type_Int
'			Case xmlrpc_string
'				Return New TXMLRPC_Data_Type_String
'			Case xmlrpc_vector
'				Return New TXMLRPC_Data_Type_Collection
'		End Select
'	End Function
	
	Rem
		bbdoc:
	End Rem
	Function XMLRPC_To_BlizMax:TXMLRPC_Data_Type_Abstract(val:Byte Ptr) Final
		Local dataType:Int = XMLRPC_GetValueType(val)
		Local data:TXMLRPC_Data_Type_Abstract
		Select dataType
			Case xmlrpc_none
				data = New TXMLRPC_Data_Type_None
			Case xmlrpc_empty
				data = New TXMLRPC_Data_Type_Empty
			Case xmlrpc_base64
				data = New TXMLRPC_Data_Type_Base64
				Local cStr:Byte Ptr = XMLRPC_GetValueBase64(val)
				If cStr
					TXMLRPC_Data_Type_Base64(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_boolean
				data = New TXMLRPC_Data_Type_Boolean
				TXMLRPC_Data_Type_Boolean(data).value = XMLRPC_GetValueBoolean(val)
			Case xmlrpc_datetime
				data = New TXMLRPC_Data_Type_Datetime
				Local cStr:Byte Ptr = XMLRPC_GetValueDateTime_ISO8601(val)
				If cStr
					TXMLRPC_Data_Type_Datetime(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_double
				data = New TXMLRPC_Data_Type_Double
				TXMLRPC_Data_Type_Double(data).value = XMLRPC_GetValueDouble(val)
			Case xmlrpc_int
				data = New TXMLRPC_Data_Type_Int
				TXMLRPC_Data_Type_Int(data).value = XMLRPC_GetValueInt(val)
			Case xmlrpc_string
				data = New TXMLRPC_Data_Type_String
				Local cStr:Byte Ptr = XMLRPC_GetValueString(val)
				If cStr
					TXMLRPC_Data_Type_String(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_vector
				Local vectorType:Int = XMLRPC_GetVectorType(val)
				Select vectorType
					Case xmlrpc_vector_array
						data = New TXMLRPC_Data_Type_Array
					Case xmlrpc_vector_struct
						data = New TXMLRPC_Data_Type_Struct
					Case xmlrpc_vector_mixed
						Throw "Not sure yet how to handle a xmlrpc_vector_mixed"
				End Select
				
				If TXMLRPC_Data_Type_Collection(data)
					TXMLRPC_Data_Type_Collection(data).SetData(val)
				End If
			Default
				Throw "I don't know a datatype with number " + dataType
		End Select
		
		If data
			data._type = dataType
			Local cStr:Byte Ptr = XMLRPC_GetValueID(val)
			If cStr
				data.name = String.FromCString(cStr)
				XMLRPC_Free(cStr)
			End If
		End If
		
		Return data
	End Function
	
	Rem
		bbdoc: Convert data type to string
	End Rem
	Method ToString:String()
		Local r:TTypeId = TTypeId.ForObject(Self)
		
		For Local fld:TField = EachIn r.EnumFields()
			'Check if object has a Field called value
			'If so, check it's type, convert it to a string and return it
			If fld.Name() = "value"
				Select fld.TypeId().Name()
					Case "String"
						Return fld.GetString(Self)
					Case "Int"
						Return String(fld.GetInt(Self))
					Case "Byte"
						Return String(fld.GetInt(Self))
					Case "Long"
						Return String(fld.GetLong(Self))
					Case "Double"
						Return String(fld.GetDouble(Self))
				End Select
			End If
		Next
		Return ""
'		Throw New TXMLRPC_Data_Type_Exception.Create("Can't convert datatype to string")
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method GetByte:Byte()
		Throw New TXMLRPC_Data_Type_Exception.Create("Method GetByte not implemented for this type")
	End Method	
	Rem
		bbdoc:
	End Rem
	
	Method GetInt:Int()
		Throw New TXMLRPC_Data_Type_Exception.Create("Method GetInt not implemented for this type")
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method GetDouble:Double()
		Throw New TXMLRPC_Data_Type_Exception.Create("Method GetDouble not implemented for this type")
	End Method

	Rem
		bbdoc:
	End Rem
	Method GetString:String()
		Throw New TXMLRPC_Data_Type_Exception.Create("Method GetString not implemented for this type")
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_None Extends TXMLRPC_Data_Type_Abstract
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Empty Extends TXMLRPC_Data_Type_Abstract
	Field value:Object = Null
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Base64 Extends TXMLRPC_Data_Type_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Boolean Extends TXMLRPC_Data_Type_Abstract
	Field value:Byte
	Method GetByte:Byte()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Datetime Extends TXMLRPC_Data_Type_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Double Extends TXMLRPC_Data_Type_Abstract
	Field value:Double
	Method GetDouble:Double()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Int Extends TXMLRPC_Data_Type_Abstract
	Field value:Int
	Method GetInt:Int()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_String Extends TXMLRPC_Data_Type_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Collection Extends TXMLRPC_Data_Type_Abstract Abstract
	Field data:TMap
	Method SetData(el:Byte Ptr) Abstract
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Array Extends TXMLRPC_Data_Type_Collection
	Method SetData(el:Byte Ptr)
		Self.data = New TMap
		Local map:TMap = TXMLRPC_Response_Data.IterateVector(el)
		Local counter:Int = 0
		For Local val:TXMLRPC_Data_Type_Abstract = EachIn map.Values()
			Self.data.Insert(String.FromInt(counter), val)
			counter:+1
		Next
	End Method
End Type

Rem
	bbdoc:
End Rem
Type TXMLRPC_Data_Type_Struct Extends TXMLRPC_Data_Type_Collection
	Method SetData(el:Byte Ptr)
		Self.data = TXMLRPC_Response_Data.IterateVector(el)
	End Method
End Type
