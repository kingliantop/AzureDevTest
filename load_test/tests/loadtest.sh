#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Test Parameters
SERVER="http://web/"
TIP_FILE="$SCRIPTDIR/load_test_in_progress"
OUT_FILE="$SCRIPTDIR/benchmark.tsv"
AB_RESULTS_FILE="$SCRIPTDIR/ab_results.txt"
TST_RESULTS_FILE="$SCRIPTDIR/test_results.txt"

# Result parsing parameters
ENTRY_COUNT=-1
MIN=50
LIMIT=200
ENTRIES_OVER_LIMIT=0
MAX_ENTRIES_OVER_LIMIT_PERCENT=1

touch $TIP_FILE

# Run the benchmark
echo "Running Apache Benchmark"
# NOTE: the time for benchmarking here is artificially low, this is to ensure that demo's don't take too long
ab -c 5 -t 15 -g $OUT_FILE $SERVER | tee $AB_RESULTS_FILE

# Generate results file
echo "Generating results file"
while IFS='	' read c1 c2 c3 c4 c5
do
	if [ $((++ENTRY_COUNT)) -lt 1 ] || [ $c4 -lt $MIN ]; then
		continue
	fi

	if [ $c4 -ge $LIMIT ]; then
		ENTRIES_OVER_LIMIT=$((++ENTRIES_OVER_LIMIT))
	fi
done < $OUT_FILE

if [ $((ENTRIES_OVER_LIMIT*100/ENTRY_COUNT)) -gt $MAX_ENTRIES_OVER_LIMIT_PERCENT ]; then
	echo "${ENTRIES_OVER_LIMIT}/${ENTRY_COUNT} requests ($((ENTRIES_OVER_LIMIT*100/ENTRY_COUNT))%) were over the limit of ${LIMIT}ms. The load test was a failure." > $TST_RESULTS_FILE
	RESULT=1
else
	echo "${ENTRIES_OVER_LIMIT}/${ENTRY_COUNT} requests were over the limit of ${LIMIT}ms. The load test was a success." > $TST_RESULTS_FILE
	RESULT=0
fi

echo "Results written to file: $TST_RESULTS_FILE"
cat $TST_RESULTS_FILE

rm $TIP_FILE

exit $RESULT
