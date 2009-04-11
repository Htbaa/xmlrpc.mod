#include "xmlrpc.h"


void bmxXMLRPC_RequestSetOutputOptions(XMLRPC_REQUEST request, XMLRPC_VERSION version) {
	STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS output = {{0}};
	output.version = version;
	XMLRPC_RequestSetOutputOptions(request, &output);
}
