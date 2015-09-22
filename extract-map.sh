#!/bin/bash

ENGINE=$1

maps=("49" "50" "50")
qs=("701-750" "751-800" "801-850")
j=0
r=1

while [ $j -lt ${#maps[@]} ]
do
	q=${qs[$j]}
	m=${maps[$j]}

	case "$ENGINE" in
		ATIRE)
			for i in "index" "quantized"
			do
				if [ ! -f atire.${i}.map ]; then
					echo atire.${i} > atire.${i}.map
				fi
				grep -m ${m} "^map" ATIRE/eval.dg2_${i}.aspt.${q}.${r}.txt | cut -f3  >> atire.${i}.map
			done
			;;
		JASS)
			for i in "comp" "heur"
			do
				if [ ! -f jass.${i}.map ]; then
					echo jass.${i} > jass.${i}.map
				fi
				grep -m ${m} "^map" JASS/${i}.eval.${q}.${r}.txt | cut -f3 >> jass.${i}.map
			done
			;;
		MG4J)
			for i in "bm25" "mb" "mb+"
			do
				if [ ! -f mg4j.${i}.map ]; then
					echo mg4j.${i} > mg4j.${i}.map
				fi
				grep -m ${m} "^map" MG4J/dg2.${i}.eval.${r}.${q}.txt | cut -f3 >> mg4j.${i}.map
			done
			;;
		galago)
			# combine -- QL
			for i in "combine" "sdm"
			do
				if [ ! -f galago.${i}.map ]; then
					echo galago.${i} > galago.${i}.map
				fi
				grep -m ${m} "^map" galago/galago.${r}.${q}.${i}.treceval | cut -f3 >> galago.${i}.map
			done
			;;
		indri)
			# BOW -- QL
			for i in "bow" "sdm"
			do
				if [ ! -f indri.${i}.map ]; then
					echo indri.${i} > indri.${i}.map
				fi
				grep -m ${m} "^map" indri/scores/trec-eval_${i}_queries_${q}_${r} | cut -f3 >> indri.${i}.map
			done
			;;
		lucene)
			for i in "pos" "cnt"
			do
				if [ ! -f lucene.${i}.map ]; then
					echo lucene.${i} > lucene.${i}.map
				fi
				grep -m ${m} "^map" lucene/submission_${q}_${i}_${r}.eval | cut -f3 >> lucene.${i}.map
			done
			;;
		terrier)
			for i in "DPH_Prox" "DPH_QE" "BM25" "DPH"
			do
				if [ ! -f terrier.${i}.map ]; then
					echo terrier.${i} > terrier.${i}.map
				fi
				grep -m ${m} "^map" terrier/*.${i}.${r}.${q}.search_stats.txt | cut -f3 >> terrier.${i}.map
			done
			;;
	esac
	j=$((j+1))
done
