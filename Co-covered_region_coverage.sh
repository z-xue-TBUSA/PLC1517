#!/bin/bash

# Use GNU Parallel to process BAM files in parallel
parallel --jobs 8 'bam={}; \
  base=$(basename "$bam" .bam); \
  bedtools genomecov -ibam "$bam" -bga > "${base}.bedgraph"; \
  awk '\''$4 > 0 {print $1 "\t" $2 "\t" $3}'\'' "${base}.bedgraph" > "${base}_covered.bed"; \
  rm "${base}.bedgraph"' \
  ::: /wgbs/scratch/zxue/1517-54/other_outputs/*360M.bam



# need to run dos2unix Co-covered_region_coverage.sh in rosalind to covert file fomat to run

# run following in command line for specific intra and inter conditions 
bedtools multiinter -i Lib146-1-360M_covered.bed Lib147-1-360M_covered.bed -header > PPv3_360M_intra.bed
# Replace "N" with the number of BAM files
awk -v N=2 '$4 == 2 {print $1 "\t" $2 "\t" $3}' PPv3_360M_intra.bed > PPv3_360M_intra_co.bed
awk '{sum += $3 - $2} END {print sum}' PPv3_360M_intra_co.bed
rm PPv3_360M_intra.bed


cut -f1,2 /wgbs/scratch/zxue/tools/GRCh38_genome.fa.fai > genome.txt


bedtools genomecov -i GTK10N3_intra_co.bed -g genome.txt | awk '$2 == 1 {printf "%s\t%s\t%.0f%%\n", $1, $2, $5*100}' 