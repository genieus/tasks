version 1.0

# Copyright (c) 2018 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


task Phase {
    input {
        String outputVCF
        File? reference
        File? referenceIndex
        Boolean? no_reference
        String? tag
        File? output_read_list
        String? algorithm
        Boolean? merge_reads
        String? internal_downsampling
        String? mapping_quality
        Boolean? indels
        Boolean? ignore_read_groups
        String? sample
        String? chromosome
        String? error_rate
        String? maximum_error_rate
        String? threshold
        String? negative_threshold
        Boolean? full_genotyping
        Boolean? distrust_genotypes
        Boolean? include_homozygous
        String? default_gq
        String? gl_regularize_r
        File? changed_genotype_list
        String? ped
        File? recombination_list
        String? recomb_rate
        File? gen_map
        Boolean? no_genetic_haplo_typing
        Boolean? use_ped_samples
        File vcf
        File vcfIndex
        File phaseInput
        File phaseInputIndex

        String memory = "4G"
        Int timeMinutes = 120
        String dockerImage = "quay.io/biocontainers/whatshap:1.0--py37h9a982cc_1"
    }
    command {
        whatshap phase \
        ~{vcf} \
        ~{phaseInput} \
        ~{if defined(outputVCF) then ("--output " +  '"' + outputVCF + '"') else ""} \
        ~{if defined(reference) then ("--reference " +  '"' + reference + '"') else ""} \
        ~{true="--no-reference" false="" no_reference} \
        ~{if defined(tag) then ("--tag " +  '"' + tag + '"') else ""} \
        ~{if defined(output_read_list) then ("--output-read-list " +  '"' + output_read_list + '"') else ""} \
        ~{if defined(algorithm) then ("--algorithm " +  '"' + algorithm + '"') else ""} \
        ~{true="--merge-reads" false="" merge_reads} \
        ~{if defined(internal_downsampling) then ("--internal-downsampling " +  '"' + internal_downsampling + '"') else ""} \
        ~{if defined(mapping_quality) then ("--mapping-quality " +  '"' + mapping_quality + '"') else ""} \
        ~{true="--indels" false="" indels} \
        ~{true="--ignore-read-groups" false="" ignore_read_groups} \
        ~{if defined(sample) then ("--sample " +  '"' + sample + '"') else ""} \
        ~{if defined(chromosome) then ("--chromosome " +  '"' + chromosome + '"') else ""} \
        ~{if defined(error_rate) then ("--error-rate " +  '"' + error_rate + '"') else ""} \
        ~{if defined(maximum_error_rate) then ("--maximum-error-rate " +  '"' + maximum_error_rate + '"') else ""} \
        ~{if defined(threshold) then ("--threshold " +  '"' + threshold + '"') else ""} \
        ~{if defined(negative_threshold) then ("--negative-threshold " +  '"' + negative_threshold + '"') else ""} \
        ~{true="--full-genotyping" false="" full_genotyping} \
        ~{true="--distrust-genotypes" false="" distrust_genotypes} \
        ~{true="--include-homozygous" false="" include_homozygous} \
        ~{if defined(default_gq) then ("--default-gq " +  '"' + default_gq + '"') else ""} \
        ~{if defined(gl_regularize_r) then ("--gl-regularizer " +  '"' + gl_regularize_r + '"') else ""} \
        ~{if defined(changed_genotype_list) then ("--changed-genotype-list " +  '"' + changed_genotype_list + '"') else ""} \
        ~{if defined(ped) then ("--ped " +  '"' + ped + '"') else ""} \
        ~{if defined(recombination_list) then ("--recombination-list " +  '"' + recombination_list + '"') else ""} \
        ~{if defined(recomb_rate) then ("--recombrate " +  '"' + recomb_rate + '"') else ""} \
        ~{if defined(gen_map) then ("--genmap " +  '"' + gen_map + '"') else ""} \
        ~{true="--no-genetic-haplotyping" false="" no_genetic_haplo_typing} \
        ~{true="--use-ped-samples" false="" use_ped_samples}
    }

    output {
        File outputVCF = outputVCF
    }

    runtime {
        docker: dockerImage
        time_minutes: timeMinutes
        memory: memory
    }

    parameter_meta {
        outputVCF: {description: "Output VCF file. Add .gz to the file name to get compressed output. If omitted, use standard output.", category: "common"}
        reference: {description: "Reference file. Provide this to detect alleles through re-alignment. If no index (.fai) exists, it will be created", category: "common"}
        no_reference: {description: "Detect alleles without requiring a reference, at the expense of phasing quality (in particular for long reads)", category: "common"}
        tag: {description: "Store phasing information with PS tag (standardized) or HP tag (used by GATK ReadBackedPhasing) (default: {description: PS)", category: "common"}
        output_read_list: {description: "Write reads that have been used for phasing to FILE.", category: "advanced"}
        algorithm: {description: "Phasing algorithm to use (default: {description: whatshap)", category: "advanced"}
        merge_reads: {description: "Merge reads which are likely to come from the same haplotype (default: {description: do not merge reads)", category: "common"}
        internal_downsampling: {description: "Coverage reduction parameter in the internal core phasing algorithm. Higher values increase runtime *exponentially* while possibly improving phasing quality marginally. Avoid using this in the normal case! (default: {description: 15)", category: "advanced"}
        mapping_quality: {description: "Minimum mapping quality (default: {description: 20)", category: "common"}
        indels: {description: "Also phase indels (default: {description: do not phase indels)", category: "common"}
        ignore_read_groups: {description: "Ignore read groups in BAM/CRAM header and assume all reads come from the same sample.", category: "advanced"}
        sample: {description: "Name of a sample to phase. If not given, all samples in the input VCF are phased. Can be used multiple times.", category: "common"}
        chromosome: {description: "Name of chromosome to phase. If not given, all chromosomes in the input VCF are phased. Can be used multiple times.", category: "common"}
        error_rate: {description: "The probability that a nucleotide is wrong in read merging model (default: {description: 0.15).", category: "advanced"}
        maximum_error_rate: {description: "The maximum error rate of any edge of the read merging graph before discarding it (default: {description: 0.25).", category: "advanced"}
        threshold: {description: "The threshold of the ratio between the probabilities that a pair of reads come from the same haplotype and different haplotypes in the read merging model (default: {description: 1000000).", category: "advanced"}
        negative_threshold: {description: "The threshold of the ratio between the probabilities that a pair of reads come from different haplotypes and the same haplotype in the read merging model (default: {description: 1000).", category: "advanced"}
        full_genotyping: {description: "Completely re-genotype all variants based on read data, ignores all genotype data that might be present in the VCF (EXPERIMENTAL FEATURE).", category: "experimental"}
        distrust_genotypes: {description: "Allow switching variants from hetero- to homozygous in an optimal solution (see documentation).", category: "advanced"}
        include_homozygous: {description: "Also work on homozygous variants, which might be turned to heterozygous", category: "advanced"}
        default_gq: {description: "Default genotype quality used as cost of changing a genotype when no genotype likelihoods are available (default 30)", category: "advanced"}
        gl_regularize_r: {description: "Constant (float) to be used to regularize genotype likelihoods read from input VCF (default None).", category: "advanced"}
        changed_genotype_list: {description: "Write list of changed genotypes to FILE.", category: "advanced"}
        ped: {description: "Use pedigree information in PED file to improve phasing (switches to PedMEC algorithm). Columns 2, 3, 4 must refer to child, mother, and father sample names as used in the VCF and BAM/CRAM. Other columns are ignored.", category: "advanced"}
        recombination_list: {description: "Write putative recombination events to FILE.", category: "advanced"}
        recomb_rate: {description: "Recombination rate in cM/Mb (used with --ped). If given, a constant recombination rate is assumed (default: {description: 1.26cM/Mb).", category: "advanced"}
        gen_map: {description: "File with genetic map (used with --ped) to be used instead of constant recombination rate, i.e. overrides option --recombrate.", category: "advanced"}
        no_genetic_haplo_typing: {description: "Do not merge blocks that are not connected by reads (i.e. solely based on genotype status). Default: {description: when in --ped mode, merge all blocks that contain at least one homozygous genotype in at least one individual into one block.", category: "advanced"}
        use_ped_samples: {description: "Only work on samples mentioned in the provided PED file.", category: "advanced"}
        vcf: {description: "VCF or BCF file with variants to be phased (can be gzip-compressed)", category: "required"}
        vcfIndex: {description: "Index for the VCF or BCF file with variants to be phased", category: "required"}
        phaseInput: {description: "BAM, CRAM, VCF or BCF file(s) with phase information, either through sequencing reads (BAM, CRAM) or through phased blocks (VCF, BCF)", category: "required"}
    }
}
