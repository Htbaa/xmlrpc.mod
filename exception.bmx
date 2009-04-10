Rem
	bbdoc:
End Rem
Type TXMLRPC_Exception
	Field message:String
	Rem
		bbdoc:
	End Rem
	Method Create:TXMLRPC_Exception(message:String)
		Self.message = message
	End Method
	
	Rem
		bbdoc:
	End Rem
	Method ToString:String()
		Return Self.message
	End Method
End Type
