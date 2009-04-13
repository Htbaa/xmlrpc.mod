Rem
	bbdoc: Exception for TXMLRPC_Server
End Rem
Type TXMLRPC_Server_Exception Extends TXMLRPC_Exception
End Type

Rem
	bbdoc: XML-RPC Server
	about: This type will allow you to create an XML-RPC server. Currently not yet implemented.
End Rem
Type TXMLRPC_Server

	Field server:Byte Ptr

	Rem
		bbdoc:
	End Rem
	Method New()
		Self.server = XMLRPC_ServerCreate()
	End Method
	
	Rem
		bbdoc: Call this method when your done with the server
	End Rem
	Method Shutdown()
		If Self.server
			XMLRPC_ServerDestroy(Self.server)
		End If
	End Method
	
	Rem
		bbdoc:
		about: functionName is the name that'll be registered with the XML-RPC server. bmxName is a string containing the type and function name you want to register, e.g. MyType.SomeFunction
	End Rem
	Method RegisterMethod(functionName:String, bmxName:String)
		Throw New TXMLRPC_Server_Exception.Create("Not yet implemented. As Functions cannot be inspected by Reflection")
	
		Local s:String[] = bmxName.Split(".")
		If Not s.Length = 2
			Throw New TXMLRPC_Server_Exception.Create("The passed BlitzMax function name is invalid. It should be in the format of Type.FunctionName")
		End If
		Local bmxTypeName:String = s[0]
		Local bmxFunctionName:String = s[1]
		
		Local typeid:TTypeId = TTypeId.ForName(s[0])
		If Not typeid
			Throw New TXMLRPC_Server_Exception.Create("Unknown type " + s[0] + " not found")
		End If
		
		Local func:TMethod = typeid.FindMethod(s[1])
		If Not func
			Throw New TXMLRPC_Server_Exception.Create("Unkown function " + s[1])
		End If
		DebugLog typeid.Name()
		
		DebugLog s[0] + s[1]
	End Method
End Type
