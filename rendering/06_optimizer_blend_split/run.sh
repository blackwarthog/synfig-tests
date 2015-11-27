error=0

synfig -t null --begin-time 0f --end-time 0f test.sif &>output.log
let "error|=$?"

cmp -s result.tga blank/result.tga
let "error|=$?"

cmp -s task_list.log blank/task_list.log
let "error|=$?"

cmp -s optimized_task_list.log blank/optimized_task_list.log
let "error|=$?"
 
exit $error
