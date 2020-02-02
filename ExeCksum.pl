#!/usr/bin/perl

while (<>)
{
    @filein = split (" ", $_);

    print "File name : $filein[2] \n";
    $whichres = `which $filein[2]`;

    $cksum = `cksum $whichres`;
    print "CKSUM - file   : $filein[0] $filein[1]\n";
    print "CKSUM - system : $cksum \n";
}
