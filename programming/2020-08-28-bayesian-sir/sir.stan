// Based on https://mc-stan.org/users/documentation/case-studies/boarding_school_case_study.html
functions {
  real[] sir(real t, real[] y, real[] theta,
             real[] x_r, int[] x_i) {

      real S = y[1];
      real E = y[2];
      real I = y[3];
      real R = y[4];
      real N = x_i[1];

      real beta = theta[1];
      real delta = theta[2];
      real gamma = theta[3];

      real dS_dt = -beta * I * S / N;
      real dE_dt =  beta * I * S / N - delta * E;
      real dI_dt =  delta*E - gamma * I;
      real dR_dt =  gamma * I;

      return {dS_dt, dE_dt, dI_dt, dR_dt};
  }
}
data {
  int<lower=1> n_days;
  real y0[4];
  real t0;
  real ts[n_days];
  int N;
  int cases[n_days-1];
  int n_pred;
  real ts_pred[n_pred];
  real delta_mu;
}
transformed data {
  real x_r[0];
  int x_i[1] = { N };

}
parameters {
  real<lower=0> theta[3];
  real<lower=0> phi_inv;

}
transformed parameters{
  real y[n_days, 3];
  real<lower=0> phi = 1. / phi_inv;
  real<lower=0> incidence[n_days-1];

  {

    y = integrate_ode_rk45(sir, y0, t0, ts, theta, x_r, x_i);
  }

  //for (i in 2:(n_days-1)) {
   for (i in 1:(n_days-1))
  	incidence[i] = y[i, 1] - y[i + 1, 1];


}
model {
  //priors
  theta[1]~ normal(2, 1); //beta
  theta[2]~ normal(delta_mu, .1); //delta
  theta[3]~ normal(0.1, 0.7); //gamma
  phi_inv ~ exponential(2);

  cases ~ neg_binomial_2(incidence, phi);

}
generated quantities {
  real R0 = theta[1] / theta[3];
  real recovery_time = 1 / theta[3];
  real pred_cases[n_days-1];
  real pred_cases_out[n_pred-1];
  real pred_incidence[n_pred-1];

  // future prediction parameters
  real y_pred[n_pred, 3];
  real y_init_pred[3] = y[n_days, ]; // New initial conditions
  real t0_pred = ts[n_days];        // New time zero is the last observed time

  pred_cases = neg_binomial_2_rng(incidence, phi);

  y_pred = integrate_ode_rk45(sir, y_init_pred, t0_pred, ts_pred, theta, x_r, x_i);

  for (i in 1:(n_pred-1))
  	pred_incidence[i] = y_pred[i, 1] - y_pred[i + 1, 1];

  	pred_cases_out = neg_binomial_2_rng(pred_incidence, phi);


}