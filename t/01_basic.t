use strict;
use warnings;
use Test::More;
use File::Temp ();
use Path::Tiny;
use Capture::Tiny 'capture';
my $tempdir = File::Temp::tempdir(CLEANUP => 1);

my $base = path(__FILE__)->parent->parent->absolute;

path("$tempdir/main.pl")->spew(<<'___');
use strict;
use warnings;
use My::App;

=encoding utf-8

=head1 NAME

foo - bar

=head1 SYNOPSIS


  Usage: pscp [options] source destination
   -c, --concurrency=NUM  ssh concurrency, default: 5
   -v, --verbose          turn on verbose message
   -h, --help             show this help
       --version          show version

  Examples:
   > pscp file.txt 'www[01-05].example.com:/path/to/file.txt'
   > pscp 'example.{com,jp}:file.txt' file.txt


=cut

My::App->help;
___

my $pm = path("$tempdir/lib/My/App.pm");
$pm->parent->mkpath;
$pm->spew(<<'___');
package My::App;
use Pod::Usage::Tiny;
sub help { Pod::Usage::Tiny->usage(2) }
1;
___

my ($out, $err, $exit) = capture {
    system $^X, "-I$base/lib", "-I$tempdir/lib", "$tempdir/main.pl";
};

ok !$err or diag "-> err: $err";
is $out, <<'___';

 Usage: pscp [options] source destination
  -c, --concurrency=NUM  ssh concurrency, default: 5
  -v, --verbose          turn on verbose message
  -h, --help             show this help
      --version          show version

 Examples:
  > pscp file.txt 'www[01-05].example.com:/path/to/file.txt'
  > pscp 'example.{com,jp}:file.txt' file.txt

___

is $exit >> 8, 2;

done_testing;
