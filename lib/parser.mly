%token <string> KEY
%token <string> VAL
%token EQUALITY
%token EOF
%start <(string * string) list> config
%%

config:
  kvs = key_values; EOF { kvs } ;

key_values:
  kvs = list(key_value) { kvs } ;

key_value:
  k = KEY; EQUALITY; v = VAL { (k, v) }
