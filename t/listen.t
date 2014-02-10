use utf8;
use Mojo::Base -strict;
use Mojo::IOLoop;
use Mojo::Server::TCP;
use Test::More;

my $port = Mojo::IOLoop->generate_port;
my($id, $tcp);

{
  $tcp = Mojo::Server::TCP->new;

  is $tcp->listen(["tcp://localhost:$port"]), $tcp, "listen() $port";
  is $tcp->start, $tcp, 'start()';

  is int(@{ $tcp->{acceptors} || [] }), 1, 'one acceptor';
  $id = $tcp->{acceptors}[0];
}

{
  my(@event, @sig, $id);
  $tcp->on(connect => sub { push @event, connect => @_; });
  $tcp->on(close => sub { push @event, close => @_; Mojo::IOLoop->stop });
  $tcp->on(read => sub { push @event, read => @_; });

  Mojo::IOLoop->client(
    { port => $port },
    sub {
      my($loop, $err, $stream) = @_;
      diag $err || 'Connected to TCP server';
      @sig = @SIG{qw( INT TERM )};
      $stream->write("too cool o/ æøå!", sub { shift->close; });
    },
  );

  Mojo::IOLoop->timer(2 => sub { Mojo::IOLoop->stop; });
  $tcp->run;

  is shift(@event), 'connect', 'connect event';
  is shift(@event), $tcp, 'connect: tcp';
  $id = shift @event;
  like $id, qr{^\w+$}, 'connect: id';

  is shift(@event), 'read', 'read event';
  is shift(@event), $tcp, 'read: tcp';
  is shift(@event), $id, 'read: id';
  is shift(@event), "too cool o/ æøå!", 'read: chunk';
  isa_ok shift(@event), 'Mojo::IOLoop::Stream', 'read: stream';

  is shift(@event), 'close', 'close event';
  is shift(@event), $tcp, 'close: tcp';
  is shift(@event), $id, 'read: id';

  is int(grep { $_ } @sig), 2, 'INT and TERM set up';

  @event = ();
  @sig = ();
}

{
  undef $tcp;
  is(Mojo::IOLoop->acceptor($id), undef, 'acceptor was destroyed');
}

done_testing;
