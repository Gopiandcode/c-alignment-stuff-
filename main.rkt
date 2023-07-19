#lang racket

(require racket/gui/easy
         racket/gui/easy/operator)

(define @counter (@ 0))

(define-syntax-rule (c:struct name fields) #`(c:struct #,name #,fields))
(define (c:field name ty) #`(c:field #,name #,ty))

(define (c:define name args ret-ty))

(define data-structure-definition
"struct list {
     int value;
     struct list *next;
};

struct list *of_data(int *data, size_t size) {
   struct list *head = NULL;
   for(size_t start = size - 1; start >= 0; start--) {
       struct list *node = (struct list *)malloc(sizeof(*head));
       node->value = data[start];
       node->next = head;
       head = node;
   }
   return head;
}

struct list *print(struct list *ls) {
   if(ls != NULL) {
      printf(\"%d\", ls->value);
      ls = ls->next;
   }
   while(ls != NULL) {
      printf(\", %d\", ls->value);
      ls = ls->next;
   }
}")


(define main-program-definition
"void reverse_list(struct list *ls) {
   if(ls != NULL) {
      struct list *current = ls, *prev = NULL, *next = NULL;
      while(current != NULL) {
          next = current->next;
          current->next = prev;
          prev = current;
          current = next;
      }
   }
}")


(define (code-input-panel label)
  (vpanel
   (text label)
   (input "void reverse_list(struct list* ls) {
        struct list 
}"
          #:stretch '(#t #t))))


(render
 (window
  #:size '(#f 300)
  (code-input-panel "Definitions")
  (hpanel
   (code-input-panel "Main Program")
   (code-input-panel "Reference Program"))
  ))
