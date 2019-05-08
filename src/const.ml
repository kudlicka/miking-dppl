(** Constants and constant operations (intrinsics) used as part of pplcore. *)

open Printf

(** Constant terms/expressions *)
type const =

  (* Unit constant *)
  | CUnit

  (* Boolean constant and operations *)
  | CBool    of bool
  | CNot
  | CAnd     of bool option
  | COr      of bool option

  (* Character constant and operations *)
  | CChar    of char

  (* String constant and operations *)
  | CString  of string

  (* Integer constant and operations *)
  | CInt     of int
  | CMod     of int option
  | CSll     of int option
  | CSrl     of int option
  | CSra     of int option

  (* Floating-point number constant and operations *)
  | CFloat   of float
  | CLog

  (* Polymorphic integer/floating-point functions *)
  | CAdd     of const option
  | CSub     of const option
  | CMul     of const option
  | CDiv     of const option
  | CNeg
  | CLt      of const option
  | CLeq     of const option
  | CGt      of const option
  | CGeq     of const option

  (* Polymorphic functions *)
  | CEq      of const option
  | CNeq     of const option

  (* Probability distributions *)
  | CNormal  of float option * float option
  | CUniform of float option * float option
  | CGamma   of float option * float option
  | CExp     of float option
  | CBern    of float option

  (* Functions operating on probability distributions *)
  | CLogPdf  of const option
  | CSample


(** Returns the number of expected arguments for constants *)
let arity c = match c with
  | CUnit -> 0

  | CBool _    -> 0
  | CNot       -> 1
  | CAnd(None) -> 2  | CAnd(Some _) -> 1
  | COr(None)  -> 2  | COr(Some _)  -> 1

  | CChar _ -> 0

  | CString _ -> 0

  | CInt _     -> 0
  | CMod(None) -> 2  | CMod(Some _) -> 1
  | CSll(None) -> 2  | CSll(Some _) -> 1
  | CSrl(None) -> 2  | CSrl(Some _) -> 1
  | CSra(None) -> 2  | CSra(Some _) -> 1

  | CFloat _ -> 0
  | CLog     -> 1

  | CAdd(None) -> 2  | CAdd _ -> 1
  | CSub(None) -> 2  | CSub _ -> 1
  | CMul(None) -> 2  | CMul _ -> 1
  | CDiv(None) -> 2  | CDiv _ -> 1
  | CNeg       -> 1
  | CLt(None)  -> 2  | CLt _  -> 1
  | CLeq(None) -> 2  | CLeq _ -> 1
  | CGt(None)  -> 2  | CGt _  -> 1
  | CGeq(None) -> 2  | CGeq _ -> 1

  | CEq(None)  -> 2  | CEq(Some _)  -> 1
  | CNeq(None) -> 2  | CNeq(Some _) -> 1

  | CNormal(None,None)     -> 2
  | CNormal(Some _,None)   -> 1
  | CNormal(Some _,Some _) -> 0
  | CNormal _              -> failwith "Should not happen"

  | CUniform(None,None)      -> 2
  | CUniform(Some _, None)   -> 1
  | CUniform(Some _, Some _) -> 0
  | CUniform _               -> failwith "Should not happen"

  | CGamma(None,None)      -> 2
  | CGamma(Some _, None)   -> 1
  | CGamma(Some _, Some _) -> 0
  | CGamma _               -> failwith "Should not happen"

  | CExp(None) -> 1  | CExp _ -> 1

  | CBern(None) -> 1 | CBern _ -> 1

  | CLogPdf(None) -> 2 | CLogPdf(Some _) -> 1

  | CSample -> 1

(* Convert constants to pretty printed strings *)
let rec string_of_const c = match c with
  | CUnit -> "()"

  | CBool(b)      -> string_of_bool b
  | CNot          -> "not"
  | CAnd(None)    -> "and"
  | CAnd(Some(v)) -> sprintf "and(%s)" (string_of_bool v)
  | COr(None)     -> "or"
  | COr(Some(v))  -> sprintf "or(%s)" (string_of_bool v)

  | CChar(c) -> String.make 1 c

  | CString(s) -> "\"" ^ s ^ "\""

  | CInt(v)       -> string_of_int v
  | CMod(None)    -> "mod"
  | CMod(Some(v)) -> sprintf "mod(%d)" v
  | CSll(None)    -> "sll"
  | CSll(Some(v)) -> sprintf "sll(%d)" v
  | CSrl(None)    -> "srl"
  | CSrl(Some(v)) -> sprintf "srl(%d)" v
  | CSra(None)    -> "sra"
  | CSra(Some(v)) -> sprintf "sra(%d)" v

  | CFloat(v) -> sprintf "%f" v
  | CLog      -> "log"

  | CAdd(Some(CInt(v)))   -> sprintf "add(%d)" v
  | CAdd(Some(CFloat(v))) -> sprintf "add(%f)" v
  | CAdd(None)            -> "add"
  | CAdd _                -> failwith "Not supported"
  | CSub(Some(CInt(v)))   -> sprintf "sub(%d)" v
  | CSub(Some(CFloat(v))) -> sprintf "sub(%f)" v
  | CSub(None)            -> "sub"
  | CSub _                -> failwith "Not supported"
  | CMul(Some(CInt(v)))   -> sprintf "mul(%d)" v
  | CMul(Some(CFloat(v))) -> sprintf "mul(%f)" v
  | CMul(None)            -> "mul"
  | CMul _                -> failwith "Not supported"
  | CDiv(Some(CInt(v)))   -> sprintf "div(%d)" v
  | CDiv(Some(CFloat(v))) -> sprintf "div(%f)" v
  | CDiv(None)            -> "div"
  | CDiv _                -> failwith "Not supported"
  | CNeg                  -> "neg"
  | CLt(Some(CInt(v)))    -> sprintf "lt(%d)" v
  | CLt(Some(CFloat(v)))  -> sprintf "lt(%f)" v
  | CLt(None)             -> "lt"
  | CLt _                 -> failwith "Not supported"
  | CLeq(Some(CInt(v)))   -> sprintf "leq(%d)" v
  | CLeq(Some(CFloat(v))) -> sprintf "leq(%f)" v
  | CLeq(None)            -> "leq"
  | CLeq _                -> failwith "Not supported"
  | CGt(Some(CInt(v)))    -> sprintf "gt(%d)" v
  | CGt(Some(CFloat(v)))  -> sprintf "gt(%f)" v
  | CGt(None)             -> "gt"
  | CGt _                 -> failwith "Not supported"
  | CGeq(Some(CInt(v)))   -> sprintf "geq(%d)" v
  | CGeq(Some(CFloat(v))) -> sprintf "geq(%f)" v
  | CGeq(None)            -> "geq"
  | CGeq _                -> failwith "Not supported"

  | CEq(None)     -> "eq"
  | CEq(Some(v))  -> "eq(" ^ (string_of_const v) ^ ")"
  | CNeq(None)    -> "neq"
  | CNeq(Some(v)) -> "neq(" ^ (string_of_const v) ^ ")"

  | CNormal(None,None)       -> "normal"
  | CNormal(Some f1,None)    -> sprintf "normal(%f)" f1
  | CNormal(Some f1,Some f2) -> sprintf "normal(%f,%f)" f1 f2
  | CNormal _                -> failwith "Not supported"

  | CUniform(None,None)       -> "uniform"
  | CUniform(Some f1,None)    -> sprintf "uniform(%f)" f1
  | CUniform(Some f1,Some f2) -> sprintf "uniform(%f,%f)" f1 f2
  | CUniform _                -> failwith "Not supported"

  | CGamma(None,None)       -> "gamma"
  | CGamma(Some f1,None)    -> sprintf "gamma(%f)" f1
  | CGamma(Some f1,Some f2) -> sprintf "gamma(%f,%f)" f1 f2
  | CGamma _                -> failwith "Not supported"

  | CExp(None)   -> "exp"
  | CExp(Some f) -> sprintf "exp(%f)" f

  | CBern(None)   -> "bern"
  | CBern(Some f) -> sprintf "bern(%f)" f

  | CLogPdf(None) -> "logpdf"
  | CLogPdf(Some c) -> sprintf "logpdf(%s)" (string_of_const c)

  | CSample -> "sample"

(** Error message for incorrect constant applications *)
let fail_constapp left right =
    failwith (sprintf "Incorrect constant application:\
                       LHS: %s\n\
                       RHS: %s\n"
                (string_of_const left) (string_of_const right))


(** Whether to use a random seed or not for probability distributions *)
let random_seed = false

(** Gsl default seed **)
let seed =
  let rng = Gsl.Rng.make (Gsl.Rng.default ()) in
  if random_seed then
    (Random.self_init();
     Gsl.Rng.set rng (Random.nativeint Nativeint.max_int));
  rng

(** Probability density/mass functions for built in distributions. *)
let logpdf value dist = match value,dist with

  (* Normal distribution *)
  | CFloat(v),
    CNormal(Some mu,Some sigma) ->
    CFloat(log (Gsl.Randist.gaussian_pdf (v -. mu) ~sigma:sigma))

  (* Exponential distribution *)
  | CFloat(v),
    CExp Some lambda ->
    let mu = 1.0 /. lambda in
    CFloat(log (Gsl.Randist.exponential_pdf v ~mu:mu))

  (* Bernoulli distribution *)
  | CBool(v),
    CBern Some p ->
    let i = if v then 1 else 0 in
    CFloat(log (Gsl.Randist.bernoulli_pdf i ~p:p))

  (* Gamma distribution *)
  | CFloat(v),
    CGamma(Some b, Some a) ->
    CFloat(log (Gsl.Randist.gamma_pdf v ~a:a ~b:b))

  | _ -> failwith "Incorrect distribution\
                   or value applied as argument to logpdf"

(** Sample functions for built in distributions. **)
let sample dist = match dist with

  (* Normal distribution *)
  | CNormal(Some mu,Some sigma) ->
    let sample = CFloat(mu +. Gsl.Randist.gaussian seed ~sigma:sigma) in
    sample

  (* Exponential distribution *)
  | CExp Some lambda ->
    let mu = 1.0 /. lambda in
    CFloat(Gsl.Randist.exponential seed ~mu:mu)

  (* Bernoulli distribution *)
  | CBern Some p ->
    let b = Gsl.Randist.bernoulli seed ~p:p == 1 in
    CBool(b)

  (* Gamma distribution *)
  | CGamma(Some a,Some b) ->
    CFloat(Gsl.Randist.gamma seed ~a:a ~b:b)

  | _ -> failwith "Incorrect distribution applied as argument to sample."


(* Evaluate constant applications *)
let eval_const c v  = match c,v with

  (* Unit constant *)
  | CUnit,_ -> fail_constapp c v

  (* Boolean constant and operations *)
  | CBool _,_ -> fail_constapp c v

  | CNot,CBool(v) -> CBool(not v)
  | CNot,_        -> fail_constapp c v

  | CAnd(None),CBool(v)      -> CAnd(Some(v))
  | CAnd(Some(v1)),CBool(v2) -> CBool(v1 && v2)
  | CAnd _,_                 -> fail_constapp c v

  | COr(None),CBool(v)      -> COr(Some(v))
  | COr(Some(v1)),CBool(v2) -> CBool(v1 || v2)
  | COr _,_                 -> fail_constapp c v

  (* Character constant and operations *)
  | CChar _,_ -> fail_constapp c v

  (* String constant and operations *)
  | CString _,_ -> fail_constapp c v

  (* Integer constant and operations *)
  | CInt _,_ -> fail_constapp c v

  | CMod(None),CInt(v)      -> CMod(Some(v))
  | CMod(Some(v1)),CInt(v2) -> CInt(v1 mod v2)
  | CMod _,_                -> fail_constapp c v

  | CSll(None),CInt(v)      -> CSll(Some(v))
  | CSll(Some(v1)),CInt(v2) -> CInt(v1 lsl v2)
  | CSll _,_                -> fail_constapp c v

  | CSrl(None),CInt(v)      -> CSrl(Some(v))
  | CSrl(Some(v1)),CInt(v2) -> CInt(v1 lsr v2)
  | CSrl _,_                -> fail_constapp c v

  | CSra(None),CInt(v)      -> CSra(Some(v))
  | CSra(Some(v1)),CInt(v2) -> CInt(v1 asr v2)
  | CSra _,_                -> fail_constapp c v

  (* Floating-point number constant and operations *)
  | CFloat(_),_ -> fail_constapp c v

  | CLog,CFloat(v) -> CFloat(log v)
  | CLog,_ -> fail_constapp c v

  (* Polymorphic integer/floating-point functions *)
  | CAdd(None),CInt(v)                -> CAdd(Some(CInt(v)))
  | CAdd(None),CFloat(v)              -> CAdd(Some(CFloat(v)))
  | CAdd(Some(CInt(v1))),CInt(v2)     -> CInt(v1 + v2)
  | CAdd(Some(CFloat(v1))),CFloat(v2) -> CFloat(v1 +. v2)
  | CAdd(Some(CFloat(v1))),CInt(v2)   -> CFloat(v1 +. (float_of_int v2))
  | CAdd(Some(CInt(v1))),CFloat(v2)   -> CFloat((float_of_int v1) +. v2)
  | CAdd(_),_                         -> fail_constapp c v

  | CSub(None),CInt(v)                -> CSub(Some(CInt(v)))
  | CSub(None),CFloat(v)              -> CSub(Some(CFloat(v)))
  | CSub(Some(CInt(v1))),CInt(v2)     -> CInt(v1 - v2)
  | CSub(Some(CFloat(v1))),CFloat(v2) -> CFloat(v1 -. v2)
  | CSub(Some(CFloat(v1))),CInt(v2)   -> CFloat(v1 -. (float_of_int v2))
  | CSub(Some(CInt(v1))),CFloat(v2)   -> CFloat((float_of_int v1) -. v2)
  | CSub(_),_                         -> fail_constapp c v

  | CMul(None),CInt(v)                -> CMul(Some(CInt(v)))
  | CMul(None),CFloat(v)              -> CMul(Some(CFloat(v)))
  | CMul(Some(CInt(v1))),CInt(v2)     -> CInt(v1 * v2)
  | CMul(Some(CFloat(v1))),CFloat(v2) -> CFloat(v1 *. v2)
  | CMul(Some(CFloat(v1))),CInt(v2)   -> CFloat(v1 *. (float_of_int v2))
  | CMul(Some(CInt(v1))),CFloat(v2)   -> CFloat((float_of_int v1) *. v2)
  | CMul(_),_                         -> fail_constapp c v

  | CDiv(None),CInt(v)                -> CDiv(Some(CInt(v)))
  | CDiv(None),CFloat(v)              -> CDiv(Some(CFloat(v)))
  | CDiv(Some(CInt(v1))),CInt(v2)     -> CInt(v1 / v2)
  | CDiv(Some(CFloat(v1))),CFloat(v2) -> CFloat(v1 /. v2)
  | CDiv(Some(CFloat(v1))),CInt(v2)   -> CFloat(v1 /. (float_of_int v2))
  | CDiv(Some(CInt(v1))),CFloat(v2)   -> CFloat((float_of_int v1) /. v2)
  | CDiv(_),_                         -> fail_constapp c v

  | CNeg,CFloat(v) -> CFloat((-1.0)*.v)
  | CNeg,CInt(v)   -> CInt((-1)*v)
  | CNeg,_         -> fail_constapp c v

  | CLt(None),CInt(v)                -> CLt(Some(CInt(v)))
  | CLt(None),CFloat(v)              -> CLt(Some(CFloat(v)))
  | CLt(Some(CInt(v1))),CInt(v2)     -> CBool(v1 < v2)
  | CLt(Some(CFloat(v1))),CFloat(v2) -> CBool(v1 < v2)
  | CLt(Some(CFloat(v1))),CInt(v2)   -> CBool(v1 < (float_of_int v2))
  | CLt(Some(CInt(v1))),CFloat(v2)   -> CBool((float_of_int v1) < v2)
  | CLt _,_                          -> fail_constapp c v

  | CLeq(None),CInt(v)                -> CLeq(Some(CInt(v)))
  | CLeq(None),CFloat(v)              -> CLeq(Some(CFloat(v)))
  | CLeq(Some(CInt(v1))),CInt(v2)     -> CBool(v1 <= v2)
  | CLeq(Some(CFloat(v1))),CFloat(v2) -> CBool(v1 <= v2)
  | CLeq(Some(CFloat(v1))),CInt(v2)   -> CBool(v1 <= (float_of_int v2))
  | CLeq(Some(CInt(v1))),CFloat(v2)   -> CBool((float_of_int v1) <= v2)
  | CLeq _,_                          -> fail_constapp c v

  | CGt(None),CInt(v)                -> CGt(Some(CInt(v)))
  | CGt(None),CFloat(v)              -> CGt(Some(CFloat(v)))
  | CGt(Some(CInt(v1))),CInt(v2)     -> CBool(v1 > v2)
  | CGt(Some(CFloat(v1))),CFloat(v2) -> CBool(v1 > v2)
  | CGt(Some(CFloat(v1))),CInt(v2)   -> CBool(v1 > (float_of_int v2))
  | CGt(Some(CInt(v1))),CFloat(v2)   -> CBool((float_of_int v1) > v2)
  | CGt _,_                          -> fail_constapp c v

  | CGeq(None),CInt(v)                -> CGeq(Some(CInt(v)))
  | CGeq(None),CFloat(v)              -> CGeq(Some(CFloat(v)))
  | CGeq(Some(CInt(v1))),CInt(v2)     -> CBool(v1 >= v2)
  | CGeq(Some(CFloat(v1))),CFloat(v2) -> CBool(v1 >= v2)
  | CGeq(Some(CFloat(v1))),CInt(v2)   -> CBool(v1 >= (float_of_int v2))
  | CGeq(Some(CInt(v1))),CFloat(v2)   -> CBool((float_of_int v1) >= v2)
  | CGeq _,_                          -> fail_constapp c v

  (* Polymorphic functions *)
  | CEq(None),c      -> CEq(Some(c))
  | CEq(Some c1), c2 -> CBool(c1 = c2)

  | CNeq(None),c      -> CNeq(Some(c))
  | CNeq(Some(c1)),c2 -> CBool(c1 <> c2)

  (* Probability distributions *)
  | CNormal(None,None),CFloat(f)     -> CNormal(Some f,None)
  | CNormal(None,None),CInt(i)       -> CNormal(Some (float_of_int i),None)
  | CNormal(Some f1,None),CFloat(f2) -> CNormal(Some f1,Some f2)
  | CNormal(Some f1,None),CInt(i2)   -> CNormal(Some f1,Some (float_of_int i2))
  | CNormal _,_                      -> fail_constapp c v

  | CUniform(None,None),CFloat(f)     -> CUniform(Some f,None)
  | CUniform(None,None),CInt(i)       -> CUniform(Some (float_of_int i),None)
  | CUniform(Some f1,None),CFloat(f2) -> CUniform(Some f1, Some f2)
  | CUniform(Some f1,None),CInt(i2)   -> CUniform(Some f1,Some(float_of_int i2))
  | CUniform _,_                      -> fail_constapp c v

  | CGamma(None,None),CFloat(f)     -> CGamma(Some f,None)
  | CGamma(None,None),CInt(i)       -> CGamma(Some (float_of_int i),None)
  | CGamma(Some f1,None),CFloat(f2) -> CGamma(Some f1, Some f2)
  | CGamma(Some f1,None),CInt(i2)   -> CGamma(Some f1, Some (float_of_int i2))
  | CGamma _,_                      -> fail_constapp c v

  | CExp(None),CFloat(f) -> CExp(Some(f))
  | CExp(None),CInt(i)   -> CExp(Some (float_of_int i))
  | CExp _,_             -> fail_constapp c v

  | CBern(None),CFloat(f) -> CBern(Some(f))
  | CBern(None),CInt(i)   -> CBern(Some (float_of_int i))
  | CBern _,_             -> fail_constapp c v

  | CLogPdf(None),v1      -> CLogPdf(Some v1)
  | CLogPdf(Some v1),v2   -> logpdf v1 v2

  | CSample,dist        -> sample dist
