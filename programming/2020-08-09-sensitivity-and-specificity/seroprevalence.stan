// The input data is a vector 'y' of length 'N'.
data {
  int<lower = 0> y_sample;
  int<lower = 0> n_sample;
  real sensitivity;
  real specificity;
  real sensitivity_sd;
  real specificity_sd;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0, upper = 1> p;
  real<lower=0, upper = 1> spec;
  real<lower=0, upper = 1> sens;
}

// The positivites observed are a function of 
// sensitivity and specificity of test then
// drawn from a bininomial distribution
model {
  real p_sample = p * sens + (1 - p) * (1 - spec);
  y_sample ~ binomial(n_sample, p_sample);
  
  // Use Priors for Sensitivity and Specificity
  // Truncated Normal Because That's What is 
  // Available
  
  spec ~ normal(specificity, specificity_sd);
  sens ~ normal(sensitivity, sensitivity_sd);
  
}

