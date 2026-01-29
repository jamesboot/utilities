# Script for lifting over gtf annotations from wuhCor1 to OC43

# Load module
ml Kent_tools/20190117-linux.x86_64

# Set variables
PROJDIR=/nemo/stp/babs/working/bootj/projects/bauerd/catarina.nunes/oc43_splicing
REF=${PROJDIR}/data/external/sars-cov2
ID1=NC_045512.2
ID2=oc43atcc
DIR1=${REF}/${ID1}
DIR2=${REF}/${ID2}
GTF1=${DIR1}/NC_045512.2.sgRNA_canonical.gtf

# Run liftover
faToTwoBit ${DIR1}/${ID1}.fa ${DIR1}/${ID1}.2bit
twoBitInfo ${DIR1}/${ID1}.2bit stdout | sort -k2,2nr > ${DIR1}/${ID1}.2bit.chrom.sizes
faToTwoBit ${DIR2}/${ID2}.fa ${DIR2}/${ID2}.2bit
twoBitInfo ${DIR2}/${ID2}.2bit stdout | sort -k2,2nr > ${DIR2}/${ID2}.2bit.chrom.sizes
blat ${DIR1}/${ID1}.2bit ${DIR2}/${ID2}.fa ${DIR2}/${ID1}.to.${ID2}.psl -tileSize=12 -minScore=100 -minIdentity=98
axtChain -linearGap=medium -psl ${DIR2}/${ID1}.to.${ID2}.psl ${DIR1}/${ID1}.2bit ${DIR2}/${ID2}.2bit ${DIR2}/${ID1}.to.${ID2}.chain
liftOver -gff ${GTF1} ${DIR2}/${ID1}.to.${ID2}.chain ${DIR2}/${ID1}.to.${ID2}.gtf ${DIR2}/${ID1}.to.${ID2}.unmapped
