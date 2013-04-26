email=aravind.gv@gmail.com

#Server  Month and Day to compare to epoch month and day
moday=`date |awk '{print $2 $3}'`
epoch=`cat /var/lib/puppet/state/last_run_summary.yaml|grep last_run | awk '{print $2}'`

#this line converts raw epoch to Month Day format
epoch1=`date -d@$epoch||awk '{print $2 $3}'`
#echo $epoch1

#The file /var/lib/puppet/state/last_run_summary.yaml is a puppet builtin that shows the last puppet run on a node
#This results in Month and Day from the file /var/lib/puppet/state/last_run_summary.yaml|grep last_run | awk '{print $2}'
epoch2=`echo $epoch1 |awk '{print $2 $3}'`
#echo $epoch2

if  [[  $moday =  $epoch2  ]]
then
echo `date`  >> /tmp/puppetrun
echo "Puppet has run successfully"  >> /tmp/puppetrun
else
echo "Puppet has not run" >> /tmp/puppetrun
fi

success=`cat /tmp/puppetrun |grep successfully | wc -l`
echo $success
failures=`cat /tmp/puppetrun |grep not | wc -l`
echo $failures

if [ $failures -gt 9 ];
#if [ $failures -gt 9 ]];
then
echo "greater than 5"
mailx -s "`hostname` Puppet Failure" $email <  /tmp/puppetrun
echo > /tmp/puppetrun
else
echo "not greater than 5"
fi

