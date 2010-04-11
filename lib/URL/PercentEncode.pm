package URL::PercentEncode;
use strict;
use warnings;
require utf8;
use Exporter::Lite;

our @EXPORT = qw(
  percent_encode_b
  percent_encode_c
  percent_decode_b
  percent_decode_c
);

sub percent_encode_b ($) {
  my $s = $_[0];
  $s =~ s/([^0-9A-Za-z._~-])/sprintf '%%%02X', ord $1/ge;
  utf8::encode ($s);
  return $s;
} # percent_encode_b

sub percent_encode_c ($) {
  require Encode;
  my $s = Encode::encode ('utf8', $_[0]);
  $s =~ s/([^0-9A-Za-z._~-])/sprintf '%%%02X', ord $1/ge;
  return $s;
} # percent_encode_c

sub percent_decode_b ($) {
  my $s = ''.shift;
  utf8::encode ($s) if utf8::is_utf8 ($s);
  $s =~ s/%([0-9A-Fa-f]{2})/pack 'C', hex $1/ge;
  return $s;
} # percent_decode_b

sub percent_decode_c ($) {
  my $s = ''.shift;
  utf8::encode ($s) if utf8::is_utf8 ($s);
  $s =~ s/%([0-9A-Fa-f]{2})/pack 'C', hex $1/ge;
  require Encode;
  return Encode::decode ('utf8', $s);
} # percent_decode_c

1;
