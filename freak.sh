#!/bin/bash 
# (c) 2015 Tim Völpel 
# fr34k.sh - Script for checking the FREAK vulnerability (CVE 2015-0204)
PROGNAME=$(basename $0)
TIMEOUT=10

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
check_freak() {

  CHK=$( $OPENSSL s_client -connect $1:$2 -cipher EXPORT < /dev/null 2>/dev/null & sleep $TIMEOUT; kill $! 2>/dev/null )
  
  # Empty? Timeout!
  if [ "$CHK" == "" ]; then
    echo "UNKNOWN - Timeout connecting to $1:$2"
    exit 0
  fi
  
  # Exported CIPHER
  echo $CHK | grep "Cipher is EXP" > /dev/null
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
check_freak $1 $2
 
# Print output
if [ $? -eq 1 ]; then
  echo "OK - $1:$2 is not vulnerable to FREAK"
  exit 0
else
  echo "ATTENTION - $1:$2 is vulnerable to FREAK"
  exit 2
fi
