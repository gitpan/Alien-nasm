package My::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );
use Capture::Tiny qw( capture );
use Alien::Base::PkgConfig;
use File::Spec;
use Config;

# this will need to be updated with newer versions!
# also update inc/pkgconfig/nasm.pc
my $fetch_version = '2.11.05';

my $make = 'make';

# prefer GNU Make, if it is available
for($Config{gmake}, $Config{make}, 'gmake', 'make') {
  my($stdout, $stderr) = capture {
    system $_, '--version';
  };
  $make = $_ if $stdout =~ /GNU Make/;
}

sub new
{
  my($class, %args) = @_;
  
  $args{alien_name} = 'nasm';
  $args{alien_build_commands} = [
    '%c --prefix=%s',
    "$make",
  ];
  $args{alien_install_commands} = [
    "$make install",
  ],
  $args{alien_repository} = {
    protocol => 'http',
    host     => 'www.nasm.us',
    location => "/pub/nasm/releasebuilds/$fetch_version",
    pattern  => qr{^nasm-.*\.tar\.gz$},
  };
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

sub alien_check_installed_version
{
  my($stdout, $stderr) = capture {
    system 'nasm', '-v';
  };
  $stdout =~ /NASM version ([0-9.]+)/ ? $1 : ();
}

sub alien_load_pkgconfig
{
  my($self) = @_;
  my %pc;
  $pc{nasm} = Alien::Base::PkgConfig->new(File::Spec->catfile(qw( inc pkgconfig nasm.pc )));
  \%pc;
}

1;
