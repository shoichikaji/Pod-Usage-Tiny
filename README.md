# NAME

Pod::Usage::Tiny - Show usage from pod

# SYNOPSIS

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

# DESCRIPTION

Pod::Usage::Tiny prints usage from main script's pod.
I don't like [Pod::Usage](https://metacpan.org/pod/Pod::Usage)'s `pod2usage` very much,
because it inserts quite a lot of indent to usage.

# METHODS

- `my $string = Pod::Usage::Tiny->usage_string`

    Retrieve `SYNOPSIS` or `USAGE` section from main script's pod.

- `Pod::Usage::Tiny->usage( $exit ||= 0 )`

    Print usage to STDOUT, and exit with `$exit` status code.

# COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji &lt;skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
