//Test program for optimization

data{
  int<lower=1> N; //number of obs
  vector[N] y_in; // observed y
  vector[N] x_in; // observed x
  real<lower=0> sd_y;
  real<lower=0> sd_x;
}

parameters{
  real<lower=0,upper=100> x;
  real<lower=0,upper=200> y;
}
model{
  y_in ~ normal(y, sd_y);
  x_in ~ normal(x, sd_x);
  
  target += 2*x +4*y;
}
