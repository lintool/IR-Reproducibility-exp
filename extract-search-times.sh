#!/bin/bash

ENGINE=$1

echo $ENGINE
echo

for q in "701-750" "751-800" "801-850"
do
	echo ${q}:
	case "$ENGINE" in
		ATIRE)
			for i in "index" "quantized"
			do
				echo -n ${i} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						grep -m50 "Total Time to Search" ATIRE/dg2_${i}.aspt.${q}.search_stats.${r}.txt | cut -d":" -f2 | cut -d" " -f1
					done
				)
			done
			;;
		JASS)
			for i in "comp" "heur"
			do
				echo -n ${i} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						# JASS reports ns, so conver to ms by getting bc to do the dividing
						tail -n50 JASS/${i}..${q}.${r}.search_stats.txt | cut -d"," -f5 | awk '{printf "%s/1000000\n",$0}' | bc
					done
				)
			done
			;;
		MG4J)
			for m in "bm25" "mb" "mb+"
			do
				echo -n ${m} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						grep -m50 "ms" MG4J/dg2.${m}.err.${r}.${q}.txt | cut -d";" -f3 | cut -d" " -f2
					done
				)
			done
			;;
		galago)
			# combine -- QL
			for m in "combine" "sdm"
			do
				echo -n ${m} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						head -n50 galago/galago.${r}.${q}.${m}.trecrun.times | cut -f3
					done
				)
			done
			;;
		indri)
			# BOW -- QL
			for m in "BOW" "SDM"
			do
				echo -n ${m} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						sed -n "/${m} ${q}/{n;p;}" indri/results | cut -d" " -f6 | awk '{for(i=0;i<50;i++)printf "%s*1000/50\n", $0}' | bc
					done
				)
			done
			;;
		lucene)
			for i in "pos" "cnt"
			do
				echo -n ${i} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						grep -m 50 "Search Seconds" lucene/submission_${q}_${i}_${r}.log | cut -d":" -f2 | awk '{printf "%s*1000\n", $0}' | bc
					done
				)
			done
			;;
		terrier)
			for i in "DPH_Prox" "DPH_QE" "BM25" "DPH"
			do
				echo -n ${i} "-- "
				awk '{s+=$1}END{print s/NR}' <(
					for r in 1 2 3
					do
						grep -m 50 "Time to process query" terrier/*.${i}.${r}.${q}.search_stats.txt | cut -d":" -f2 | awk '{printf "%s*1000\n", $0}' | bc
					done
				)
			done
			;;
	esac
	echo
done
