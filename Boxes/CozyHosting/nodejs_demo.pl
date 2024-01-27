#!/usr/bin/perl
use strict;
use Socket;


my $debug=1;

my $host = "10.10.11.230"; 		# "foo.com";
my $port = 80; 		# 80;

socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "Can't create a socket $ ($!)\n";
connect( SOCKET, pack_sockaddr_in($port, inet_aton($host)))
   or die "Can't connect to port $port ($!)\n";
my $old_fh = select(SOCKET);
$| = 1;
select($old_fh);

sub dump_socket
{
	if ($debug)
	{
		my $data;
		#recv(SOCKET,$data,999999,MSG_DONTWAIT);
		recv(SOCKET,$data,999999,0);
		print $data;
	}
}

	print SOCKET "GET / HTTP/1.1\r\n";
	print SOCKET "Host: www.example.com\r\n";
	print SOCKET "Connection: Keep-Alive\r\n";
	print SOCKET "Content\rLength: 42\r\n";
	print SOCKET "Length: 42\r\n";
	print SOCKET "\r\n";

	sleep(1);
	dump_socket();
	print "**** Second Request ***\n\n\n";
	
	print SOCKET "GET /proxy_sees_this HTTP/1.1\r\n";
	print SOCKET "Something: GET /node_sees_this HTTP/1.1\r\n";
	print SOCKET "Cache-Control: no-cache\r\n";
	print SOCKET "Host: www.example.com\r\n";
	print SOCKET "\r\n";
	sleep(1);
	dump_socket();

