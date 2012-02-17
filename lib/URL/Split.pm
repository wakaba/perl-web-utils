package URL::Split;
use strict;
use warnings;
our $VERSION = '1.0';
use Exporter::Lite;
use URL::PercentEncode qw(percent_decode_c);

our @EXPORT_OK = qw(split_query_params);

sub split_query_params ($) {
    my $u = shift;
    my $fragment;
    if ($u =~ s{\#(.*)}{}s) {
        $fragment = percent_decode_c $1;
    }
    my %params;
    if ($u =~ s{\?(.*)}{}s) {
        for (split /[&;]/, $1) {
            my ($n, $v) = map { percent_decode_c $_ } split /=/, $_, 2;
            push @{$params{$n} ||= []}, $v;
        }
    }
    return {
        url => $u,
        params => \%params,
        fragment => $fragment,
    };
}

1;

=head1 LICENSE

Copyright 2012 Hatena <http://www.hatena.com/>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
