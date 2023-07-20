[@@@warning "-33-32"]
open Brr

let c_program = {|
struct list *reverse(struct list *ls) {
  if (ls == NULL) {
    return NULL;
  }

  struct list *current = ls, *prev = NULL, *next = NULL;
  while(current != NULL) {
     next = current->next;
     current->next = prev;
     prev = current;
     current = next;
  }
  return prev;
}|}

let c_ref_program = {|
struct list *traverse(struct list *ls) {
  if (ls == NULL) {
    return NULL;
  }

  while(ls != NULL) {
     ls = ls->next;
  }
}|}

let c_definitions_program = {|
struct list {
   int value;
   struct list *next;
};

void print(struct list *ls) {
  printf("[");
  if(ls != NULL) {
      printf("%d", ls->value);
      ls = ls->next;
  }
  while(ls != NULL) {
     printf(", %d", ls->value);
     ls = ls->next;
  }
  printf("]\n");
}
|}

let main_program = {|


int main() {
  srand(100);
  struct list *example = NULL;
  while(rand() % 100 < 87) {
     struct list *head = malloc(sizeof(*head));
     head->value = rand() % 30;
     head->next = example;
     example = head;
  }
  print(example);
  traverse(example);
  example = reverse(example);
  print(example);
}
|}


let target_program =
  let editor = Ace.edit "target-program" in
  ignore @@ Ace.set_theme editor "ace/theme/monokai";
  ignore @@ Ace.set_mode (Ace.session editor) "ace/mode/c_cpp";
  ignore @@ Ace.set_value editor c_program;
  fun () -> Ace.get_value editor

let reference_program =
  let editor = Ace.edit "reference-program" in
  ignore @@ Ace.set_theme editor "ace/theme/monokai";
  ignore @@ Ace.set_mode (Ace.session editor) "ace/mode/c_cpp";
  ignore @@ Ace.set_value editor c_ref_program;
  fun () -> Ace.get_value editor

let definitions_program =
  let editor = Ace.edit "definitions-program" in
  ignore @@ Ace.set_theme editor "ace/theme/monokai";
  ignore @@ Ace.set_mode (Ace.session editor) "ace/mode/c_cpp";
  ignore @@ Ace.set_value editor c_definitions_program;
  fun () -> Ace.get_value editor



let () =
  let run_button = Brr.Document.find_el_by_id Brr.G.document (Jstr.v "run-code") |> Option.get in
  ignore @@ Ev.listen Ev.click (fun _ ->
    print_endline "Do something here...";
    let program =
      definitions_program ()
      ^ target_program ()
      ^ reference_program ()
      ^ main_program in
    Fut.await (Backend.run_program program) (fun result ->
      let response_box = Document.find_el_by_id G.document (Jstr.v "response-box") |> Option.get in
      El.set_children response_box [El.txt (Jstr.v result)];
    )
  ) (Brr.El.as_target run_button)

