type system =
  {
    rules : Graph.graph ;
    truths : Graph.Ands.t ;
    queries : Graph.Facts.t list ;
  }

  let empty =
  {
    rules = [] ;
    truths = Graph.Ands.empty ;
    queries = [] ;
  }

(* DUMMY SYSTEM *)

(* let dummy_graph =
  [
    (
      Graph.Ors.(empty
            |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'A') |> add (Graph.Facts.Fact 'C'))
            |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'A') |> add (Graph.Facts.Fact 'D'))
            |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'B') |> add (Graph.Facts.Fact 'C'))
            |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'B') |> add (Graph.Facts.Fact 'D')))
      ,
      [
      ]
    )
    ;
    (
      Graph.Ors.(empty
            |> add (Graph.Ands.singleton (Graph.Facts.Fact 'E'))
            |> add (Graph.Ands.singleton (Graph.Facts.Fact 'F')))
      ,
      [
        Graph.Ors.(empty
              |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'A') |> add (Graph.Facts.Fact 'C'))
              |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'A') |> add (Graph.Facts.Fact 'D'))
              |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'B') |> add (Graph.Facts.Fact 'C'))
              |> add Graph.Ands.(empty |> add (Graph.Facts.Fact 'B') |> add (Graph.Facts.Fact 'D')))
      ]
    )
    ;
    (
      Graph.Ors.singleton (Graph.Ands.(empty |> add (Graph.Facts.Fact 'G') |> add (Graph.Facts.Fact 'H')))
      ,
      [
        Graph.Ors.(empty |> add (Graph.Ands.singleton (Graph.Facts.Fact 'E')) |> add (Graph.Ands.singleton (Graph.Facts.Fact 'F')))
      ]
    )
  ]

let dummy_truth = Graph.Ands.(empty |> add (Graph.Facts.Fact 'A') |> add (Graph.Facts.Fact 'D') |> add (Graph.Facts.Fact 'J'))
let dummy_query = [Graph.Facts.Fact 'G']  

let dummy_system =
  {
    rules = dummy_graph ; 
    truths = dummy_truth ;
    queries = dummy_query ;
  } *)

(* END OF DUMMY SYSTEM *)

let rec string_of_queries queries =
  match queries with
  | [] -> ""
  | fact :: [] -> Graph.string_of_fact fact
  | fact :: tl -> Graph.string_of_fact fact ^ ", " ^ string_of_queries tl


let string_of_system (s : system) =
  "\n\n\n======EXPERT SYSTEM=====\n\ngraph:\n" ^ Graph.string_of_graph s.rules
  ^ "\ntruths: " ^ Graph.string_of_and s.truths
  ^ "\n\nqueries: " ^ string_of_queries s.queries

let expand_system (s : system) =
  {s with rules = Graph.expand_graph (s.rules)}