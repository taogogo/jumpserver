#!/bin/bash
username=$1
password=$2

cwd (){
    dir=$0
    dirname $dir
}

dir=$(cwd)
. ${dir}/shell.conf


sudo_file=${dir}/sudo.ldif
user_sudo_file=${dir}/${username}.ldif

if [ -z $1 ];then
    echo 
    echo "usage: ./sudoadd.sh username "
    echo
    exit 3
fi

id ${username} &> /dev/null
if [ $? != '0' ];then
    echo "$username is not exit!"
    exit 3
fi

sed -i "/guanghongwei/ s@dianping@$domain@g" ${sudo_file}
sed -i "/guanghongwei/ s@com@$suffix@g" ${sudo_file}
sed -e "s@guanghongwei@$username@g" ${sudo_file} > $user_sudo_file


ldapadd -x -h ${host} -w ${ldapassword} -D "cn=admin,dc=$domain,dc=$suffix" -f $user_sudo_file
rm -f $user_sudo_file