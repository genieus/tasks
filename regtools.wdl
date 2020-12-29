version 1.0

task junctions_extract {
  input {
      File bamfile
      File bamindex
      Int anchor
      Int minI # minimum intron length
      Int maxI # maximum intron length
  }

  command {
    regtools junctions extract -a ~{anchor} -m ~{minI} -M ~{maxI} ~{bamfile} -o ~{bamfile}.junc
  }

  output {
      File junc_file = "~{bamfile}.junc"
  }

  runtime {
      docker: "griffithlab/regtools"
  }
}
