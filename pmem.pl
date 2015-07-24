#!/usr/bin/perl
#
# This script should be run every 5 minutes.
#
use strict;
use warnings;
use RRDs;

# parse configuration file
my %conf;
eval(`cat /home/spatel/rrd/rrd-conf.pl`);
die $@ if $@;

# set variables
my $datafile = "$conf{DBPATH}/pmem.rrd";
my $picbase  = "$conf{OUTPATH}/pmem-";

# global error variable
my $ERR;

# whoami?
my $hostname = `/bin/hostname`;
chomp $hostname;

# generate database if absent
if ( ! -e $datafile ) {
    # max 3G/5G for each value
    RRDs::create($datafile,
                 "DS:freeswitch:GAUGE:600:0:65000000000",
                 "DS:httpd:GAUGE:600:0:65000000000",
                 "DS:mysqld:GAUGE:600:0:65000000000",
                 "DS:startfsr2:GAUGE:600:0:65000000000",
                 "RRA:AVERAGE:0.5:1:600",
                 "RRA:AVERAGE:0.5:6:700",
                 "RRA:AVERAGE:0.5:24:775",
                 "RRA:AVERAGE:0.5:288:797"
                 );
      $ERR=RRDs::error;
      die "ERROR while creating $datafile: $ERR\n" if $ERR;
      print "created $datafile\n";
}

# sub - convert GB to MB
sub convertgb2mb {
        my ($line) = @_;
        if ($line =~ /=\s+(\d+\.\d+)\s*(\w+)/) {
                        if ($2 eq "GiB") {
                            $_ = $1*1024;
                        } else {
                            $_ = $1;

                        }
                 }
}
# end sub


# get memory usage
open(PS_F, "/usr/local/bin/ps_mem.py|");

my ($freeswitch, $httpd, $mysqld, $startfsr2);

while (my $line = <PS_F>) {

        if ($line =~ /=\s*(\d+\.\d+)\s*\w+\s*(\w+)/gm){
           if ($2 eq "freeswitch") {
               $freeswitch = convertgb2mb($line);
           } elsif ($2 eq "httpd") {
               $httpd = convertgb2mb($line);
           } elsif ($2 eq "mysqld") {
               $mysqld = convertgb2mb($line);
           } elsif ($2 eq "startfsr2") {
               $startfsr2 = convertgb2mb($line);
           }
        }
}

close(PS_F);
#print "${freeswitch}:${httpd}:${mysqld}:${startfsr2}\n";
# update database
RRDs::update($datafile,
             #"N:${used}:${free}:${buffer}:${cache}:${swap_used}:${swap_free}"
             "N:${freeswitch}:${httpd}:${mysqld}:${startfsr2}"
             );
$ERR=RRDs::error;
die "ERROR while updating $datafile: $ERR\n" if $ERR;

# draw pictures
foreach ( [3600, "hour"], [86400, "day"], [604800, "week"], [31536000, "year"] ) {
    my ($time, $scale) = @{$_};
    RRDs::graph($picbase . $scale . ".png",
                "--start=-${time}",
                '--lazy',
                '--imgformat=PNG',
                "--title=${hostname} applicaion memory usage (last $scale)",
                '--base=1024',
                "--width=$conf{GRAPH_WIDTH}",
                "--height=$conf{GRAPH_HEIGHT}",

                "DEF:freeswitch_x=${datafile}:freeswitch:AVERAGE",
                "DEF:httpd_x=${datafile}:httpd:AVERAGE",
                "DEF:mysqld_x=${datafile}:mysqld:AVERAGE",
                "DEF:startfsr2_x=${datafile}:startfsr2:AVERAGE",

                'CDEF:freeswitch=freeswitch_x,1048576,*',
                'CDEF:httpd=httpd_x,1048576,*',
                'CDEF:mysqld=mysqld_x,1048576,*',
                'CDEF:startfsr2=startfsr2_x,1048576,*',

                #'AREA:freeswitch',
                #'STACK:free#90E000:mem freeswitch',
                #'STACK:cache#E0E000:mem httpd',
                #'STACK:buffer#F0A000:mem mysqld',
                #'STACK:used#E00070:mem startfsr2',
                'LINE1:freeswitch#0000D0:freeswitch',
                'LINE1:httpd#40e0d0:httpd',
                'LINE1:mysqld#00EE00:mysqld',
                'LINE1:startfsr2#E00070:startfsr2',
                );
    $ERR=RRDs::error;
    die "ERROR while drawing $datafile $time: $ERR\n" if $ERR;
}

