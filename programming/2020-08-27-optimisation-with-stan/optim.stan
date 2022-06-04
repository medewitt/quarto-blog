//Test program for optimization

data{
  
}

parameters{
  real<lower=0,upper=10> x;
  real<lower=0,upper=20> y;
}
model{
  target += 2*x +4*y;
}
