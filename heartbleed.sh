#!/bin/bash
# (c) 2014 Tim Völpel
# h34r7bl33d.sh - Script for checking the HEARTBLEED vulnerability (CVE 2014-0160)
PROGNAME=$(basename $0)

# Print Help
print_help() {
echo " "
echo "Example: ./$PROGNAME portal.she.net 443"
echo " "
}

# Check Parameter
check_parameter() {

if [ -z "$1" ]; then
echo "IP address or hostname is missing!"
exit 0
fi

if [[ ! $2 =~ ^[0-9]+$ ]] || [ $2 -eq 0 ] || [ $2 -gt 65535 ] ; then
echo "The port has to be a number from 1 to 65535"
exit 0
fi

OPENSSL=$(which openssl)
if [ "$OPENSSL" == "" ]; then
echo "openssl library is missing!"
echo ""
exit 0
fi

}

# Check vulnerability
check_heartbleed() {

CHK=$(echo "quit" | openssl s_client -connect $1:$2  -tlsextdebug 2>&1| grep 'server extension "heartbeat" (id=15)' >/dev/null)

if [ -z "$CHK" ]; then
echo "OK - $1:$2 is not vulnerable to HEARTBLEED"
else
echo "ATTENTION - $1:$2 is vulnerable to HEARTBLEED"
fi

}

case "$1" in
--help|-h)
print_help
exit 3;;
*)
;;
esac

# Check parameter
check_parameter $1 $2

# Check the host on the vulnerability
check_heartbleed $1 $2

