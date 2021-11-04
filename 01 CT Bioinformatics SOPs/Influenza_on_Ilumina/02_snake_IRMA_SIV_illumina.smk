import glob,os

DATADIR="irmaOut_SIV/"

rule main:
    input: [f"{DATADIR}/merged/{os.path.basename(d)}.fasta" for d in glob.glob(f"{DATADIR}/*")]

rule merge:
    input:
        lambda wc: sorted([f for f in glob.glob(f"{DATADIR}/{wc.d}/*.fasta")])
    output:
        f"{DATADIR}/merged/{{d}}.fasta"
    shell:"""
        cat {input} > {output}
    """
