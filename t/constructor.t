use Mojo::Base -strict;
use Test::More;
use Mojo::Server::TCP;

my $tcp = Mojo::Server::TCP->new;

is_deeply $tcp->listen, ['tcp://*:3000'], 'default listen';
is $tcp->server_class, 'Mojo::Server::Daemon', 'default daemon_class';
isa_ok $tcp->_server, 'Mojo::Server::Daemon';
is_deeply $tcp->_server->listen, [], 'servers listen is empty list';

$tcp->listen([]);
is $tcp->start, $tcp, 'start()';
is $tcp->stop, $tcp, 'stop()';

done_testing;
