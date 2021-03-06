Rem
	Copyright (c) 2010 Christiaan Kras
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
End Rem

Rem
	bbdoc: XML-RPC Data Type exception
End Rem
Type TXMLRPC_Value_Exception Extends TXMLRPC_Exception   
End Type

Rem
	bbdoc: Base type for all XML-RPC data types
End Rem
Type TXMLRPC_Value_Abstract Abstract
	Field _type:Int

	Rem
		bbdoc: The name or id this value has been identified with in the response. read-only
	End Rem
	Field name:String
	
	Rem
		bbdoc: Convert a XMLRPC_VALUE from XMLRPC-EPI to a BlitzMax type
	End Rem
	Function XMLRPC_To_BlizMax:TXMLRPC_Value_Abstract(val:Byte Ptr) Final
		Local dataType:Int = XMLRPC_GetValueType(val)
		Local data:TXMLRPC_Value_Abstract
		Select dataType
			Case xmlrpc_none
				data = New TXMLRPC_Value_None
			Case xmlrpc_empty
				data = New TXMLRPC_Value_Empty
			Case xmlrpc_base64
				data = New TXMLRPC_Value_Base64
				Local cStr:Byte Ptr = XMLRPC_GetValueBase64(val)
				If cStr
					TXMLRPC_Value_Base64(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_boolean
				data = New TXMLRPC_Value_Boolean
				TXMLRPC_Value_Boolean(data).value = XMLRPC_GetValueBoolean(val)
			Case xmlrpc_datetime
				data = New TXMLRPC_Value_Datetime
				Local cStr:Byte Ptr = XMLRPC_GetValueDateTime_ISO8601(val)
				If cStr
					TXMLRPC_Value_Datetime(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_double
				data = New TXMLRPC_Value_Double
				TXMLRPC_Value_Double(data).value = XMLRPC_GetValueDouble(val)
			Case xmlrpc_int
				data = New TXMLRPC_Value_Int
				TXMLRPC_Value_Int(data).value = XMLRPC_GetValueInt(val)
			Case xmlrpc_string
				data = New TXMLRPC_Value_String
				Local cStr:Byte Ptr = XMLRPC_GetValueString(val)
				If cStr
					TXMLRPC_Value_String(data).value = String.FromCString(cStr)
					XMLRPC_Free(cStr)
				End If
			Case xmlrpc_vector
				Local vectorType:Int = XMLRPC_GetVectorType(val)
				Select vectorType
					Case xmlrpc_vector_array
						data = New TXMLRPC_Value_Array
					Case xmlrpc_vector_struct
						data = New TXMLRPC_Value_Struct
					Case xmlrpc_vector_mixed
						Throw New TXMLRPC_Value_Exception.Create("Not sure yet how to handle a xmlrpc_vector_mixed value")
					Case xmlrpc_vector_none
						Throw New TXMLRPC_Value_Exception.Create("Not sure yet how to handle a xmlrpc_vector_none value")
					Default
						Throw New TXMLRPC_Value_Exception.Create("Unknown vector type: " + vectorType)
				End Select
				
				If TXMLRPC_Value_Collection(data)
					TXMLRPC_Value_Collection(data).SetData(val)
				End If
			Default
				Throw New TXMLRPC_Value_Exception.Create("I don't know a XMLRPC_VALUE with number " + dataType)
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
		about: Uses reflection to see if a Field called value is available. If so, it tries to convert it to a string and returns it
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
'		Throw New TXMLRPC_Value_Exception.Create("Can't convert datatype to string")
	End Method
	
	Rem
		bbdoc: Return byte value
	End Rem
	Method GetByte:Byte()
		Throw New TXMLRPC_Value_Exception.Create("Method GetByte not implemented for this type")
	End Method
	
	Rem
		bbdoc: Return integer value
	End Rem
	Method GetInt:Int()
		Throw New TXMLRPC_Value_Exception.Create("Method GetInt not implemented for this type")
	End Method
	
	Rem
		bbdoc: Return double value
	End Rem
	Method GetDouble:Double()
		Throw New TXMLRPC_Value_Exception.Create("Method GetDouble not implemented for this type")
	End Method

	Rem
		bbdoc: Return string value
	End Rem
	Method GetString:String()
		Throw New TXMLRPC_Value_Exception.Create("Method GetString not implemented for this type")
	End Method
End Type

Rem
	bbdoc: Represents none value
End Rem
Type TXMLRPC_Value_None Extends TXMLRPC_Value_Abstract
End Type

Rem
	bbdoc: Represents an empty value
End Rem
Type TXMLRPC_Value_Empty Extends TXMLRPC_Value_Abstract
	Field value:Object = Null
End Type

Rem
	bbdoc: Represents a Base64 encoded string
End Rem
Type TXMLRPC_Value_Base64 Extends TXMLRPC_Value_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a boolean value
End Rem
Type TXMLRPC_Value_Boolean Extends TXMLRPC_Value_Abstract
	Field value:Byte
	Method GetByte:Byte()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a datetime string
End Rem
Type TXMLRPC_Value_Datetime Extends TXMLRPC_Value_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a double value
End Rem
Type TXMLRPC_Value_Double Extends TXMLRPC_Value_Abstract
	Field value:Double
	Method GetDouble:Double()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a integer value
End Rem
Type TXMLRPC_Value_Int Extends TXMLRPC_Value_Abstract
	Field value:Int
	Method GetInt:Int()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a string value
End Rem
Type TXMLRPC_Value_String Extends TXMLRPC_Value_Abstract
	Field value:String
	Method GetString:String()
		Return Self.value
	End Method
End Type

Rem
	bbdoc: Represents a collection. This is a base type
End Rem
Type TXMLRPC_Value_Collection Extends TXMLRPC_Value_Abstract Abstract
	Field data:TMap
	Method SetData(el:Byte Ptr) Abstract
End Type

Rem
	bbdoc: Represents an array
End Rem
Type TXMLRPC_Value_Array Extends TXMLRPC_Value_Collection
	Method SetData(el:Byte Ptr)
		Self.data = New TMap

		If XMLRPC_VectorSize(el) > 0
			Local map:TMap = TXMLRPC_Response_Data.IterateVector(el)
			Local counter:Int = 0
			For Local val:TXMLRPC_Value_Abstract = EachIn map.Values()
				Self.data.Insert(String.FromInt(counter), val)
				counter:+1
			Next
		End If
	End Method
End Type

Rem
	bbdoc: Represents an associative array
End Rem
Type TXMLRPC_Value_Struct Extends TXMLRPC_Value_Collection
	Method SetData(el:Byte Ptr)
		Self.data = TXMLRPC_Response_Data.IterateVector(el)
	End Method
End Type
