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
	cp $script_path/common/*       $test_results_path &>/dev/null 
	cp $test_script_path/*         $test_results_path &>/dev/null 
	cp $test_script_path/common/*  $test_blank_path &>/dev/null
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
	test $1 02_composite_layers
	test $1 03_composite_group
	test $1 04_optimizer_blend_zero
	test $1 05_optimizer_blend_composite
	test $1 06_optimizer_blend_split
	test $1 07_optimizer_blend_composite_advanced
	test $1 08_blend_methods
	test $1 09_snowman
	test $1 10_rapper
	test $1 11_rapper_without_shadows
	test $1 12_rapper_x8
	test $1 13_translate_rotate_scale
	test $1 14_images
	test $1 15_images_heavy
	test $1 16_old_layers
}

tests software
#tests gl
tests safe

echo "done."
