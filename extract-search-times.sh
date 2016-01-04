#!/bin/bash

ENGINE=$1

for q in "701-750" "751-800" "801-850"
do
	# echo ${q}:
	case "$ENGINE" in
		ATIRE)
			for i in "index" "quantized"
			do
				for r in 1 2 3
				do
					grep -m50 "Total Time to Search" ATIRE/final/dg2_${i}.aspt.${r}.${q}.search_stats.txt | cut -d":" -f2 | cut -d" " -f1 | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${i} ${q} /"
				done
			done
			;;
		JASS)
			for i in "comp" "heur"
			do
				for r in 1 2 3
				do
					# JASS reports ns, so conver to ms by getting bc to do the dividing
					tail -n50 JASS/final/${i}..${r}.${q}.search_stats.txt | cut -d"," -f5 | awk '{printf "%s/1000000\n",$0}' | bc | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${i} ${q} /"
				done
			done
			;;
		MG4J)
			for m in "bm25" "modelb" "modelbp"
			do
				for r in 1 2 3
				do
					grep -m50 "ms" MG4J/final/${m}.err.${r}.${q}.txt | cut -d";" -f3 | cut -d" " -f2 | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${m} ${q} /"
				done
			done
			;;
		galago)
			# combine -- QL
			for m in "combine" "sdm"
			do
				for r in 1 2 3
				do
					head -n50 galago/final/galago.${r}.${q}.${m}.trecrun.times | cut -f3 | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${m} ${q} /"
				done
			done
			;;
		indri)
			# BOW -- QL
			for m in "bow" "sdm"
			do
				for r in 1 2 3
				do
					cat indri/final/query_times_${m}_${q}_${r} | cut -d":" -f2 | head -n 50 | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${m} ${q} /"
				done
			done
			;;
		lucene)
			for i in "pos" "cnt"
			do
				for r in 1 2 3
				do
					grep -m 50 "Search Seconds" lucene/final/submission_${r}_${q}_${i}.log | cut -d":" -f2 | awk '{printf "%s*1000\n", $0}' | bc | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${i} ${q} /"
				done
			done
			;;
		terrier)
			for i in "DPH_Prox" "DPH_QE" "BM25" "DPH"
			do
				for r in 1 2 3
				do
					grep -m 50 "Time to process query" terrier/final/*.${i}.${r}.${q}.search_stats.txt | cut -d":" -f2 | awk '{printf "%s*1000\n", $0}' | bc | nl -v `echo ${q} | cut -d'-' -f1` | sed -e "s/^/${ENGINE} ${i} ${q} /"
				done
			done
			;;
	esac
done
