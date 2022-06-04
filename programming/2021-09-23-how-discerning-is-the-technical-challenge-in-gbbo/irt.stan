 // From https://cengiz.me/posts/crm-stan/
 data{
    int  J;                    //  number of items
    int  I;                    //  number of individuals
    int  N;                //  number of observed responses
  int  item[N];          //  item id
  int  id[N];            //  person id
  real Y[N];             //  vector of transformed outcome
 }

  parameters {

    vector[J] b;                 // vector of b parameters forJ items
      real mu_b;                 // mean of the b parameters
      real<lower=0> sigma_b;     // standard dev. of the b parameters

    vector<lower=0>[J] a;       // vector of a parameters for J items
      real mu_a;                 // mean of the a parameters
      real<lower=0> sigma_a;     // standard deviation of the a parameters

    vector<lower=0>[J] alpha;   // vector of alpha parameters for J items
      real mu_alpha;             // mean of alpha parameters
      real<lower=0> sigma_alpha; // standard deviation of alpha parameters

    vector[I] theta;             // vector of theta parameters for I individuals
  }

  model{

     mu_b     ~ normal(0,5);
     sigma_b  ~ normal(0,1);
         b    ~ normal(mu_b,sigma_b);

     mu_a    ~ normal(0,5);
     sigma_a ~ normal(0,2.5);
         a   ~ normal(mu_a,sigma_a);

     mu_alpha ~ normal(0,5);
     sigma_alpha ~ cauchy(0,2.5);
         alpha   ~ normal(mu_alpha,sigma_alpha);

     theta   ~ normal(0,1);      // The mean and variance of theta is fixed to 0 and 1
                                 // for model identification

      for(i in 1:N) {
        Y[i] ~ normal(alpha[item[i]]*(theta[id[i]]-b[item[i]]),alpha[item[i]]/a[item[i]]);
       }
   }
