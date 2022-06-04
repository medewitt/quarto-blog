functions {
  vector ode_antibodies(real t, vector y ,
     real kc, real kl){


  vector[3] dydt;

  dydt[1] = - kc * y[1]; // Exposure
  dydt[2] =  kc * y[1]  - kl * y[2]; //
  dydt[3] = kl * y[2]; // Gone

  return dydt;
}
}

data{
  int N; //Number of Observations
  vector[N] y; // Concentration
  vector [3] y0;
  real t [N];
  int N_estimates;
  real t_estimates[N_estimates];

}

transformed data {
  real t0 = 0;
}

parameters{
  real<lower=0> kc;
  real<lower=0> kl;
}

transformed parameters{
  vector[3] yhat[N];
  yhat = ode_rk45(ode_antibodies, y0,t0, t, kc,kl);
}

model{
  y ~normal(yhat[,2],.1);

  kc ~ gamma(1,1);
  kl ~ gamma(1,1);

}

generated quantities{
  vector [N_estimates] c_estimates;

  {
    vector[3] yhatest[N];
    yhatest = ode_rk45(ode_antibodies, y0,t0, t_estimates, kc,kl);

    for(i in 1:N_estimates){
      c_estimates[i] = normal_rng(yhatest[i,2],.1);
    }


  }


}
