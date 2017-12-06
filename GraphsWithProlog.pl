/**************************************************************************************
*	Name:		Donald Tran															  *
*	AU User ID:	DZT0021																  *	
*	Course:		COMP3220															  *	
*	Date:		04/04/17															  *	
*																                      *	
* 	Description: a program in Prolog that will tell us how to 						  *	
*	get from one room of a one-story building, to any other room in 				  *
*	that building (if it’s possible), by telling us all of the rooms 				  *	
*	we must go through to get to the destination room. 								  *
*	In addition to the previous statement, there will be phones 					  *	
*	ringing in one or more of the rooms. Our prolog program should 					  *
*	ONLY tell us how to get to those rooms. If we attempt to go to 					  *	
*	a room that does not have a ringing phone, 										  *
*	the program should not produce any output. 										  *
*																					  *
*	Sources Cited: 																	  *
*	(1) http://rlgomes.github.io/work/prolog/2012/05/22/19.00-prolog-and-graphs.html  *	
*	(2) http://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15.html					  *
*	(3) http://stackoverflow.com/questions/26856662/how-to-check-if-				  *
*		the-paths-are-connected-between-rooms										  *	
*	(4) https://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/lists.html	  *
*	(5) http://stackoverflow.com/questions/13170401/find-all-possible-				  *
*		paths-without-revisiting													  *
**************************************************************************************/


/***********************************************************************************
* QUERY COMMANDS BASED ON RULES SET 1:											   *
*	(1) findapath(Start_Room_Number, End_Room_Number, My_Path, []).				   *	
*	(2) findminpath(Start_Room_Number, End_Room_Number, My_Path). 				   *	
*	(3) findmaxpath(Start_Room_Number, End_Room_Number, My_Path).				   *
***********************************************************************************/ 

/*************************************************************************************
* QUERY COMMANDS BASED ON RULES SET 2:												 *
*	(1) findapath(Start_Room_Number, End_Room_Number, Number_of_Moves, My_Path, []). *
*	(2) findminpath(Start_Room_Number, End_Room_Number, Number_of_Moves, My_Path).	 * 
*	(3) findmaxpath(Start_Room_Number, End_Room_Number, Number_of_Moves, My_Path).	 *
*************************************************************************************/ 



% FACTS: PHONE RINGING %%
ringing(5).
ringing(9).
ringing(16).


% FACTS: SET 1 (Excludes Number of Moves) %%
neighbor(1, 2).
neighbor(1, 7).
neighbor(2, 1).
neighbor(2, 8).
neighbor(3, 8).
neighbor(4, 8).
neighbor(4, 9).
neighbor(5, 9).
neighbor(6, 9).
neighbor(7, 1).
neighbor(7, 8).
neighbor(7, 9).
neighbor(7, 10).
neighbor(7, 11).
neighbor(7, 12).
neighbor(7, 13).
neighbor(7, 14).
neighbor(8, 2).
neighbor(8, 3).
neighbor(8, 4).
neighbor(8, 7).
neighbor(9, 4).
neighbor(9, 5).
neighbor(9, 6).
neighbor(9, 7).
neighbor(10, 7).
neighbor(11, 7).
neighbor(12, 7).
neighbor(13, 7).
neighbor(14, 7).
neighbor(14, 15).
neighbor(15, 14).
neighbor(15, 16).
neighbor(16, 15).


%% RULES: SET 1 %%
findapath(X, Y, [X,Y], _) :- neighbor(X, Y), ringing(Y).


findapath(X, Y, [X|P], V) :- \+ member(X, V),
                                 neighbor(X, Z),
                                 Z \== Y,
                                 findapath(Z, Y, P, [X|V]).

  
%% FACTS: SET 2 %%

neighbor(1, 2, 1).
neighbor(1, 7, 1).
neighbor(2, 1, 1).
neighbor(2, 8, 1).
neighbor(3, 8, 1).
neighbor(4, 8, 1).
neighbor(4, 9, 1).
neighbor(5, 9, 1).
neighbor(6, 9, 1).
neighbor(7, 1, 1).
neighbor(7, 8, 1).
neighbor(7, 9, 1).
neighbor(7, 10, 1).
neighbor(7, 11, 1).
neighbor(7, 12, 1).
neighbor(7, 13, 1).
neighbor(7, 14, 1).
neighbor(8, 2, 1).
neighbor(8, 3, 1).
neighbor(8, 4, 1).
neighbor(8, 7, 1).
neighbor(9, 4, 1).
neighbor(9, 5, 1).
neighbor(9, 6, 1).
neighbor(9, 7, 1).
neighbor(10, 7, 1).
neighbor(11, 7, 1).
neighbor(12, 7, 1).
neighbor(13, 7, 1).
neighbor(14, 7, 1).
neighbor(14, 15, 1).
neighbor(15, 14, 1).
neighbor(15, 16, 1).
neighbor(16, 15, 1).


/**************************************************************************
 *	RULES: SET 2 (Includes Number of Moves or Weight (W) between nodes    *
 *		  Used as a counter).											  *
 *************************************************************************/

findapath(X, Y, W, [X,Y], _) :- neighbor(X, Y, W), ringing(Y).			  


findapath(X, Y, W, [X|P], V) :- \+ member(X, V),
                                 neighbor(X, Z, W1),
                                 Z \== Y,
                                 findapath(Z, Y, W2, P, [X|V]),
                                 W is W1 + W2.
:-dynamic(solution/2).
findminpath(X, Y, W, P) :- \+ solution(_, _),
                           findapath(X, Y, W1, P1, []),
                           assertz(solution(W1, P1)),
                           !,
                           findminpath(X,Y,W,P).

findminpath(X, Y, _, _) :- findapath(X, Y, W1, P1, []),
                           solution(W2, P2),
                           W1 < W2,
                           retract(solution(W2, P2)),
                           asserta(solution(W1, P1)),
                           fail.

findminpath(_, _, W, P) :- solution(W,P), retract(solution(W,P)).


:-dynamic(solution/2).
findmaxpath(X, Y, W, P) :- \+ solution(_, _),
                           findapath(X, Y, W1, P1, []),
                           assertz(solution(W1, P1)),
                           !,
                           findmaxpath(X,Y,W,P).

findmaxpath(X, Y, _, _) :- findapath(X, Y, W1, P1, []),
                           solution(W2, P2),
                           W1 > W2,
                           retract(solution(W2, P2)),
                           asserta(solution(W1, P1)),
                           fail.

findmaxpath(_, _, W, P) :- solution(W,P), retract(solution(W,P)).

