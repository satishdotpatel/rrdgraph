# $Id: sample.conf,v 1.11 2007-08-05 13:59:58 mitch Exp $
#
# Sample configuration file for RRD scripts
#
# edit and copy to ~/.rrd-conf.pl

##
## Global configuration

# Where are the RRD databases?
$conf{DBPATH} = '/home/spatel/rrd/db';

# Where are the pictures and html pages?
$conf{OUTPATH} = '/var/www/mrtg/rrd';

# Which kernel is being used?  ('2.4' and '2.6' are supported).
$conf{KERNEL} = '2.6';

# How wide should the graphs be?
$conf{GRAPH_WIDTH} = 400;

# How tall should the graphs be?
$conf{GRAPH_HEIGHT} = 100;

##
## diskfree script

# These 20 mount points are shown in the diskfree script.
# Enter '' for non-existant mount points.
$conf{DISKFREE_PATHS} = [
                           '/',
                           '/tmp',
                           '/mnt/root',
                           '/mnt/big',
                           '/mnt/home',
                           '/mnt/storage',
                           '/mnt/tomochan',
                           '/mnt/luggage',
                           '/mnt/win',
                           '/mnt/images',
                           '/mnt/neu',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           ''
                           ];



##
## network script

# Enter your network devices with name and input/output ratio.
# For tunnels, an optional 4th parameter with the "interface name" is available.
$conf{NETWORK_DEVICES} = [ # device    in_max,  out_max, {name}
                           [ 'bond1', 15000000, 15000000],
                           [ 'bond0', 15000000, 15000000, 'Internal' ],
                           ];


##
## temperature script

$conf{SENSORS_BINARY}      = '/usr/bin/sensors';
$conf{HDDTEMP_BINARY}      = '/usr/bin/sudo /usr/local/sbin/hddtemp.sh';

$conf{SENSOR_MAPPING_CPU}  = ['Core0 Temp', 'Core1 Temp'];
$conf{SENSOR_MAPPING_FAN}  = ['fan1', 'fan2'];
$conf{SENSOR_MAPPING_TEMP} = ['temp1', 'temp2'];


##
## dnscache script

# Path to dnscache logs
$conf{DNSCACHE_LOGPATH} = '/var/log/djbdns/dnscache';


##
## roundtrip script

# path to roundtrip binary
$conf{ROUNDTRIP_BIN} = '/home/mitch/perl/scanhosts/roundtrip.pl';

# monitor which hosts? (up to 20)
$conf{ROUNDTRIP_HOSTS} = [
                          'yggdrasil',
                          'squeezebox',
                          'tomochan',
                          'ms1067a1',
                          'merlin',
                          'samsung',
                          'arthus',
                          'morgana',
                          'ari',
                          'oni',
                          'www',
                          'agarbs.vpn',
                          'dgarbs.vpn',
                          'yuuhi.vpn',
                          'ikari.vpn',
                          'lalufu.vpn',
                          'psycorama.vpn',
                          'ranma.vpn',
                          '',
                          ''
                          ];


##
## make_html script

# Include these modules in the html pages:
$conf{MAKEHTML_MODULES} = [ qw (load io cpu eth0 memory diskfree netstat) ];


##
## internal stuff

# expand home directories
$conf{DBPATH}  =~ s/^~/$ENV{HOME}/;
$conf{OUTPATH} =~ s/^~/$ENV{HOME}/;

