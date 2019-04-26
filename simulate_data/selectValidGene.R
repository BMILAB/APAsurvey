setwd('/Path')

gtf = read.table('/Path/hg19_RefSeq_fromUCSC100615_sorted_nuc.gtf',header = F,stringsAsFactors = F)

colnames(gtf) = c('chr','source','feature','start','end','score','strand','frame','gene.prefix','gene.id','comma1','transcript.prefix','transcript.id','comma2')

gtf  = subset(gtf,feature %in% c('exon'))

unique.transcript_id = unique(gtf$transcript.id)

random.idx = sample(1:length(unique.transcript_id),2000,replace = FALSE)

selected.gene = list()

for (i in random.idx){
  subgtf = subset(gtf,transcript.id == unique.transcript_id[i])
  if(length(unique(subgtf$chr))==1 && length(unique(subgtf$gene.id))==1 && length(unique((subgtf$strand)))==1){
    if(nrow(subgtf)>=3){
      subgtf = subgtf[order(subgtf$start),]
      if((subgtf$strand[1]=='+'&& subgtf$end[nrow(subgtf)] - subgtf$start[nrow(subgtf)] > 200 && subgtf$end[nrow(subgtf)] - subgtf$start[nrow(subgtf)] < 4000)||
        (subgtf$strand[1]=='-'&& subgtf$end[1] - subgtf$start[1] > 200 && subgtf$end[1] - subgtf$start[1] <4000)){
        
        curr.chr = subgtf$chr[1]
        curr.start = min(subgtf$start)
        curr.end = max(subgtf$end)
        
        valid.status = TRUE
        if(length(selected.gene)>0){
          for(j in 1:length(selected.gene)){
            
            if(selected.gene[[j]]$chr != curr.chr){
              next
            }else if((curr.start-2500 > selected.gene[[j]]$end || curr.end+2500< selected.gene[[j]]$start)){
              next
            }else{
              valid.status = FALSE
              break
            }
          }
        }
        if(valid.status){
          selected.gene = append(selected.gene,list(list('chr' = curr.chr ,'start' = curr.start,'end'= curr.end,'model' = subgtf)))
        }
      }
    }
  }
}



##### generate 2 isoforms #####
for(i in 1:1000){
  isoform0 = selected.gene[[i]]$model
  isoform1 = isoform0
  if(isoform1$strand[1]=='+'){
    isoform1$end[nrow(isoform1)] = isoform1$end[nrow(isoform1)] + 1000
  }else{
    isoform1$start[1] = isoform1$start[1] - 1000
  }
  isoform1$transcript.id = paste(isoform1$transcript.id,".1",sep = '')
  
  anno = paste(isoform0$gene.prefix,' "',isoform0$gene.id,'"; ',isoform0$transcript.prefix,' "',isoform0$transcript.id,'";',sep = '')
  write.table(cbind(isoform0[,1:8],anno),file = 'two_isoforms.gtf',row.names = F,col.names = F,quote = F,append = T,sep = '\t')
  
  anno = paste(isoform1$gene.prefix,' "',isoform1$gene.id,'"; ',isoform1$transcript.prefix,' "',isoform1$transcript.id,'";',sep = '')
  write.table(cbind(isoform1[,1:8],anno),file = 'two_isoforms.gtf',row.names = F,col.names = F,quote = F,append = T,sep = '\t')
}


##### generate random isoforms #####
# 50  1 isoform
# 450 2 isoforms
# 300 3 isoforms
# 200 4 isoforms
Tick = c(rep(1,50),rep(2,450),rep(3,300),rep(4,200))
addLens = c(0,500,1000,1500)
for(i in 1:1000){
  isoform = selected.gene[[i]]$model
  
  for(j in 1:Tick[i]){
    currisoform = isoform
    if(isoform$strand[1]=='+'){
      currisoform$end[nrow(currisoform)] = isoform$end[nrow(isoform)] + addLens[j]
    }else{
      currisoform$start[1] = isoform$start[1] - addLens[j]
    }
    if(j!=1){
      currisoform$transcript.id = paste(currisoform$transcript.id,".",j-1,sep = '')
    }
    
    anno = paste(currisoform$gene.prefix,' "',currisoform$gene.id,'"; ',currisoform$transcript.prefix,' "',currisoform$transcript.id,'";',sep = '')
    write.table(cbind(currisoform[,1:8],anno),file = 'multiple_isoforms.gtf',row.names = F,col.names = F,quote = F,append = T,sep = '\t')
  }
}