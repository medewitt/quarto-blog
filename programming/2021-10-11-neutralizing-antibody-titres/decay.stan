data {
	int<lower=1> N; // Number of Samples
	int<lower=1> J; //Number of participants
	vector [N] nAbs; //The concentration of the antibodies
	vector [N] time; //The concentration of the antibodies
}

parameters{
	real omega;
	real hl;
	real<lower=0> sigma;
}

transformed parameters {
	vector[N] theta;  //vac effect
	theta[1:N] = omega + (1- omega)  * exp(-hl*time[1:N]);
}

model {
	hl ~ normal(0,2);
	omega ~ normal(0,1);
	nAbs ~ normal(theta, sigma);
}
