#!/bin/bash

# Create necessary directories if they don't exist
mkdir -p ucdb coverage_report

# Compile SystemVerilog files
vlog -sv -mfcu -f ./filelist.f

# Check if a test name is provided
if [ -n "$1" ]; then
    tests=("$1")
else
    tests=("run_test" "op_test" "il_test")
fi

if [ -n "$2" ]; then
    verb=("$2")
else 
    verb=1
fi

# Set transcript file to persist logs
transcript_file="coverage_report/transcript.log"
echo "Saving transcript to $transcript_file"
echo "" > "$transcript_file"  # Clear log at start

# Run simulations with the specified test(s)
for test in "${tests[@]}"
do
    ucdb_file="ucdb/ucdb_${test}.ucdb"
    echo "Running test: $test"
    vsim -voptargs="+acc" -c work.testbench -do "log -r /*; coverage save -onexit $ucdb_file; run -all; quit" +VERBOSITY=$verb +TEST="$test" | tee -a "$transcript_file"
done

# Merge coverage files
vcover merge -64 coverage_report/merge_ucdb.ucdb ucdb/*.ucdb

# Generate coverage report
vsim -c -viewcov coverage_report/merge_ucdb.ucdb -do "coverage report -file coverage_report/coverage_report_final.txt -byfile -detail -noannotate -option -cvg; quit" | tee -a "$transcript_file"
