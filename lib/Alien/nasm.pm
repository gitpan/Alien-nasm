package Alien::nasm;

use strict;
use warnings;
use base qw( Alien::Base );
use Env qw( @PATH );
use File::Spec;

# ABSTRACT: Find or build nasm, the netwide assembler
our $VERSION = '0.04'; # VERSION


my $in_path;

sub import
{
  return if Alien::nasm->install_type('system');
  return if $in_path;
  unshift @PATH, File::Spec->catdir(Alien::nasm->dist_dir, 'bin');
  # only do it once.
  $in_path = 1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::nasm - Find or build nasm, the netwide assembler

=head1 VERSION

version 0.04

=head1 SYNOPSIS

 use Alien::nasm;
 # nasm should now be in your PATH if it wasn't already

=head1 DESCRIPTION

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
