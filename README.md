# rrdgraph

## About

Its bunch of perl script using RRDTool modules to generate historical graphs.

## Usage

Drop all files in single folder and configure rrd-conf.pl to set some variables and path.
When you run any perl script it will create rrd data directory in local dir.

## Cron

Add them in cron to run periodically 

0-59/5 * * * * /home/spatel/rrd/memory.pl >/dev/null

0-59/5 * * * * /home/spatel/rrd/pmem.pl >/dev/null

## Sample Graph 

## CPU

![Alt text](https://raw.githubusercontent.com/satishdotpatel/rrdgraph/master/sample-graph/cpu.png "CPU Graph")

## Memory

![Alt text](https://raw.githubusercontent.com/satishdotpatel/rrdgraph/master/sample-graph/mem.png "Memory Graph")

## Network

![Alt text](https://raw.githubusercontent.com/satishdotpatel/rrdgraph/master/sample-graph/network.png "Network Graph")

## Process Memory

![Alt text](https://raw.githubusercontent.com/satishdotpatel/rrdgraph/master/sample-graph/pmem.png "Process memory Graph")


