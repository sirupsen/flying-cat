#include <locale.h>

char _decimal_point[] = ".";
char _thousands_sep[] = ",";
char _grouping[] = { 3, 0 }; // not available because the spec for it isn't very clear
char _int_curr_symbol[] = ""; // not available because it's a stupid field
char _currency_symbol[] = "$";
char _mon_decimal_point[] = ".";
char _mon_thousands_sep[] = ",";
char _mon_grouping[] = { 3, 0 }; // not available because the spec for it isn't very clear
char _positive_sign[] = "+";
char _negative_sign[] = "-";

// according to spec here: http://www.opengroup.org/onlinepubs/009695399/functions/localeconv.html
struct lconv *localeconv(void)
{
	struct lconv* lc = (struct lconv*)malloc(sizeof(struct lconv));
	
	lc->decimal_point		= _decimal_point;
	lc->thousands_sep		= _thousands_sep;
	lc->grouping			= _grouping;
	lc->int_curr_symbol		= _int_curr_symbol;
	lc->currency_symbol		= _currency_symbol;
	lc->mon_decimal_point	= _mon_decimal_point;
	lc->mon_thousands_sep	= _mon_thousands_sep;
	lc->mon_grouping		= _mon_grouping;
	lc->positive_sign		= _positive_sign;
	lc->negative_sign		= _negative_sign;
	
	lc->int_frac_digits		= 2;
	lc->frac_digits			= 2;
	lc->p_cs_precedes		= 1;
	lc->p_sep_by_space		= 0;
	lc->n_cs_precedes		= 1;
	lc->n_sep_by_space		= 0;
	lc->p_sign_posn			= 1;
	lc->n_sign_posn			= 1;
	lc->int_p_cs_precedes	= 1;
	lc->int_n_cs_precedes	= 1;
	lc->int_p_sep_by_space	= 0;
	lc->int_n_sep_by_space	= 0;
	lc->int_p_sign_posn		= 0;
	lc->int_n_sign_posn		= 0;
	
	return lc;
	
	// well that was boring
}
