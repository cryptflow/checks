#!/bin/bash
# (c) 2014 Tim Völpel
# p00dl3.sh - Script for checking the POODLE vulnerability (CVE 2014-3566)
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
check_poodle() {

CHK=$( (echo 'x' | $OPENSSL s_client -connect $1:$2 -quiet -ssl3 2> /dev/null) )

if [ -z "$CHK" ]; then
echo "OK - $1:$2 is not vulnerable to POODLE"
else
echo "ATTENTION - $1:$2 is vulnerable to POODLE"
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
check_poodle $1 $2

