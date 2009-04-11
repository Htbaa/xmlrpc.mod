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

'XMLRPC_VALUE_TYPE
Const xmlrpc_none:Int = 0
Const xmlrpc_empty:Int = 1
Const xmlrpc_base64:Int = 2
Const xmlrpc_boolean:Int = 3
Const xmlrpc_datetime:Int = 4
Const xmlrpc_double:Int = 5
Const xmlrpc_int:Int = 6
Const xmlrpc_string:Int = 7
Const xmlrpc_vector:Int = 8

'XMLRPC_VALUE_TYPE_EASY
Const xmlrpc_type_none:Int = 0
Const xmlrpc_type_empty:Int = 1
Const xmlrpc_type_base64:Int = 2
Const xmlrpc_type_boolean:Int = 3
Const xmlrpc_type_datetime:Int = 4
Const xmlrpc_type_double:Int = 5
Const xmlrpc_type_int:Int = 6
Const xmlrpc_type_string:Int = 7
Const xmlrpc_type_array:Int = 8
Const xmlrpc_type_mixed:Int = 9
Const xmlrpc_type_struct:Int = 10

'XMLRPC_ERROR_CODE
Const xmlrpc_error_none:Int = 0
Const xmlrpc_error_parse_xml_syntax:Int = -32700
Const xmlrpc_error_parse_unknown_encoding:Int = -32701
Const xmlrpc_error_parse_bad_encoding:Int = -32702
Const xmlrpc_error_invalid_xmlrpc:Int = -32600
Const xmlrpc_error_unknown_method:Int = -32601
Const xmlrpc_error_invalid_params:Int = -32602
Const xmlrpc_error_internal_server:Int = -32603
Const xmlrpc_error_application:Int = -32500
Const xmlrpc_error_system:Int = -32400
Const xmlrpc_error_transport:Int = -32300

'XMLRPC_SERVER_VALIDATION
Const validation_none:Int = 0
Const validation_all:Int = 1
Const validation_if_defined:Int = 2

'XMLRPC_CASE_COMPARISON
Const xmlrpc_case_insensitive:Int = 0
Const xmlrpc_case_sensitive:Int = 1

'XMLRPC_CASE
Const xmlrpc_case_exact:Int = 0
Const xmlrpc_case_lower:Int = 1
Const xmlrpc_case_upper:Int = 2

'Extern
'	Function XMLRPC_Create_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS:Byte Ptr(version:Int)
'End Extern

Extern "C"
	'Function XMLRPC_Create_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS:Byte Ptr(version:Int)
	'Function XMLRPC_Free_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS(output:Byte Ptr)
	Function bmxXMLRPC_RequestSetOutputOptions(request:Byte Ptr, version:Int)

	Function XMLRPC_RequestNew:Byte Ptr()
	Function XMLRPC_RequestFree(request:Byte Ptr, bFreeIO:Int)
	Function XMLRPC_RequestSetMethodName:Byte Ptr(request:Byte Ptr, methodName:Byte Ptr)
	Function XMLRPC_RequestGetMethodName:Byte Ptr(request:Byte Ptr)
	Function XMLRPC_RequestSetOutputOptions:Byte Ptr(request:Byte Ptr, output:Byte Ptr)
	Function XMLRPC_RequestGetOutputOptions:Byte Ptr(request:Byte Ptr)
	Function XMLRPC_RequestSetData:Byte Ptr(request:Byte Ptr, data:Byte Ptr)
	Function XMLRPC_RequestGetData:Byte Ptr(request:Byte Ptr)
	Function XMLRPC_RequestSetRequestType:Int(request:Byte Ptr, iType:Int)
	Function XMLRPC_RequestGetRequestType:Int(request:Byte Ptr)

	Function XMLRPC_REQUEST_ToXML:Byte Ptr(request:Byte Ptr, buf_len:Byte Ptr)
	Function XMLRPC_REQUEST_FromXML:Byte Ptr(in_buf:Byte Ptr, length:Int, in_options:Byte Ptr)
	Function XMLRPC_VALUE_ToXML:Byte Ptr(val:Int, buf_len:Byte Ptr)
	Function XMLRPC_VALUE_FromXML:Byte Ptr(in_buf:Byte Ptr, length:Int, in_options:Byte Ptr)

	Function XMLRPC_CreateVector:Byte Ptr(id:String, iType:Int)
	Function XMLRPC_AddValueToVector:Int(target:Byte Ptr, source:Byte Ptr)
	Function XMLRPC_VectorSize:Int(value:Byte Ptr)
	Function XMLRPC_VectorRewind:Byte Ptr(value:Byte Ptr)
	Function XMLRPC_VectorNext:Byte Ptr(value:Byte Ptr)
	
	Function XMLRPC_CreateValueBoolean:Byte Ptr(id:Byte Ptr, truth:Int)
	Function XMLRPC_CreateValueBase64:Byte Ptr(id:Byte Ptr, s:Byte Ptr, length:Int)
	Function XMLRPC_CreateValueDateTime:Byte Ptr(id:Byte Ptr, time:Long)
	Function XMLRPC_CreateValueDateTime_ISO8601:Byte Ptr(id:Byte Ptr, s:Byte Ptr)
	Function XMLRPC_CreateValueDouble:Byte Ptr(id:Byte Ptr, f:Double)
	Function XMLRPC_CreateValueInt:Byte Ptr(id:Byte Ptr, i:Int)
	Function XMLRPC_CreateValueEmpty:Byte Ptr()
	Function XMLRPC_CreateValueString:Byte Ptr(id:Byte Ptr, s:Byte Ptr, length:Int)
	Function XMLRPC_CleanupValue(value:Byte Ptr)

'	According to the XMLRPC-EPI documentation these 2 are private and shouldn't be used
'	Function XMLRPC_RequestSetError:Byte Ptr(request:Byte Ptr, error:Int)
'	Function XMLRPC_RequestGetError:Byte Ptr(request:Byte Ptr)

	Function XMLRPC_VectorGetValueWithID_Case:Byte Ptr(vector:Byte Ptr, id:Byte Ptr, id_case:Int)
	
	Function XMLRPC_GetValueType:Int(v:Byte Ptr)
	'XMLRPC_VALUE_TYPE_EASY XMLRPC_GetValueTypeEasy(XMLRPC_VALUE v);
	Function XMLRPC_GetVectorType:Int(v:Byte Ptr)
	
	Function XMLRPC_GetValueString:Byte Ptr(value:Byte Ptr)
	Function XMLRPC_GetValueStringLen:Int(value:Byte Ptr)
	Function XMLRPC_GetValueInt:Int(value:Byte Ptr)
	Function XMLRPC_GetValueBoolean:Int(value:Byte Ptr)
	Function XMLRPC_GetValueDouble:Double(value:Byte Ptr)
	Function XMLRPC_GetValueBase64:Byte Ptr(value:Byte Ptr)
	Function XMLRPC_GetValueDateTime:Long(value:Byte Ptr)
	Function XMLRPC_GetValueDateTime_ISO8601:Byte Ptr(value:Byte Ptr)
	Function XMLRPC_GetValueID:Byte Ptr(value:Byte Ptr)
	
	Function XMLRPC_ValueIsFault:Int(value:Byte Ptr)
	Function XMLRPC_ResponseIsFault(response:Byte Ptr)
	Function XMLRPC_GetValueFaultCode:Int(value:Byte Ptr)
	Function XMLRPC_GetResponseFaultCode:Int(response:Byte Ptr)
	Function XMLRPC_GetValueFaultString:Byte Ptr(value:Byte Ptr)
	Function XMLRPC_GetResponseFaultString:Byte Ptr(response:Byte Ptr)
	Function XMLRPC_Free(mem:Byte Ptr)
	Function XMLRPC_GetVersionString:Byte Ptr()
Rem


XMLRPC_VALUE XMLRPC_UtilityCreateFault(int fault_code, const char* fault_string);

/* Get Values */
#define XMLRPC_VectorGetStringWithID(vector, id) XMLRPC_GetValueString(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetBase64WithID(vector, id) XMLRPC_GetValueBase64(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetDateTimeWithID(vector, id) XMLRPC_GetValueDateTime(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetDoubleWithID(vector, id) XMLRPC_GetValueDouble(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetIntWithID(vector, id) XMLRPC_GetValueInt(XMLRPC_VectorGetValueWithID(vector, id))
#define XMLRPC_VectorGetBooleanWithID(vector, id) XMLRPC_GetValueBoolean(XMLRPC_VectorGetValueWithID(vector, id))
Endrem
End Extern

Function XMLRPC_VectorGetValueWithID:Byte Ptr(vector:Byte Ptr, id:String)
	Local strId:Byte Ptr
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Byte Ptr = XMLRPC_VectorGetValueWithID_Case(vector, strId, xmlrpc_case_sensitive)
	MemFree(strId)
	Return val
End Function

Function XMLRPC_VectorAppendString:Int(vector:Byte Ptr, id:String, s:String, length:Int = 0)
	Local strId:Byte Ptr
	Local strS:Byte Ptr = s.ToCString()
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueString(strId, strS, length))
	MemFree(strId)
	MemFree(strS)
	Return val
End Function

Function XMLRPC_VectorAppendBase64:Int(vector:Byte Ptr, id:String, s:String, length:Int = 0)
	Local strId:Byte Ptr
	Local strS:Byte Ptr = s.ToCString()
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueBase64(strId, strS, length))
	MemFree(strId)
	MemFree(strS)
	Return val
End Function

Function XMLRPC_VectorAppendDateTime:Int(vector:Byte Ptr, id:String, time:Long)
	Local strId:Byte Ptr
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDateTime(strId, time))
	MemFree(strId)
	Return val
End Function

Function XMLRPC_VectorAppendDateTime_ISO8601:Int(vector:Byte Ptr, id:String, s:String)
	Local strId:Byte Ptr
	Local strS:Byte Ptr = s.ToCString()
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDateTime_ISO8601(strId, strS))
	MemFree(strId)
	MemFree(strS)
	Return val
End Function

Function XMLRPC_VectorAppendDouble:Int(vector:Byte Ptr, id:String, f:Double)
	Local strId:Byte Ptr
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueDouble(strId, f))
	MemFree(strId)
	Return val
End Function

Function XMLRPC_VectorAppendInt:Int(vector:Byte Ptr, id:String, i:Int)
	Local strId:Byte Ptr
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueInt(strId, i))
	MemFree(strId)
	Return val
End Function

Function XMLRPC_VectorAppendBoolean:Int(vector:Byte Ptr, id:String, i:Int)
	Local strId:Byte Ptr
	If id.Length > 0
		strId = id.ToCString()
	End If
	Local val:Int = XMLRPC_AddValueToVector(vector, XMLRPC_CreateValueBoolean(strId, i))
	MemFree(strId)
	Return val
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