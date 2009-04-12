SuperStrict

Rem
	bbdoc: htbaapub.xmlrpc
	about: An XML-RPC module, using XMLRPC-EPI. Please check out the examples in the example directory to find out how to use this module. The project is open source and can be found at Github (see bottom of page for link).
EndRem
Module htbaapub.xmlrpc
ModuleInfo "Name: htbaapub.xmlrpc"
ModuleInfo "Version: 0.5"
ModuleInfo "Author: Christiaan Kras"
ModuleInfo "Git repository: http://github.com/Htbaa/htbaapub.mod/"
ModuleInfo "XMLRPC-EPI: http://xmlrpc-epi.sourceforge.net/"
ModuleInfo "Expat: http://expat.sourceforge.net/"
ModuleInfo "iconv: http://gnuwin32.sourceforge.net/packages/libiconv.htm"
ModuleInfo "iconv-win32: http://www.zlatkovic.com/pub/libxml"

Import brl.blitz
Import brl.basic
Import brl.map
Import brl.reflection
Import brl.socket

Import "src/expat-2.0.1/src/*.h"
ModuleInfo "CC_OPTS: -DHAVE_EXPAT_CONFIG_H"
?ppc
	ModuleInfo "CC_OPTS: -DWORDS_BIGENDIAN"
?

Import "src/expat-2.0.1/src/xmlparse.c"
Import "src/expat-2.0.1/src/xmlrole.c"
Import "src/expat-2.0.1/src/xmltok.c"
Import "src/expat-2.0.1/src/xmltok_impl.c"
Import "src/expat-2.0.1/src/xmltok_ns.c"

Import "src/xmlrpc-epi-0.54/src/*.h"
Import "glue.c"

?Win32
	Import "win32.cpp"
	ModuleInfo "LD_OPTS: -L%PWD%/src/iconv-1.9.2.win32/lib"
	Import "src/iconv-1.9.2.win32/include/*.h"
?

Import "-liconv"

Import "src/xmlrpc-epi-0.54/src/xmlrpc.c"
Import "src/xmlrpc-epi-0.54/src/base64.c"
Import "src/xmlrpc-epi-0.54/src/encodings.c"
Import "src/xmlrpc-epi-0.54/src/queue.c"
Import "src/xmlrpc-epi-0.54/src/simplestring.c"
Import "src/xmlrpc-epi-0.54/src/system_methods.c"
Import "src/xmlrpc-epi-0.54/src/xml_element.c"
Import "src/xmlrpc-epi-0.54/src/xml_to_dandarpc.c"
Import "src/xmlrpc-epi-0.54/src/xml_to_soap.c"
Import "src/xmlrpc-epi-0.54/src/xml_to_xmlrpc.c"
Import "src/xmlrpc-epi-0.54/src/xmlrpc_introspection.c"

Include "wrapper.bmx"
Include "datatypes.bmx"
Include "response.bmx"
Include "transport.bmx"
Include "client.bmx"
Include "server.bmx"

Rem
	bbdoc: General XML-RPC Exception
End Rem
Type TXMLRPC_Exception
	Field message:String
	Rem
		bbdoc: Set message for exception
	End Rem
	Method Create:TXMLRPC_Exception(message:String)
		Self.message = message
		Return Self
	End Method
	
	Rem
		bbdoc: Return exception message
	End Rem
	Method ToString:String()
		Return Self.message
	End Method
End Type

Rem
	bbdoc: Parameters to be passed to the XML-RPC server when using TXMLRPC_Client.Call()
End Rem
Type TXMLRPC_Call_Parameters
	Field vector:Byte Ptr

	Rem
		bbdoc: Create a TXMLRPC_Call_Parameters object.
		about: vectorType can be: xmlrpc_vector_none, xmlrpc_vector_array, xmlrpc_vector_mixed or xmlrpc_vector_struct
	End Rem
	Function Create:TXMLRPC_Call_Parameters(vectorType:Int = xmlrpc_vector_mixed)
		Local parameters:TXMLRPC_Call_Parameters = New TXMLRPC_Call_Parameters
		parameters.vector = XMLRPC_CreateVector(Null, vectorType)
		Return parameters
	End Function

	Rem
		bbdoc: Append string value
	End Rem
	Method AppendString:Int(id:String, s:String)
		Return XMLRPC_VectorAppendString(Self.vector, id, s)
	End Method
	
	Rem
		bbdoc: Append Base64 value. Just pass a string, it'll be BASE64 encoded for you
	End Rem
	Method AppendBase64:Int(id:String, s:String)
		Return XMLRPC_VectorAppendBase64(Self.vector, id, s)
	End Method
	
	Rem
		bbdoc: Append UNIX timestmap value
	End Rem
	Method AppendDateTime:Int(id:String, time:Long)
		Return XMLRPC_VectorAppendDateTime(Self.vector, id, time)
	End Method

	Rem
		bbdoc: Append datetime in ISO8601 format
	End Rem
	Method AppendDateTime_ISO8601:Int(id:String, s:String)
		Return XMLRPC_VectorAppendDateTime_ISO8601(Self.vector, id, s)
	End Method

	Rem
		bbdoc: Append double value
	End Rem
	Method AppendDouble:Int(id:String, f:Double)
		Return XMLRPC_VectorAppendDouble(Self.vector, id, f)
	End Method

	Rem
		bbdoc: Append integer value
	End Rem
	Method AppendInt:Int(id:String, i:Int)
		Return XMLRPC_VectorAppendInt(Self.vector, id, i)
	End Method

	Rem
		bbdoc: Append boolean value
	End Rem
	Method AppendBoolean:Int(id:String, i:Byte)
		Return XMLRPC_VectorAppendBoolean(Self.vector, id, i)
	End Method
End Type
