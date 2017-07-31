# Given ROCR prediction object(s), create a ggplot

roc_plot <- function(..., names=NULL, title="Receiver Operating Characteristic Curve") {
  # Arguments:
  # ...:    Data frames with necessary info
  # names:  Character vector specifying names of the models
  
  pred <- list(...)
  
  perf_data <- NULL
  j <- 1
  
  # Build a data frame from performance objects
  for (i in pred) {
      # Add model name
      i$data_frame <- i$data_frame %>%
        mutate(model = names[j])

    if (is.null(perf_data)) {
      perf_data <- i$data_frame
    } else {
      perf_data <- rbind(perf_data, i$data_frame)
    }
    
    j <- j + 1
  }
  
  return(
    ggplot(perf_data, aes(fpr, tpr, color=model)) +
      scale_color_brewer(name="Models", type="div", palette="Spectral") +
      geom_line(size=1.5, alpha=0.75, linetype="solid") +
      geom_abline(size=1, linetype="dotted", slope=1) +
      labs(title=title,
           x="False Positive Rate",
           y="True Positive Rate")
  )
}

pr_plot <- function(..., names=NULL, title="Precision-Recall Curve") {
  # Arguments:
  # ...:    Data frames with necessary info
  # names:  Character vector specifying names of the models
  
  pred <- list(...)
  
  perf_data <- NULL
  j <- 1
  
  # Build a data frame from performance objects
  for (i in pred) {
    # Add model name
    i$data_frame <- i$data_frame %>%
      mutate(model = names[j])
    
    if (is.null(perf_data)) {
      perf_data <- i$data_frame
    } else {
      perf_data <- rbind(perf_data, i$data_frame)
    }
    
    j <- j + 1
  }
  
  return(
    ggplot(perf_data, aes(recall, precision, color=model)) +
      scale_color_brewer(name="Models", type="div", palette="Spectral") +
      geom_line(size=1.5, linetype="dashed") +
      labs(title=title,
           x="Recall",
           y="Precision")
  )
}

f1_plot <- function(..., names=NULL, title="F1 Score") {
  # Arguments:
  # ...:    Data frames with necessary info
  # names:  Character vector specifying names of the models
  
  pred <- list(...)
  
  perf_data <- NULL
  j <- 1
  
  # Build a data frame from performance objects
  for (i in pred) {
    # Add model name
    i$data_frame <- i$data_frame %>%
      mutate(model = names[j])
    
    if (is.null(perf_data)) {
      perf_data <- i$data_frame
    } else {
      perf_data <- rbind(perf_data, i$data_frame)
    }
    
    j <- j + 1
  }
  
  return(
    ggplot(perf_data, aes(p_thresh, f1, color=model)) +
      scale_color_brewer(name="Models", type="div", palette="Spectral") +
      geom_line(size=1.5, alpha=0.75, linetype="solid") +
      labs(title=title,
           x="Probability Threshold",
           y="F1 Score")
  )
}

# ==== ROC Curves ====
ROCCurve <- setRefClass(
  "ROCCurve",
  fields = c('data_frame'),
  methods = list(
    initialize = function(actual, predicted) {
      # Actual:       Actual response data
      # Predicted:    Predicted values from a glm model
      
      p_threshes <- c()
      
      fp_counts <- c()
      tp_counts <- c()
      fn_counts <- c()
      tn_counts <- c()
      
      # Should be a list of FP, TP ratios
      fp_ratios <- c()
      tp_ratios <- c()
      
      # Euclidean Distance to (FPR = 0, TPR = 1)
      dists_0_1 <- c()
      
      for (p_thresh in seq(0, 1, length.out=200)) {
        predicted_this_thresh <- ifelse(predicted >= p_thresh, yes=1, no=0)
        
        temp <- actual + 0.5 * predicted_this_thresh
        tp_count <- length(which(temp == 1.5))
        fp_count <- length(which(temp == 0.5))
        fn_count <- length(which(temp == 1))
        tn_count <- length(which(temp == 0))
        tp_ratio <- tp_count/length(which(actual == 1))
        fp_ratio <- fp_count/length(which(actual == 0))
        dist_0_1 <- sqrt((1 - tp_ratio)^2 + fp_ratio^2)
        
        # Add to list of ratios
        p_threshes <- append(p_threshes, p_thresh)
        
        tp_counts <- append(tp_counts, tp_count)
        fp_counts <- append(fp_counts, fp_count)
        tn_counts <- append(tn_counts, tn_count)
        fn_counts <- append(fn_counts, fn_count)
        
        fp_ratios <- append(fp_ratios, fp_ratio)
        tp_ratios <- append(tp_ratios, tp_ratio)
        dists_0_1 <- append(dists_0_1, dist_0_1)
      }
      
      # Add results to data_frame field
      data_frame <<- data.frame(p_thresh=p_threshes,
                        fp=fp_counts, tp=tp_counts,
                        fn=fn_counts, tn=tn_counts,
                        fpr=fp_ratios, tpr=tp_ratios,
                        dist_0_1=dists_0_1) %>%
        
      # Add precision and recall, F1
        mutate(precision=tp/(tp + fp)) %>%
        mutate(recall=tp/(tp + fn)) %>%
        mutate(f1=2*(precision*recall)/(precision+recall))
    }
  )
)