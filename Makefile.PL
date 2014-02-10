use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Mojo::Server::TCP',
  ABSTRACT_FROM => 'lib/Mojo/Server/TCP.pm',
  VERSION_FROM => 'lib/Mojo/Server/TCP.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {
    'Mojolicious' => '4.60',
  },
  BUILD_REQUIRES => {
    'Test::More' => '0.90',
  },
  META_MERGE => {
    resources => {
      license => 'http://dev.perl.org/licenses/',
      homepage => 'https://metacpan.org/release/Mojo-Server-TCP',
      bugtracker => 'https://github.com/jhthorsen/mojo-server-tcp/issues',
      repository => 'https://github.com/jhthorsen/mojo-server-tcp.git',
    },
  },
  test => {
    TESTS => 't/*.t',
  },
  #MIN_PERL_VERSION => 5.10,
  #EXE_FILES => ['bin/my-app'],
);
