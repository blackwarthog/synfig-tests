error=0

synfig -t null --begin-time 0f --end-time 0f test.sif &>output.log

if [ "$?" -ne 0 ]
then
	echo -n "[call] "
	error=1
fi

compare()
{
	cmp -s $1 blank/$1
	if [ "$?" -ne 0 ]
	then
		echo -n "[$1] "
		error=1
	fi
}

for file in blank/*
do
    if [ -f $file ] 
    then
    	compare "${file##*/}"
    fi
done
 
exit $error
