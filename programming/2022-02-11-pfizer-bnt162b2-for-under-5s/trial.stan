//based on https://www.robertkubinec.com/post/vaccinepval/
// Which is based on https://rpubs.com/ericnovik/692460
data {
  int<lower=1> r_c; // num events, control
  int<lower=1> r_t; // num events, treatment
  int<lower=1> n_c; // num cases, control
  int<lower=1> n_t; // num cases, treatment
  real a[2];   // prior values for treatment effect

}
parameters {
  real<lower=0, upper=1> p_c; // binomial p for control
  real<lower=0, upper=1> p_t; // binomial p for treatment
}
transformed parameters {
  real RR  = 1 - p_t / p_c;  // Relative effectiveness
}
model {
  (RR - 1)/(RR - 2) ~ beta(a[1], a[2]); // prior for treatment effect
  r_c ~ binomial(n_c, p_c); // likelihood for control
  r_t ~ binomial(n_t, p_t); // likelihood for treatment
}
generated quantities {
  real effect   = p_t - p_c;      // treatment effect
  real log_odds = log(p_t / (1 - p_t)) - log(p_c / (1 - p_c));
}
