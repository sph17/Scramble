workflow myWorkflow {
    
    call myTask

    call myTask2{
        input: 
            infile=myTask.out
    }

}

task myTask {
    command {
        cluster_identifier /app/validation/test.bam > clusters.txt
    }
    output {
        File out = "clusters.txt"
    }
    runtime {
        docker: "sphao/scramble_docker:latest"
    }
}

task myTask2 {
    File infile

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
