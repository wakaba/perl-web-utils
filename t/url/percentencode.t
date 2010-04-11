package test::URL::PercentEncode;
use strict;
use warnings;
use Path::Class;
use lib file (__FILE__)->dir->parent->parent->subdir ('lib')->stringify;
use base qw(Test::Class);
use Test::More;
use URL::PercentEncode;
use Encode;

sub _flagged ($) {
  return decode 'utf8', $_[0];
} # _flagged

sub _pe : Test(28) {
  for (
      [undef, '', ''],
      ['' => '', ''],
      ['abc' => 'abc', 'abc'],
      [_flagged 'abc' => 'abc', 'abc'],
      ["\xA1\xC8\x4E\x4B\x21\x0D" => '%A1%C8NK%21%0D', '%C2%A1%C3%88NK%21%0D'],
      ["http://abc/a+b?x(y)z~[*]" => 'http%3A%2F%2Fabc%2Fa%2Bb%3Fx%28y%29z~%5B%2A%5D', 'http%3A%2F%2Fabc%2Fa%2Bb%3Fx%28y%29z~%5B%2A%5D'],
      ["\x{4e00}\xC1" => '%4E00%C1', '%E4%B8%80%C3%81'],
  ) {
    my $s = percent_encode_b ($_->[0]);
    is $s, $_->[1];
    ok !utf8::is_utf8 ($s);

    my $t = percent_encode_c ($_->[0]);
    is $t, $_->[2];
    ok !utf8::is_utf8 ($s);
  }
} # _pe

sub _pd : Test(36) {
  for (
      [undef, '', ''],
      ['', '', ''],
      ['abc', 'abc', 'abc'],
      [_flagged 'abc', 'abc', 'abc'],
      ['%A1%C8NK%21%0D', "\xA1\xC8NK!\x0D", "\x{FFFD}\x{FFFD}NK!\x0D"],
      ['%C2%A1%C3%88NK%21%0D', "\xC2\xA1\xC3\x88NK!\x0D", "\xA1\xC8NK!\x0D"],
      ['http%3A%2F%2Fabc%2Fa%2Bb%3Fx%28y%29z~%5B%2A%5D', 'http://abc/a+b?x(y)z~[*]', 'http://abc/a+b?x(y)z~[*]'],
      ["\xA1\xC8\x4E\x4B\x21\x0D", "\xA1\xC8NK!\x0D", "\x{FFFD}\x{FFFD}NK!\x0D"],
      ["\x{4e00}\xC1", "\xE4\xB8\x80\xC3\x81", "\x{4e00}\xC1"],
      ['%4E00%C1', "\x4e00\xC1", "\x4e00\x{FFFD}"],
      ['%E4%B8%80%C3%81', "\xE4\xB8\x80\xC3\x81", "\x{4e00}\xC1"],
      [_flagged '%E4%B8%80%C3%81', "\xE4\xB8\x80\xC3\x81", "\x{4e00}\xC1"],
  ) {
    no warnings 'uninitialized';

    my $s = percent_decode_b ($_->[0]);
    is $s, $_->[1], join '/', '_pd', 'b', $_->[0];
    ok !utf8::is_utf8 ($s);

    my $t = percent_decode_c ($_->[0]);
    is $t, $_->[2], join '/', '_pd', 'c', $_->[0];
  }
} # _pd

__PACKAGE__->runtests;

1;
