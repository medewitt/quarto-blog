#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double Priorcpp(double theta) {
  return 1/sqrt(2*M_PI)*exp(-pow(theta,2)/2);
}

// [[Rcpp::export]]
double Likelihoodcpp(NumericVector x, double theta) {
  double likelihood;
  double loglike;
  int n = x.size();
  
  loglike = log(1) - (n*log(M_PI)+sum(log(1+pow((x-theta),2))));
  likelihood = exp(loglike);
  return likelihood;
}

// [[Rcpp::export]]

NumericVector make_posterior(NumericVector x, int niter, 
                             double theta_start_val, double theta_proposal_sd){
  NumericVector theta(niter);
  double current_theta;
  double new_theta;
  double r;
  double rand_val;
  double thresh;
  
  theta[0] = theta_start_val;
  
  for(int i = 1; i < niter; i++){
    
    current_theta = theta[i-1];
    
    rand_val = rnorm(1,0, theta_proposal_sd)[0];
    
    new_theta = current_theta + rand_val;
    
    
    r = Priorcpp(new_theta) * Likelihoodcpp(x, new_theta)/
      (Priorcpp(current_theta)* Likelihoodcpp(x, current_theta));
    
    
    thresh = runif(1)[0];
    
    theta[i] = new_theta;
    
    
    if(thresh<r){
      theta[i] = new_theta;
    } else{
      theta[i] = current_theta;
    }
    
    
  }
  return theta;
}


