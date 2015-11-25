#!/bin/bash

home_path=`echo ~`
synfig_path=$home_path/synfig/bin
script_path=$PWD
results_path="$script_path/../results/rendering"

test() {
	engine=$1
	test_name=$2
	test_script_path="$script_path/$test_name"
	test_results_path=$results_path/$test_name/$engine
	test_blank_path=$test_results_path/blank

	echo -n "$engine $test_name... "

	rm -r -f $test_results_path
	mkdir -p $test_blank_path
	cp $test_script_path/* $test_results_path &>/dev/null 
	cp $test_script_path/common/* $test_blank_path &>/dev/null
	cp $test_script_path/$engine/* $test_blank_path &>/dev/null
	cd $test_results_path
	
	PATH="$PATH:$synfig_path" \
		SYNFIG_TARGET_DEFAULT_ENGINE=$engine \
		SYNFIG_RENDERING_THREADS=1 \
		SYNFIG_RENDERING_DEBUG_TASK_LIST_LOG=task_list.log \
		SYNFIG_RENDERING_DEBUG_TASK_LIST_OPTIMIZED_LOG=optimized_task_list.log \
		SYNFIG_RENDERING_DEBUG_RESULT_IMAGE=result.tga \
		./run.sh
	error=$?
	
	if [ "${error}" -eq 0 ]
	then
		echo "success"
	else
		echo "FAILED!!!"
	fi
	
	cd $script_path
}

tests() {
	test $1 01_simple
	test $1 02_compisite_layers
	test $1 03_compisite_group
}

tests software
tests gl
