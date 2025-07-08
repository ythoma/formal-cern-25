
current_dir=$(pwd)
> $current_dir/error.log

log_on_failure() {
    # Combine all arguments into a single command string
    local cmd="$*"
    
    # Execute the command
    eval "$cmd"
    local status=$?
    
    # If the command failed, log it
    if [ $status -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - In folder $(pwd), Command failed with status $status: $cmd" >> $current_dir/error.log
    fi
    
    return $status
}


for sby_path in $(find . -iname "*.sby" ! -iname "*config.sby" ! -iname "fifo_anyconst_test_solvers.sby"); do 
                    sby_script=${sby_path##*/}
                    cd ${sby_path%/*}
                    log_on_failure "sby --prefix verif_out/ --yosys \"yosys -m ghdl\" -f $sby_script"
                    cd -
                done

