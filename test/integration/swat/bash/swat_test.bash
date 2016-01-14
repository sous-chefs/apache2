yum install perl-Test-Harness git -y -q

which cpanm 1>/dev/null || curl -k -L http://cpanmin.us/ -o /usr/bin/cpanm

chmod +x /usr/bin/cpanm

which cpanm 1>/dev/null || exit 1

export PATH=$PATH:/usr/local/bin/

cpanm Sparrow || exit 1

which sparrow 1>/dev/null || exit 1

# sparrow plg remove swat-apache2-cookbook
echo 'swat-apache2-cookbook https://github.com/melezhik/swat-apache2-cookbook.git' > ~/sparrow.list

sparrow index update

sparrow plg install private@swat-apache2-cookbook

sparrow project create foo

sparrow check add foo apache

sparrow check set foo apache -p private@swat-apache2-cookbook -u `hostname -f`

landing_page_line='Hello World' \
match_l=300 \
sparrow check run foo apache

st=$?

# find /root/.swat/.cache/ -type f -exec tail -n +1 {} \;

exit $st

     

