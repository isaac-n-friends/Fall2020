use jtrain98, clear
set more off

* log using jtrain98_1, text replace

tab train

logit train age c.age#c.age educ c.educ#c.educ unem96 earn96  /// 
	c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96
	
predict ph

sum ph if train
sum ph if ~train
count if ph < .1
count if ph > .9

gen agesq = age^2
gen educsq = educ^2
gen age_educ = age*educ
gen earn96sq = earn96^2
gen age_earn96 = age*earn96
gen educ_earn96 = educ*earn96

qui psmatch2 train age agesq educ educsq age_educ unem96 earn96  /// 
	earn96sq age_earn96 educ_earn96, outcome(earn98) logit ate

psgraph, bin(20)
graph save ps_jtrain98_full, replace

qui teffects ipw (earn98) (train age c.age#c.age educ c.educ#c.educ ///
	c.age#c.educ unem96 earn96 c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96)
	
teffects overlap, ptl(1) name(ps_jtrain98_full_smooth, replace)

* Comparison of means:
reg earn98 train, robust

* Linear regression adjustment, different mean functions:
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96) (train)
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96) (train), atet
		 
* Exponential RA:
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96, poisson) (train)
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96, poisson) (train), atet
		 
	
* Now trim the sample:

keep if ph >= .1 & ph <= .9
drop ph


qui psmatch2 train age agesq educ educsq age_educ unem96 earn96  /// 
	earn96sq age_earn96 educ_earn96, outcome(earn98) logit ate

psgraph, bin(20)
graph save ps_jtrain98_trim, replace

qui teffects ipw (earn98) (train age c.age#c.age educ c.educ#c.educ ///
	c.age#c.educ unem96 earn96 c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96)
	
teffects overlap, ptl(1) name(ps_jtrain98_trim_smooth, replace)

* Comparison of means:
reg earn98 train, robust

* Linear regression adjustment, different mean functions:
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96) (train)
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96) (train), atet
		 
* Exponential RA:
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96, poisson) (train)
teffects ra (earn98 age c.age#c.age educ c.educ#c.educ c.age#c.educ unem96 earn96  /// 
         c.earn96#c.earn96 c.age#c.earn96 c.educ#c.earn96, poisson) (train), atet
		 
* log close

	



 



