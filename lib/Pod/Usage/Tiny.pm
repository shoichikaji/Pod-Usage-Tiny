package Pod::Usage::Tiny;
use strict;
use warnings;
use Pod::Simple::SimpleTree;
use Encode ();

our $VERSION = '0.01';

sub new { bless {}, shift }
sub usage_string {
    my ($class, %option) = @_;
    my $tree = Pod::Simple::SimpleTree->new;
    # XXX strip_verbatim_indent?
    my $root = $tree->parse_file($0)->root;
    my $found = -1;
    for my $i (0 .. $#{$root}) {
        my $elem = $root->[$i];
        next unless ref $elem eq "ARRAY" and ($elem->[2] || "") =~ /^(?:SYNOPSIS|USAGE)$/i;
        $found = $i + 1;
        last;
    }
    if ($found == -1) {
        warn "Couldn't find SYNOPSIS nor USAGE in $0";
        return "";
    }
    my @usage = split /\n/, $root->[$found][2];
    my ($strip) = $usage[0] =~ /^(\s+)/;
    for my $usage (@usage) {
        $usage =~ s/^$strip//;
        $usage = " $usage" if $usage;
    }
    "\n" . (join "\n", @usage) . "\n\n";
}

sub usage {
    my $class = shift;
    my $exit = shift || 0;
    print Encode::encode_utf8($class->usage_string);
    exit $exit;
}

1;
__END__

=encoding utf-8

=head1 NAME

Pod::Usage::Tiny - Show usage from pod

=head1 SYNOPSIS

  use Pod::Usage::Tiny;
  sub help { Pod::Usage::Tiny->usage }

  my $arg = shift;
  help if $arg =~ /^(-h|--help)$/;
  ...

  =head1 SYNOPSIS

   Usage: my-program [options] arg1
    -h, --help    show usage
    -v, --version show version

   Example:
    $ my-program --help
    $ my-program arg1

  =cut

Then:

  $ my-program --help

   Usage: my-program [options] arg1
    -h, --help    show usage
    -v, --version show version

   Example:
    $ my-program --help
    $ my-program arg1

=head1 DESCRIPTION

Pod::Usage::Tiny print usage from main script's pod.
I don't like L<Pod::Usage>'s C<pod2usage> very much,
because it insert quite a lot of indent to usage.

=head1 METHODS

=over 4

=item C<< my $string = Pod::Usage::Tiny->usage_string >>

Retrive C<SYNOPSIS> or C<USAGE> section from main script's pod.

=item C<< Pod::Usage::Tiny->usage( $exit ||= 0 ) >>

Print usage to STDOUT, and exit with C<$exit> status code.

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
