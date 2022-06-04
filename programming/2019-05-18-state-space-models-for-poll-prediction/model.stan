// From James Savage at https://github.com/khakieconomics/stanecon_short_course/blob/80263f84ebe95be3247e591515ea1ead84f26e3f/03-fun_time_series_models.Rmd

//and modification inspired by Peter Ellis at https://github.com/ellisp/ozfedelect/blob/master/model-2pp/model-2pp.R

// saved as models/state_space_polls.stan
data {
  int polls; // number of polls
  int T; // number of days
  matrix[T, polls] Y; // polls
  matrix[T, polls] sigma; // polls standard deviations
  real inflator;         // amount by which to multiply the standard error of polls
  real initial_prior;
  real random_walk_sd;
  real mu_sigma;
}
parameters {
  vector[T] mu; // the mean of the polls
  real<lower = 0> tau; // the standard deviation of the random effects
  matrix[T, polls] shrunken_polls;
}
model {
  // prior on initial difference
  mu[1] ~ normal(initial_prior, mu_sigma);
  tau ~ student_t(4, 0, 5);
  // state model
  for(t in 2:T) {
    mu[t] ~ normal(mu[t-1], random_walk_sd);
  }
  
  // measurement model
  for(t in 1:T) {
    for(p in 1:polls) {
      if(Y[t, p] != -9) {
        Y[t,p]~ normal(shrunken_polls[t, p], sigma[t,p] * inflator);
        shrunken_polls[t, p] ~ normal(mu[t], tau);
      } else {
        shrunken_polls[t, p] ~ normal(0, 1);
      }
    }
  }
}
