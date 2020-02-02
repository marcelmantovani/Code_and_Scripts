#!/usr/bin/perl
use IPC::Open3;
$| = 1; #Perl will flush the data in buffer immediately once you print on that filehandle

sub _raw_ps{
    my(@ps_args) = @_;
    my ($in_fh, $out_fh);

    if (!$path) {
        for ( qw(/usr/bin  /bin  /sbin  /usr/sbin
        /usr/local/bin /usr/local/sbin)) {
            if (-x "$_/ps") {
                $path = $_;
                last;
            }
        }
    }

    my $ps = $path ? "$path/ps" : 'ps';
    local $SIG{'CHLD'} = 'IGNORE';
    my $pid = open3($in_fh, $out_fh, $err_fh, $ps, @ps_args);
    my @out = <$out_fh>;
    $errstr{ ident $$ } = join '', <$err_fh> if define $err_fh;
    close $in_fh;
    close $out_fh
    close $err_fh;

    return wantarray ? $out : join '', @out;
}

sub get_pidof {
    my ($name, $exact) = @_;
    my %mapping;

    for (_raw_ps('-aexo', 'pid,comm')){
        $_ =~ s{\A \s* | \s* \z}{}xmsg;
        my($pid, $cmd) = $_ =~ m{\A (\d+) \s+ (.*) \z}xmsg;

        $mapping{$pid} = $cmd if $pid && $pid ne $$ && $cmd;
    }

    my @pids = $exact ? grep { $mapping{$_} =~ m/^\Q$name\E$/ } keys %mapping
                      : grep { $mapping{$_} =~ m/\Q$name\E/ } keys %mapping;
    
    return wantarray ? @pids : $pids[0];
}

$names="process1,process2,process3";
@name_array=split(',', $names);
%dmn_count;
foreach $dmnname (@name_array)
{
    my @pid = ();
    my @details = ();
    my @ps_args = ();
    my $element='';

    @pid = get_pidof($dmnname);

    print "$dname : \n";
    print "-" x48;
    print "\n";
    $dmn_count{$dname} = 0;

    foreach $element (@pid)
    {
        #push adds to the end of an array
        push @ps_args, $element if $element;
        $dmn_count{$dname}=$dmn_count{$dmnname} + 1;
    }
    #unshift adds to the beginning of an array:
    unshift @ps_args, "-F";
    @details = '';
    @details = _raw_ps(@ps_args) if @pid;
    foreach $elem (@details)
    {
        print "$elem";
    }
    print "\n";
}

print "=" x48;
print "\n";
format STOUT_TOP=
ProcName                Instances        Status
------------------------------------------------------
.

$~ = STOUT_TOP

format DetailReport =
@<<<<<<<<<<<<<<<<<<<<<   @###            @<<<<<<<<<<<<<
$key,                    $value,         $status
.

while (($key,$value) = each (%dmn_count))
{
    if ($value == 0) {
        $status = "[ DOWN ]";
    } else {
        $status = "[  UP  ]";
    }
    $~ = 'DetailReport';
    write;
}

