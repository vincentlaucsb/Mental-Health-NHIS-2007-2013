# ====
# group should be a character string specifying a column
worthless_by_group <- function(group=NULL) {
  group_cols <- c('srvy_yr', 'intv_qrt', 'worthless_once')
  index <- 3
  
  # If no group specified, show the plot for everybody
  if (!is.null(group)) {
    group_cols <- append(group_cols, group)
    index <- 4
  }
  
  temp <- dep %>%
    group_by_(.dots=group_cols) %>%
    summarise(count=sum(weight_sa))
  
  worthless_qrt <- temp %>%
    filter(worthless_once == 1) %>%
    ungroup() %>%
    select(-worthless_once)
  
  names(worthless_qrt)[index] = "worthless"
  
  not_worthless_qrt <- temp %>%
    filter(worthless_once == 0) %>%
    ungroup() %>%
    select(-worthless_once)
  
  names(not_worthless_qrt)[index] = "never_worthless"
  
  both_worthless_qrt <- left_join(
    worthless_qrt, not_worthless_qrt, by=c("srvy_yr", "intv_qrt", group)) %>%
    mutate(percent=worthless/never_worthless) %>%
    mutate(time = paste0(srvy_yr, "-", intv_qrt)) %>%
    ungroup() %>%
    select_(.dots=c(group, 'time', 'percent'))
  
  return(melt(both_worthless_qrt, id.vars=c(group, "time")))
}