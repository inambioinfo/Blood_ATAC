
#Concat vcf files
zcat new_header.txt.gz chr1.gz chr10.gz chr11.gz chr12.gz chr13.gz chr14.gz chr15.gz chr16.gz chr17.gz chr18.gz chr19.gz chr2.gz chr20.gz chr21.gz chr22.gz chr3.gz chr4.gz chr5.gz chr6.gz chr7.gz chr8.gz chr9.gz | bgzip > CTCF_51_samples.GRCh37.vcf.gz

#Update GT and DS fields in the header
reheader -h new_header.txt CTCF_51_samples.GRCh37.vcf.gz > CTCF_51_samples.GRCh37.reheadered.vcf.gz

#Run Snakemake
snakemake --cluster ../../scripts/snakemake_submit_UT.py -np --snakefile process_genotypes.snakefile


snakemake --cluster ../../scripts/snakemake_submit_UT.py -np --snakefile process_genotypes.snakefile CTCF/genotypes/vcf/GRCh38/CTCF_51_samples.GRCh38.common.sorted.vcf.gz --jobs 1


#Keep only common SNPs
bcftools filter -i 'MAF[0] >= 0.05' -O z CTCF_51_samples.GRCh38.vcf.gz > CTCF_51_samples.GRCh38.common.vcf.gz

#Keep only SNPs with correct REF allele
bcftools norm -c x -O z -f ../../../../../annotations/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa CTCF_51_samples.GRCh38.common.sorted.vcf.gz > correct_ref.vcf.gz

#Keep only bi-allelic and add missing names if necessary
bcftools norm -m+any correct_ref.vcf.gz | bcftools view -m2 -M2 - | bcftools annotate -O z --set-id +'%CHROM\_%POS' > CTCF_51_samples.GRCh38.common.sorted.norm.vcf.gz

#Remove any remaining duplicates
bcftools norm -d both -O z CTCF_51_samples.GRCh38.common.sorted.norm.vcf.gz > CTCF_51_samples.GRCh38.common.sorted.norm.dedup.vcf.gz



#### PU.1 dataset ####
zcat full_header45.txt.gz chr1.gz chr11.gz chr12.gz chr13.gz chr14.gz chr15.gz chr16.gz chr17.gz chr18.gz chr19.gz chr2.gz chr20.gz chr21.gz chr22.gz | bgzip > PU1_45_samples.GRCh37.vcf.gz
