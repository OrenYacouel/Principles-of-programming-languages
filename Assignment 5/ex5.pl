/*
 * **********************************************
 * Printing result depth
 *
 * You can enlarge it, if needed.
 * **********************************************
 */
maximum_printing_depth(100).

:- current_prolog_flag(toplevel_print_options, A),
   (select(max_depth(_), A, B), ! ; A = B),
   maximum_printing_depth(MPD),
   set_prolog_flag(toplevel_print_options, [max_depth(MPD)|B]).

% Signature: unique(List, UniqueList, Dups)/3
% Purpose: succeeds if and only if UniqueList contains the same elements of List without duplicates (according to their order in List), and Dups contains the duplicates

member(X,[X|_Xs]).
member(Y,[_X|Xs]):- member(Y,Xs).
not_member(_X,[]).
not_member(Y,[X|Xs]):- X \= Y ,not_member(Y, Xs).

unique(List, Unique_list, Dups) :- nicky_uniquey(List, Unique_list, Dups, []).
nicky_uniquey([],[],[],_Unique_acc).
nicky_uniquey([X|Xs],[X|Ys],Zs,Unique_acc):- nicky_uniquey(Xs,Ys,Zs,[X|Unique_acc]), not_member(X,Ys).
nicky_uniquey([X|Xs],Ys,[X|Zs],Unique_acc):- nicky_uniquey(Xs,Ys,Zs,Unique_acc), member(X,Unique_acc).
                 

