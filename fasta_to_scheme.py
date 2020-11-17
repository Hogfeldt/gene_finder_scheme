from glob import glob
from itertools import cycle

def translate_observations_to_indices(obs):
    mapping = {"a": '0', "c": '1', "g": '2', "t": '3'}
    return ''.join([mapping[symbol.lower()] for symbol in obs])

def anno_to_indecies(z):
    res = ''
    c = cycle("210")
    r = cycle("456")
    for s in z:
        if s == "N":
            res += '3'
        elif s == "C":
            res += next(c)
        elif s == "R":
            res += next(r)
    return res

def read_fasta_file(filename):
    """
    Reads the given FASTA file f and returns a dictionary of sequences.

    Lines starting with ';' in the FASTA file are ignored.
    """
    sequences_lines = {}
    current_sequence_lines = None
    with open(filename) as fp:
        for line in fp:
            line = line.strip()
            if line.startswith(";") or not line:
                continue
            if line.startswith(">"):
                sequence_name = line.lstrip(">")
                current_sequence_lines = []
                sequences_lines[sequence_name] = current_sequence_lines
            else:
                if current_sequence_lines is not None:
                    current_sequence_lines.append(line)
    sequences = {}
    for name, lines in sequences_lines.items():
        sequences[name] = "".join(lines)
    return sequences

def schemefy(input_file, output_file):
    fasta_name = input_file.split('/')[-1].replace('.fa', '')
    seqs = read_fasta_file(input_file)
    if "ann" in fasta_name:
        conv_func = anno_to_indecies
    else:
        conv_func = translate_observations_to_indices
    with open(output_file, 'w') as fp:
        seq = " ".join(conv_func(seqs[fasta_name]))
        fp.write(f"(define {fasta_name} '({seq}))\n")
    

if __name__=='__main__':
    files = glob("data/*.fa")
    for f in files:
        output = f.replace('.fa', '.scm')
        schemefy(f, output)
