module Facts =
struct
  type t = Fact of char | NotFact of char
  let compare t1 t2 =
    match (t1, t2) with
    | (Fact f1, Fact f2) -> Pervasives.compare f1 f2
    | (NotFact f1, NotFact f2) -> Pervasives.compare f1 f2
    | (Fact f1, NotFact f2) -> -1
    | (NotFact f1, Fact f2) -> 1
end

module Ands = Set.Make(Facts) (* était vertex*)
module Ors = Set.Make(Ands) (* était edge*)
module Conditions = Set.Make(Ors)
type adjacency = Ors.t * Conditions.t
type graph = adjacency list

(*  **************  SERIALIZATION  *************** *)

let string_of_fact f =
  match f with
  | Facts.Fact f -> String.make 1 f
  | Facts.NotFact f -> "!" ^ String.make 1 f

let string_of_and a =
  let rec aux lst =
    match lst with
    | [] -> ""
    | fact :: [] -> string_of_fact fact
    | fact :: tl -> string_of_fact fact ^ "+" ^ aux tl
  in aux (Ands.elements a)

let string_of_or o =
  let rec aux lst =
    match lst with
    | [] -> ""
    | a :: [] -> string_of_and a
    | a :: tl -> string_of_and a ^ " | " ^ aux tl
  in aux (Ors.elements o)

let string_of_adjacency ((conclusion, conditions) : adjacency) =
  let rec string_of_conditions lst = match lst with
    | [] -> "$\n"
    | a :: tl -> string_of_or a ^ " --> " ^ string_of_conditions tl in
  string_of_or conclusion ^ " --> " ^ string_of_conditions (Conditions.elements conditions)

let string_of_graph (g : graph) =
  let lst = List.map string_of_adjacency g in
  List.fold_left (^) "" lst


(*  **************  UPDATES  *************** *)

let ors_of_char c : Ors.t =
  Ors.singleton (Ands.singleton (Fact c))

let union_ors a b : Ors.t =
  Ors.union a b 

let intersection_ors a b : Ors.t =
  let a_elts = Ors.elements a in
  let combine elt = List.map (Ands.union elt) a_elts in
  let combination_list = List.flatten (List.map combine (Ors.elements b)) in
  Ors.of_list combination_list

let not_of_ors ors =
  let not_of_fact fact = match fact with
  | Facts.Fact f -> Facts.NotFact f
  | Facts.NotFact f -> Facts.Fact f in
  let facts_of_or_elt e : Facts.t list = Ands.elements e in
  let not_facts_of_or_elt e = List.map not_of_fact (facts_of_or_elt e) in
  let ors_of_non_facts e = List.map (fun elt -> Ors.singleton (Ands.singleton elt)) (not_facts_of_or_elt e) in
  let union_of_non_facts e = List.fold_left (Ors.union) Ors.empty (ors_of_non_facts e) in
  let list_of_not_unions = List.map union_of_non_facts (Ors.elements ors) in
  List.fold_left intersection_ors (List.hd list_of_not_unions) list_of_not_unions

let xor_ors a b =
  union_ors (intersection_ors a (not_of_ors b)) (intersection_ors (not_of_ors a) b)

let add_adjacency graph condition conclusion : graph =
  let is_conclusion (conc, _) = (conc = conclusion) in
  let (satisfies, not_satisfies) = List.partition is_conclusion graph in
  let new_adjacerncy = match satisfies with
  | [] -> (conclusion, Conditions.singleton condition)
  | (_, old_conditions) :: tl -> (conclusion, (Conditions.union old_conditions (Conditions.singleton condition)))
  in new_adjacerncy :: not_satisfies


(* let create_edge graph vertex edge =



   let rec update_graph graph vertex edge : graph =
    let (t, tail) = List.partition (fun (a, b) -> a = truth) graph in
    let new_truth = match t with
      | [] -> (vertex, [edge]) :: graph
      | (_, i) :: _ -> (vertex, edge :: i) :: graph
    in new_truth :: tail

   and create_

   and update_truth graph vertex edge =
    match vertex with
    | Facts.Fact _ -> (vertex, []) :: graph
    | Or lst ->
      begin
        let fact_list : edge list = lst in
        (vertex, lst) :: graph
      end

   (* and create_or graph vertex (lst : fact list) : graph =
   let implication_list = List.map (fun f -> Fa)
   List.fold_left create_truth_if_necessary  *)




   let add_implication (graph : graph) vertex edge : graph =
   let graph = add_truth_if_necessary graph vertex in

   let filter_fun = fun (a, b) -> a = vertex in
   let (is_truth, other) = List.partition filter_fun graph in
   if is_truth = [] then graph @ [(vertex, [edge])]
   else
    let (_, i) = List.hd is_truth in
    other @ [(vertex, i @ [edge])] *)