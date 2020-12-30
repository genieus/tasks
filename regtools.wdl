version 1.0

task junctions_extract {
  input {
      File bamfile
      File bamindex
      Int anchor = 8
      Int minI = 70 # minimum intron length
      Int maxI = 500000 # maximum intron length
      String? region
      Int strand = 0 # 0 = unstranded/XS, 1 = first-strand/RF, 2 = second-strand/FR
      String? tag
  }

  command {
    regtools junctions extract \
    -a ~{anchor} \
    -m ~{minI} \
    -M ~{maxI} \
    ~{"-r " + region} \
    -s ~{strand} \
    ~{"-t " + tag} \
    ~{bamfile} \
    -o ~{bamfile}.junc
  }

  output {
      File junc_file = "~{bamfile}.junc"
  }

  runtime {
      docker: "griffithlab/regtools"
  }
}
