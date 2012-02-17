package test::URL::Split;
use strict;
use warnings;
use Path::Class;
use lib file (__FILE__)->dir->parent->parent->subdir ('lib')->stringify;
use base qw(Test::Class);
use Test::Differences;
use URL::Split qw(split_query_params);
use Encode;

sub _split_query_params : Test(5) {
    for (
        [q<http://foo> => {url => q<http://foo>,
                           params => {}, fragment => undef}],
        [q<http://foo/?abc=def&xtz=%25%4E%9ac>
             => {url => q<http://foo/>,
                 params => {abc => ['def'], xtz => ["%N\x{FFFD}c"]},
                 fragment => undef}],
        [q<http://foo/?abc=def&xtz=%25%4E%9ac#a#%fe>
             => {url => q<http://foo/>,
                 params => {abc => ['def'], xtz => ["%N\x{FFFD}c"]},
                 fragment => "a#\x{FFFD}"}],
        [q<http://foo/?abc=def&xtz=%25%4E%9ac&abc=123>
             => {url => q<http://foo/>,
                 params => {abc => ['def', '123'], xtz => ["%N\x{FFFD}c"]},
                 fragment => undef}],
        [q<http://foo/?abc=def&xtz=%25?%4E%9ac#?abc>
             => {url => q<http://foo/>,
                 params => {abc => ['def'], xtz => ["%?N\x{FFFD}c"]},
                 fragment => '?abc'}],
    ) {
        eq_or_diff split_query_params $_->[0], $_->[1];
    }
}

__PACKAGE__->runtests;

1;

=head1 LICENSE

Copyright 2012 Hatena <http://www.hatena.com/>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
