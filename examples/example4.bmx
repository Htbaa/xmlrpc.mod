SuperStrict
Import htbaapub.xmlrpc

Local server:TXMLRPC_Server = New TXMLRPC_Server
server.RegisterMethod("func1", "WrappedFunctions.testfunc1")
server.RegisterMethod("func1", "WrappedFunctionss.testfunc1")
server.Shutdown()



Type WrappedFunctions
	Function testfunc1:Int(x:Int, y:Int)
		Return 100
	End Function
End Type
