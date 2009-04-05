

'XMLRPC_REQUEST_TYPE
Const xmlrpc_request_none:Int = 0
Const xmlrpc_request_call:Int = 1
Const xmlrpc_request_response:Int = 2

'XMLRPC_VERSION
Const xmlrpc_version_none:Int = 0
Const xmlrpc_version_1_0:Int = 1
Const xmlrpc_version_simple:Int = 2
Const xmlrpc_version_danda:Int = 2
Const xmlrpc_version_soap_1_1:Int = 3

'XMLRPC_VECTOR_TYPE
Const xmlrpc_vector_none:Int = 0
Const xmlrpc_vector_array:Int = 1
Const xmlrpc_vector_mixed:Int = 2
Const xmlrpc_vector_struct:Int = 3


Extern
	Function XMLRPC_Create_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS:Byte Ptr(version:Int)
	Function XMLRPC_Delete_Request_Output_Options(options:Byte Ptr)
End Extern

Extern "C"

	Function XMLRPC_RequestNew:Byte Ptr()
	Function XMLRPC_RequestFree(request:Byte Ptr, bFreeIO:Int)
	Function XMLRPC_RequestSetMethodName:Byte Ptr(request:Byte Ptr, methodName:Byte Ptr)
	Function XMLRPC_RequestGetMethodName:Byte Ptr(request:Byte Ptr)
	Function XMLRPC_RequestSetRequestType:Int(request:Byte Ptr, iType:Int)
	Function XMLRPC_RequestGetRequestType:Int(request:Byte Ptr)
	Function XMLRPC_RequestSetData:Int(request:Byte Ptr, data:Byte Ptr)
	Function XMLRPC_RequestGetData:Int(request:Byte Ptr)

	Function XMLRPC_REQUEST_ToXML:Byte Ptr(request:Byte Ptr, buf_len:Byte Ptr)
	
	Function XMLRPC_RequestSetOutputOptions:Byte Ptr(request:Byte Ptr, output:Byte Ptr)
	Function XMLRPC_RequestGetOutputOptions:Byte Ptr(request:Byte Ptr)
	
	
	Function XMLRPC_CreateVector:Byte Ptr(id:String, iType:Int)
	Function XMLRPC_CreateValueBoolean:Int(id:Byte Ptr, truth:Int)
	Function XMLRPC_CreateValueBase64:Int(id:Byte Ptr, s:Byte Ptr, length:Int)
	Function XMLRPC_CreateValueDateTime:Int(id:Byte Ptr, time:Byte Ptr)
	Function XMLRPC_CreateValueDateTime_ISO8601:Int(id:Byte Ptr, s:Byte Ptr)
	Function XMLRPC_CreateValueDouble:Int(id:Byte Ptr, f:Double)
	Function XMLRPC_CreateValueInt:Int(id:Byte Ptr, i:Int)
	Function XMLRPC_CreateValueEmpty:Int()
	Function XMLRPC_CreateValueString:Int(id:Byte Ptr, s:Byte Ptr, length:Int)
	
	Function XMLRPC_AddValueToVector:Int(target:Byte Ptr, source:Int)
Rem





#define XMLRPC_VectorGetValueWithID(vector, id) XMLRPC_VectorGetValueWithID_Case(vector, id, XMLRPC_DEFAULT_ID_CASE_SENSITIVITY)
#define XMLRPC_VectorGetStringWithID(vector, id) XMLRPC_GetValueString(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetBase64WithID(vector, id) XMLRPC_GetValueBase64(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetDateTimeWithID(vector, id) XMLRPC_GetValueDateTime(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetDoubleWithID(vector, id) XMLRPC_GetValueDouble(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetIntWithID(vector, id) XMLRPC_GetValueInt(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetBooleanWithID(vector, id) XMLRPC_GetValueBoolean(XMLRPC_VectorGetValueWithID(vector, id))
Endrem
End Extern


Function XMLRPC_VectorAppendString:Int(vector:Byte Ptr, id:String, s:String, length:Int = 0)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueString(id.ToCString(), s.ToCString(), length))
End Function

Function XMLRPC_VectorAppendBase64:Int(vector:Byte Ptr, id:String, s:String, length:Int = 0)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueBase64(id.ToCString(), s.ToCString(), length))
End Function

'#define XMLRPC_VectorAppendDateTime(vector, id, time) XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDateTime(id, time))
'Function XMLRPC_VectorAppendDateTime:Int(vector:Byte Ptr, id:Byte Ptr, time:Byte Ptr)
'	Return XMLRPC_CreateValueDateTime()
'End Function

Function XMLRPC_VectorAppendDateTime_ISO8601:Int(vector:Byte Ptr, id:String, s:String)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDateTime_ISO8601(id.ToCString(), s.ToCString()))
End Function

Function XMLRPC_VectorAppendDouble:Int(vector:Byte Ptr, id:String, f:Double)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDouble(id.ToCString(), f))
End Function

Function XMLRPC_VectorAppendInt:Int(vector:Byte Ptr, id:String, i:Int)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueInt(id.ToCString(), i))
End Function

Function XMLRPC_VectorAppendBoolean:Int(vector:Byte Ptr, id:String, i:Int)
	Return XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueBoolean(id.ToCString(), i))
End Function
rem
/****s* VALUE/XMLRPC_REQUEST_INPUT_OPTIONS
 * NAME
 *   XMLRPC_REQUEST_INPUT_OPTIONS
 * NOTES
 *   Defines options for reading in xml data
 * SEE ALSO
 *   XMLRPC_VERSION
 *   XML_ELEM_INPUT_OPTIONS
 *   XMLRPC_REQUEST_From_XML ()
 * SOURCE
 */
typedef struct _xmlrpc_request_input_options {
   STRUCT_XML_ELEM_INPUT_OPTIONS  xml_elem_opts;  /* xml_element specific output options */
} STRUCT_XMLRPC_REQUEST_INPUT_OPTIONS, *XMLRPC_REQUEST_INPUT_OPTIONS;
/******/

/****s* VALUE/XMLRPC_ERROR
 * NAME
 *   XMLRPC_ERROR
 * NOTES
 *   For the reporting and handling of errors
 * SOURCE
 */
typedef struct _xmlrpc_error {
   XMLRPC_ERROR_CODE      code;
   STRUCT_XML_ELEM_ERROR  xml_elem_error;  /* xml_element errors (parser errors) */
} STRUCT_XMLRPC_ERROR, *XMLRPC_ERROR;
/******/
endrem


Rem
	String conversion stuff below. Shamelessly stolen from Brucey :-)
End Rem

Extern
	Function _strlen:Int(s:Byte Ptr) = "strlen"
End Extern

' Convert from Max to UTF8
Function convertISO8859toUTF8:String(text:String)
	If Not text Then
		Return ""
	End If
	
	Local l:Int = text.length
	If l = 0 Then
		Return ""
	End If
	
	Local count:Int = 0
	Local s:Byte[] = New Byte[l * 3]
	
	For Local i:Int = 0 Until l
		Local char:Int = text[i]

		If char < 128 Then
			s[count] = char
			count:+ 1
			Continue
		Else If char<2048
			s[count] = char/64 | 192
			count:+ 1
			s[count] = char Mod 64 | 128
			count:+ 1
			Continue
		Else
			s[count] =  char/4096 | 224
			count:+ 1
			s[count] = char/64 Mod 64 | 128
			count:+ 1
			s[count] = char Mod 64 | 128
			count:+ 1
			Continue
		EndIf
		
	Next

	Return String.fromBytes(s, count)
End Function

' Convert from UTF8 to Max
Function convertUTF8toISO8859:String(s:Byte Ptr)

	Local l:Int = _strlen(s)

	Local b:Short[] = New Short[l]
	Local bc:Int = -1
	Local c:Int
	Local d:Int
	Local e:Int
	For Local i:Int = 0 Until l

		bc:+1
		c = s[i]
		If c<128 
			b[bc] = c
			Continue
		End If
		i:+1
		d=s[i]
		If c<224 
			b[bc] = (c-192)*64+(d-128)
			Continue
		End If
		i:+1
		e = s[i]
		If c < 240 
			b[bc] = (c-224)*4096+(d-128)*64+(e-128)
			If b[bc] = 8233 Then
				b[bc] = 10
			End If
			Continue
		End If
	Next

	Return String.fromshorts(b, bc + 1)
End Function

Function sizedUTF8toISO8859:String(s:Byte Ptr, size:Int)

	Local l:Int = size
	Local b:Short[] = New Short[l]
	Local bc:Int = -1
	Local c:Int
	Local d:Int
	Local e:Int
	For Local i:Int = 0 Until l

		c = s[i]
		If c = 0 Continue

		bc:+1
		If c<128
			b[bc] = c
			Continue
		End If
		i:+1
		d=s[i]
		If c<224 
			b[bc] = (c-192)*64+(d-128)
			Continue
		End If
		i:+1
		e = s[i]
		If c < 240 
			b[bc] = (c-224)*4096+(d-128)*64+(e-128)
			If b[bc] = 8233 Then
				b[bc] = 10
			End If
			Continue
		End If
	Next

	Return String.fromshorts(b, bc + 1)
End Function