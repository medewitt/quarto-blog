functions{
	real viral_kinetics (real v_max, real a, real b, real t, real t_max){
		return(v_max * (a + b) / (b * exp(-a*(t - t_max)) + a * exp(b*(t-t_max))));
	}
}

data {
	int<lower=1> N; // Number of records
	int<lower=0> id[N]; //Participant IDs
	vector<lower=0> [N] nAbs_max; // Maximum Ab concentration
	vector<lower=0> [N] nAbs; //The concentration of the antibodies
	vector [N] time; //The concentration of the antibodies
	vector [N] t_max; //The concentration of the antibodies
	real prior_a_mu;
	real prior_b_mu;
	real prior_a_sd;
	real prior_b_sd;
	int pred_window;
}

parameters {
	real<lower=0> a;
	real<lower=0> b;
	real<lower=0> sigma;
}

transformed parameters{
	vector<lower=0>[N] mu;
	
	for( i in 1:N){
		mu[i] = viral_kinetics(nAbs_max[id[i]], a, b, time[id[i]], t_max[id[i]]);
	}
	
}
model {
	a ~ normal(prior_a_mu, prior_a_sd);
	b ~ normal(prior_b_mu, prior_b_sd);
	sigma ~ normal(0,1);
	
	nAbs ~ normal(mu, sigma);
}

generated quantities{
	vector[pred_window] yhat;
	vector[pred_window] mu_pred;
	real avg_nabs_max = mean(nAbs_max);
	real avg_tmax = mean(t_max);
	
	for(i in 1:pred_window){
		mu_pred[i] = viral_kinetics(avg_nabs_max, a, b, i, avg_tmax);
		yhat[i] = normal_rng(mu_pred[i], sigma);
	}
	
}