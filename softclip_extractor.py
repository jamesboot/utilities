#!/usr/bin/env python3

import pysam
import sys
import os

def extract_softclips(bamfile, outdir, min_clip_len=1):
    # Ensure output directory exists
    os.makedirs(outdir, exist_ok=True)

    # Output file paths
    fq_left_path  = os.path.join(outdir, "left_softclips.fastq")
    fq_right_path = os.path.join(outdir, "right_softclips.fastq")
    fa_left_path  = os.path.join(outdir, "left_softclips.fasta")
    fa_right_path = os.path.join(outdir, "right_softclips.fasta")
    tab_path      = os.path.join(outdir, "softclips.tsv")

    fq_left  = open(fq_left_path, "w")
    fq_right = open(fq_right_path, "w")
    fa_left  = open(fa_left_path, "w")
    fa_right = open(fa_right_path, "w")
    tab      = open(tab_path, "w")

    tab.write("ReadName\tLeftClip\tAligned\tRightClip\n")

    bam = pysam.AlignmentFile(bamfile, "rb")

    for read in bam:
        if read.is_unmapped:
            continue

        seq = read.query_sequence
        qual = read.qual

        left_clip = ""
        right_clip = ""
        aligned_seq = seq
        left_clip_qual = ""
        right_clip_qual = ""

        cigartuples = read.cigartuples  # (operation, length)

        if cigartuples:
            # Left soft clip
            if cigartuples[0][0] == 4:
                l = cigartuples[0][1]
                if l >= min_clip_len:
                    left_clip = seq[:l]
                    left_clip_qual = qual[:l]
                aligned_seq = seq[l:]
                qual = qual[l:]

            # Right soft clip
            if cigartuples[-1][0] == 4:
                l = cigartuples[-1][1]
                if l >= min_clip_len:
                    right_clip = seq[-l:]
                    right_clip_qual = qual[-l:]
                aligned_seq = aligned_seq[:-l]
                qual = qual[:-l]

        # Write to separate FASTQ/FASTA files
        if left_clip:
            fq_left.write(f"@{read.query_name}_Lclip\n{left_clip}\n+\n{left_clip_qual}\n")
            fa_left.write(f">{read.query_name}_Lclip\n{left_clip}\n")
        if right_clip:
            fq_right.write(f"@{read.query_name}_Rclip\n{right_clip}\n+\n{right_clip_qual}\n")
            fa_right.write(f">{read.query_name}_Rclip\n{right_clip}\n")

        # Write to table
        tab.write(f"{read.query_name}\t{left_clip}\t{aligned_seq}\t{right_clip}\n")

    fq_left.close()
    fq_right.close()
    fa_left.close()
    fa_right.close()
    tab.close()
    bam.close()


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(f"Usage: {sys.argv[0]} <input.bam> <output_dir> <min_clip_len>")
        sys.exit(1)

    bamfile = sys.argv[1]
    outdir = sys.argv[2]
    min_clip_len = int(sys.argv[3])

    extract_softclips(bamfile, outdir, min_clip_len)
