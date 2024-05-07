#!/bin/bash

# envoked by: % bash query_timer.sh label num_reps query db_file csv_file

#Arguments from above:
     #label:    explanatory label that will be output
      #num_reps: number of repetitions
      #query:    SQL query to run
      #db_file:  database file
     # csv_file: CSV file to create or append to
    
# inputs 
label="$1"
num_reps="$2"
query="$3"
db_file="$4"
csv_file="$5"

# record a start time
start_time=$(date +%s)

# iterate through the number of reps
for i in $(seq $num_reps); do
    duckdb "$db_file" -c "$query"
done

# record end time
end_time=$(date +%s)

# calculate the total time
elapsed=$((end_time - start_time))

# use -l to get more decimal places
rep_time=$(bc -l <<< "$elapsed/$num_reps")

# output the lavel and elapsed time
echo "$label","$rep_time" >> "$csv_file"
