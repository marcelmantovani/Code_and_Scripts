#!/usr/bin/perl
use File::Find ();

$compress_prog= 'gzip';
$compress_suffix = '\.gz';


use vars qw/*name *dir *prune/;
*name = *File::Find::name;
*dir  = *File::Find::dir;
*prune= *File::Find::prune;


sub wanted;

File::Find::find({wanted => \&wanted}, '/tmp/dir1', '/tmp/dir2');
exit;

sub wanted {
    my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $ctime, $blksize, $blocks);

    (($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $ctime, $blksize, $blocks) = lstat($_)) &&
    -f _ &&
    (int (-s _) > 500000000) &&
    (! /.*$compress_suffix/) &&
    print ("$name\n");
}
