package URL::PercentEncode;
use strict;
use warnings;
require utf8;
use Exporter::Lite;
use Encode;
our $VERSION = '2.0';

our @EXPORT = qw(
  percent_encode_b
  percent_encode_c
  percent_decode_b
  percent_decode_c
  parse_form_urlencoded_b
);

sub percent_encode_b ($) {
  my $s = ''.$_[0];
  $s =~ s/([^0-9A-Za-z._~-])/sprintf '%%%02X', ord $1/ge;
  utf8::encode ($s);
  return $s;
} # percent_encode_b

sub percent_encode_c ($) {
  my $s = Encode::encode ('utf-8', ''.$_[0]);
  $s =~ s/([^0-9A-Za-z._~-])/sprintf '%%%02X', ord $1/ge;
  return $s;
} # percent_encode_c

sub percent_decode_b ($) {
  my $s = ''.$_[0];
  utf8::encode ($s) if utf8::is_utf8 ($s);
  $s =~ s/%([0-9A-Fa-f]{2})/pack 'C', hex $1/ge;
  return $s;
} # percent_decode_b

sub percent_decode_c ($) {
  my $s = ''.$_[0];
  utf8::encode ($s) if utf8::is_utf8 ($s);
  $s =~ s/%([0-9A-Fa-f]{2})/pack 'C', hex $1/ge;
  return Encode::decode ('utf-8', $s);
} # percent_decode_c

sub parse_form_urlencoded_b ($) {
  if (not defined $_[0]) {
    return {};
  } else {
    my $params = {};
    for (split /[&;]/, $_[0], -1) {
      my ($n, $v) = map { defined $_ ? percent_decode_b $_ : '' }
          split /[=]/, $_, 2;
      push @{$params->{defined $n ? $n : ''} ||= []}, defined $v ? $v : '';
    }
    return $params;
  }
} # parse_form_urlencoded_b

1;

=head1 LICENSE

Copyright 2010-2012 Wakaba <w@suika.fam.cx>

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
