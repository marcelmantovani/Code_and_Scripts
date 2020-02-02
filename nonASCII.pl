#!/usr/bin/perl

sub nonascii
{
    local $_ = shift;
    /[^0-\x7f]/   # or /[^[:ascii:]]/

}


while ( <> )            # loops while not eof
{
    @line = split(",", $_);
    foreach $field (@line)
    {
        chomp($field);
        if ($field =~/[^\0-\x7f]/)
        {
            printf("%s %s", $field, ord($&));
        }
    }
}