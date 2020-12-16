#!/bin/bash
cd ~
tar czf packet_archive.tar.gz packet_archive
aws s3 cp packet_archive.tar.gz s3://aseemsdb-packet-archive
tar czf recollconf.tar.gz recollconf
aws s3 cp recollconf.tar.gz s3://aseemsdb-packet-archive
rm packet_archive.tar.gz recollconf.tar.gz
