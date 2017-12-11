#!/usr/bin/env perl
use strict;
use warnings;

my $test_count = 0;
my $tot_line = 0;
my $tot_exec = 0;
my @fields;

    while (<>) {
        chomp;
        @fields = split /,/;
            if (@fields == 0) {
                # do nothing for a blank line
            } elsif (@fields == 1) {
                # do nothing for report name line
            } elsif ($fields[0] eq "project") {
                # do nothing for a header line
            } else {
                $test_count += 1;
                $tot_exec += $fields[2];
                $tot_line += $fields[3];
                printf("%s: %d %d %.2f\n", $fields[0], $fields[2], $fields[3], $fields[2]/$fields[3]);
            }
    }    
    print "Number tests: ", $test_count, "\n";
    print "Total lines: ", $tot_line, "\n";
    print "Lines executed: ", $tot_exec, "\n";
    printf("Coverage: %.2f\n", $tot_exec/$tot_line);
