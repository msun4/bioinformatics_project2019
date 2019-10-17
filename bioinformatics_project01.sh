# collating all mcrA genes into one file, alignment of the sequences and building an hmm profile 
cat ./ref_sequences/mcrAgene_*.fasta >> mcrAgene_all.fasta
~/Private/muscle -in mcrAgene_all.fasta -out mcrAgene_aligned.fasta
~/Private/hmmer-3.2.1/bin/hmmbuild mcrAbuild_out mcrAgene_aligned.fasta

# collating all hsp70 genes into one file, alignment of the sequences and building an hmm profile
cat ./ref_sequences/hsp70gene_*.fasta >> hsp70_all.fasta
~/Private/muscle -in hsp70_all.fasta -out hsp70alignment.fasta
~/Private/hmmer-3.2.1/bin/hmmbuild hsp70build_out hsp70alignment.fasta

#run the proteome files through the hmmbuild profiles of both mcrA genes and hsp70 genes
echo "proteome mcrA_gene hsp70_genes" > search_summary.csv
for file in proteome_*.fasta
do
a=$(echo $file)
b=$(~/Private/hmmer-3.2.1/bin/hmmsearch ~/Private/bioinformatics_project2019/ref_sequences/mcrA.hmm $file | grep ">>" | wc -l)
c=$(~/Private/hmmer-3.2.1/bin/hmmsearch ~/Private/bioinformatics_project2019/ref_sequences/hsp70.hmm $file | grep ">>" | wc -l)
echo "$a $b $c" >> search_summary.csv
done

#text file with the names of the candidate pH-resistant methanogens
cat search_summary.csv | grep -v " 0 " | cut -d " " -f 1 > candidates.txt
