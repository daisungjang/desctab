desctab <- function(x, y){
  
if(missing(y)) {
    y = paste("Descriptive_", strftime(as.POSIXlt(Sys.time()) , "%Y-%m-%d | %H.%M"), ".xlsx", sep = "" )
  } else {
  }
  
  x <- Filter(is.numeric, x)
  
  # borrows heavily from the corstarsl function
  # http://myowelt.blogspot.com/2008/04/beautiful-correlation-tables-in-r.html
  
  require(Hmisc)
  require(openxlsx)
  x <- as.matrix(x) 
  R <- rcorr(x)$r 
  p <- rcorr(x)$P 
  
  ## define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .01, "** ", ifelse(p < .05, "* ", ifelse(p < .10, "† ", " ")))
  ## trunctuate the matrix that holds the correlations to two decimal
  R <- format(round(cbind(rep(-1.11, ncol(x), widths = c(4)), R), 2))[,-1]
  
  ## build a new matrix that includes the correlations with their apropriate stars
  Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
  diag(Rnew) <- paste(diag(R), " ", sep="")
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep="")
  
  ## remove upper triangle
  Rnew <- as.matrix(Rnew)
  Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
  Rnew <- as.data.frame(Rnew)
  
  ## create two versions of the table, one with just stars and another with just numbers
  Rnew <- cbind(Rnew[1:length(Rnew)-1])
  temptab_star <- sapply(Rnew, function(x) gsub("[^\\*|^\\†]+", "", x))
  temptab_num <- sapply(Rnew, function(x) gsub("[^-|0-9|\\.|\\s]+", "", x))
  
  #create indexes for the desired order
  index <- order(c(1:ncol(temptab_num), 1:ncol(temptab_star))) ## taken from here: https://stackoverflow.com/questions/24576548/merge-interleave-dataframes-in-r
  
  #cbind, interleaving columns
  cortab <- cbind(temptab_num, temptab_star)[, index]
  
  #generate column numbers
  colnum <- paste(seq(1:length(temptab_num[1,])), ".", sep = "")
  
  colnames(cortab) <- c(rbind(colnum, rep("", ncol(temptab_star))))
  
  
  # Create a summary table and write to an Excel file, adapted from: https://stackoverflow.com/questions/50471794/sapply-retain-column-names
  
  sfsum = function(x){
    mean = as.numeric(round(mean(x, na.rm = T), 2))
    sd = round(sd(x, na.rm = T), 2)
    n = sum(!is.na(x))
    return(c(" N " = n, "Mean" = mean,"SD" = sd)) #For column names
  }
  
  #Combine the two tables and generate notes. 
  
  tab1 <- t(sapply(as.data.frame(x), sfsum, USE.NAMES = TRUE)) #USE.NAMES = TRUE to get names on top
  
  tab2 <- cbind(tab1, cortab)
  
  tab2 <- as.data.frame(tab2)
  
  # Create variable column
  tab2$Variables <- rownames(tab2)
  
  # Reorder columns
  tab2 <- tab2[, c(which(colnames(tab2)=="Variables"), which(colnames(tab2)!="Variables"))]
  
  # Number and combine variable names
  varnum <- paste(seq.int(nrow(tab2)), ". ", sep = "")
  
  tab2$Variables <- paste(varnum, tab2$Variables, sep = "")
  
  # Get N for correlation table
  number <- rcorr(x)$n
  
  tabmin <- min(number)
  
  tabmax <- max(number)
  
  ns <- paste("The N for the correlation table ranges from ", tabmin, " to ", tabmax, ".", sep = "" )
  
  note <- paste("Note. ", ns, " † p < .10, * p < .05, ** p < .01.", sep = "")
  
  noteline <- cbind(note, t(rep(NA, (ncol(tab2) - 1))))
  
  colnames(noteline) <- colnames(tab2)
  
  #tab2 <- (rbind(tab2, noteline))
  
  # Converting summary statistics to numeric 
  tab2[, 2] <- as.numeric(tab2[, 2]) 
  tab2[, 3] <- as.numeric(tab2[, 3]) 
  tab2[, 4] <- as.numeric(tab2[, 4]) 
  
  l1 <- seq(5, ncol(tab2), by = 2)
  
  for(i in 1:length(l1)){
    tab2[, l1[i]] <- as.numeric(tab2[, l1[i]])
  }
  
  wb <- createWorkbook()
  modifyBaseFont(wb, fontSize = 12, fontName = "Times New Roman")
  addWorksheet(wb, sheetName = "descriptives", gridLines = FALSE)
  
  #writeData(wb, sheet = 1, tab2, startCol = "A", startRow = 1)
  
  # https://stackoverflow.com/questions/52040942/automatically-convert-numbers-stored-as-text-to-numbers
  
  for(i in seq_along(tab2)){
    writeData(wb, sheet = "descriptives", names(tab2)[i], startCol = i+1, startRow = 2)
    icol <- tab2[[i]]
    for(j in seq_along(icol)){
      x <- icol[[j]]
      writeData(wb, sheet = "descriptives", x, startCol = i + 1, startRow = j + 2)
    }
  }
  
  # Format column width: 
  col_num <- seq(from = 6, to = ncol(tab2), by = 2)
  col_ast <- seq(from = 7, to = ncol(tab2) + 2, by = 2)
  row_main <- seq(from = 3, to = nrow(tab2) + 2)
  
  col_widmax <- apply(tab2[2],2, function(x) max(nchar(as.character(x))+0.17, na.rm = TRUE)) 
  setColWidths(wb, sheet = "descriptives", cols = 3, widths = col_widmax)
  
  col_widmax <- apply(tab2[3],2, function(x) max(nchar(as.character(x))+0.17, na.rm = TRUE)) 
  setColWidths(wb, sheet = "descriptives", cols = 4, widths = col_widmax)
  
  col_widmax <- apply(tab2[4],2, function(x) max(nchar(as.character(x))+0.17, na.rm = TRUE)) 
  setColWidths(wb, sheet = "descriptives", cols = 5, widths = col_widmax)
  
  setColWidths(wb, sheet = "descriptives", cols = 2, widths = c(20.17)) 
  setColWidths(wb, sheet = "descriptives", cols = col_num, widths = c(4.17))
  setColWidths(wb, sheet = "descriptives", cols = col_ast, widths = c(2.17))
  
  # Format left-right aligment & border:
  sty_ro1 <- createStyle(valign = "center", halign = "center", borderStyle = c("medium", "thin"), border = c("top","bottom"), numFmt = "0.00")
  sty_num <- createStyle(numFmt = ".00", halign = "right")
  sty_gen <- createStyle(halign = "left")
  sty_rnote <- createStyle(borderStyle = "medium", border = c("top"), numFmt = "0.00")
  sty_colMSD <- createStyle(numFmt = "0.00")
  
  addStyle(wb, sheet = "descriptives", style = sty_colMSD, rows = 3:nrow(tab2)+2, cols = 4:5, gridExpand = TRUE)
  addStyle(wb, sheet = "descriptives", style = sty_ro1, rows = 2, cols = 1:ncol(tab2)+1, gridExpand = TRUE)
  addStyle(wb, sheet = "descriptives", style = sty_num, rows = row_main, cols = col_num, gridExpand = TRUE) 
  addStyle(wb, sheet = "descriptives", style = sty_gen, rows = row_main, cols = col_ast, gridExpand = TRUE) 
  addStyle(wb, sheet = "descriptives", style = sty_rnote, rows = nrow(tab2) + 3, cols = 1:ncol(tab2)+1, gridExpand = TRUE)
  
  writeData(wb, sheet = "descriptives", note, rowNames = FALSE, colNames = TRUE, startCol = 2, startRow = nrow(tab2) + 3)
  
  #  writeData(wb, sheet = 1, tab2, startCol = "A", startRow = 1)
  
  l2 <- seq(6, ncol(tab2), by = 2)
  for(i in l2){
    j = i+1
    mergeCells(wb, 1, cols = i:j, rows = 2)    
  }
  
  saveWorkbook(wb, y, overwrite = TRUE)
  
  rownames(tab2) <- c()
  
  excelcolnums <- c(rbind(colnum, rep("", ncol(temptab_star))))
  
  colnames(tab2) <- c("Variables", "N", "Mean", "SD", excelcolnums)
  
  return(tab2)
  
}
