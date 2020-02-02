#!/usr/bin/perl

die "Usage\n findtag.pl file.log search_tag\n" if $#ARGB < 1;

my $logname = $ENV{LOG_DIR}."/".$ARGV[0]."*.log";
my $cmd = "grep -l $ARGV[1] $logname | xargs ls -lt | head -1 | xargs less +?$ARGV[1]";

system ($cmd);

