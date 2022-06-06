data{
  int N; // number of measurements
  int J; // number of raters
  array [N] vector[J] x_measure;
  
}
parameters{
  cov_matrix[J] Sigma;
}
model {
  
  array[N] vector[K] mu;
  for (n in 1:N) {
    mu[n] = beta * x[n];
  }
  
   y ~ multi_normal(mu, Sigma);
}