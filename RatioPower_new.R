# define a function that returns the power value given 
# ratio r1 = y1/sig1 and ratio rk = sigk/sig1
ratio_power = function(Y, r1, rk, N, K, compute_pcombine, compute_power, knum = 1, ktype = "homo"){
  # the treatment level y1
  y1 = Y[2]
  # derive the standard deviation sig array 
  sigk = NULL
  if (ktype == "homo"){
    sigk = rep(rk* y1/r1, K)
  }else{
    if (ktype == "normal"){
    ex_mean = log(y1 * rk/r1)
    sigk = exp(rnorm(K, ex_mean))
    }else{
    if (ktype == "min" | ktype == "max" | ktype == "median")
      {
     sigk = rk * y1/r1
     }else{
       print("Error: not choosing the existent type")
      }
     }
    }
  sigk[2] = y1/r1 

  # compute the corresponding p_power 
  power = NULL
  # derive the critical value p_cv for null hypothesis
  p_cv = quantile(compute_pcombine(Y, sigk, N, K), 0.05)
  # get the sparse effect 
  Y_treat = Y
  Y_treat[2] = 1
  for (j in 1:knum){
    power[j] = compute_power(Y_treat, sigk, N, K, p_cv)
  }
  avg_power = mean(power)

  return(avg_power) 
}

# minimal sigma case 
sig_stat_gen = function(mean, K, ratio_type = "min", sig_type = "uniform"){
  if (sig_type == "uniform"){
    rk = runif(K, max = 2 * mean)
  }else{
    if (sig_type == "log-normal"){
    rk = exp(rnorm(K, log(mean)))
    }else{
    print("Error: not choosing the existent type")
    }
  }
  # get the rest of sigmas apart from sig1
  rk_rest = c(rk[1], rk[3:K])
  rk_min_item = min(rk_rest) 
  rk_max_item = max(rk_rest)
  rk_median_item = median(rk_rest)
  
  if (ratio_type == "min"){
    rk_item = rk_min_item
  }else{
    if (ratio_type == "max" ){
    rk_item = rk_max_item  
  }else{
   if (ratio_type == "median"){
    rk_item = rk_median_item
  }else{
    print("Error: not choosing the existent type")
      }
    }
  }
  return( list(rk_item = rk_item,  rk = rk) )
}

