#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use XML::RPC;

# This is a small stress test to see if the server has any memory leaks
for(my $i = 0; $i<1000000;$i++) {
    my $xmlrpc = XML::RPC->new('http://localhost/');
    my $response = $xmlrpc->call('system.describeMethods');
}

