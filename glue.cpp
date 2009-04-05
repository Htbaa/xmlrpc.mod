#define _MSC_VER 1
// #import <blitz.h>
#include "xmlrpc-epi-0.54/src/xmlrpc.h"
#include <stdio.h>

extern "C" {
	STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS *XMLRPC_Create_STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS(XMLRPC_VERSION version) {
		STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS *options = new STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS;
		options->version = version;
		return options;
	}
	/*
	void XMLRPC_Delete_Request_Output_Options(STRUCT_XMLRPC_REQUEST_OUTPUT_OPTIONS *options) {
		delete options;
	}
	*/
}