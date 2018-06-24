MOP_FILES="$1" # input MOP files
OUTPUT_NAME=$2 # name of MOP agent jar file
TEMP_DIR='temp_JavaMOP'
EXCLUDE='n'	# by default include jars
 
while getopts ":e" opt; do
 	case $opt in
		e) EXCLUDE='y'
		echo "-e was triggered!" >&2
		;;
		\?)
		echo "Invalid option: -$OPTARG" >&2
		;;
	esac
done

eval "mkdir -p $TEMP_DIR/mop"

RVM_FILES="${MOP_FILES//mop/rvm}"

eval "javamop -merge '$MOP_FILES' -d $TEMP_DIR/"
eval "rv-monitor -merge -d $TEMP_DIR/mop/ $RVM_FILES"
eval "javac $TEMP_DIR/mop/MultiSpec_1RuntimeMonitor.java"

if [ $EXCLUDE = 'n' ]; then
	$EXCLUDE_OPT='' # jars will not be excluded
else
	$EXCLUDE_OPT='-excludeJars'
fi

eval "javamopagent $TEMP_DIR/MultiSpec_1MonitorAspect.aj $TEMP_DIR -n $OUTPUT_NAME $EXCLUDE_OPT"
eval "rm -r $TEMP_DIR"


