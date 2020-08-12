version 1.0

workflow myWorkflow {

    ##################################
    #### required basic arguments ####
    ##################################
    
    input {
        File input_bam_file
    }
    
    call clusterID{
        input :
            input_bam_file=input_bam_file,
            input_bam_index=input_bam_file + ".bai"
    }

    call scrambleMEI{
        input: 
            infile=clusterID.out
    }

}


task clusterID{
    
    input {
        File input_bam_file
        File input_bam_index
    }
    command {
        cluster_identifier ${input_bam_file} > clusters.txt
    }

    output {
        File out = "clusters.txt"
    }

    runtime {
        docker: "sphao/scramble_docker:latest"
    }
}

task scrambleMEI{
    
    input {
        File infile
    }

    command {

        Rscript --vanilla /app/cluster_analysis/bin/SCRAMble-MEIs.R \
            --out-name $PWD/outfile.txt \
            --cluster-file ${infile} \
            --install-dir /app/cluster_analysis/bin \
            --mei-refs /app/cluster_analysis/resources/MEI_consensus_seqs.fa
    }
    output {
        File out = "outfile.txt"
    }
    runtime {
        docker: "sphao/scramble_docker:latest"
    }
}


    ############################################
    #### for testing the built-in test file ####
    ############################################
#task myTask {
#    command {
#        cluster_identifier /app/validation/test.bam > clusters.txt
#    }
#    output {
#        File out = "clusters.txt"
#    }
#    runtime {
#        docker: "sphao/scramble_docker:latest"
#    }
#}
