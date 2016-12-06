PATH=$PATH:/usr/local/bin/

which sparrow 1>/dev/null || exit 1

sparrow project create foo

sparrow check add foo apache

sparrow check set foo apache swat-apache2-cookbook `hostname -f`

landing_page_line='Hello World' \
match_l=300 \
sparrow check run foo apache

st=$?

# find /root/.swat/.cache/ -type f -exec tail -n +1 {} \;

exit $st

     

