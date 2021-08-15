/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

// Event triggered when new objective is set
+objective(Objective): function(Function, Objective) // what if there are more than 1 Function mapping to objective?
    <-  .findall(Fd, function_design(Fd, Function), Fd_list);
        !select_function_design(Fd_list, Function).

//TODO: if objective is removed remove function_grouding and stop function

// Select a FD that satisfies the QA values, it chooses in the order defined in the BB
+!select_function_design([Head|Tail], Function)
    <-  !test_function_design(Head);
        !reconfigure(Head, Function).

+!select_function_design([], Function) <- .print("No function design available").

-!select_function_design([Head|Tail], Function) <- !select_function_design(Tail, Function).

+!test_function_design(Fd)
    <-  for(function_design_qa(Fd, QA, QAValue)){
            ?qa(QA, CurrentValue); // What if there is no QA yet? Initialize with a default value?
            CurrentValue >= QAValue; // TODO: Is it greater or lower? Need to check in the paper
            .print(CurrentValue >= QAValue);
        }.

// Event Triggered when new diagnostic is percepted
+diagnostics([[[Key, Value]]])
    <-  .abolish(qa(Key, _));
        +qa(Key, Value);
        !reevaluate_function_groudings.

// Check if FG conditions still stands
+!reevaluate_function_groudings
    <-  for(function_grouding(Fd, Function)){
            !test_function_grouding(Fd, Function);
        }.

+!test_function_grouding(Fd, Function) <- !test_function_design(Fd).

-!test_function_grouding(Fd, Function)
    <-  .findall(Fd, function_design(Fd, Function), Fd_list);
        !select_function_design(Fd_list, Function).

//Reconfiguration plans
+!reconfigure(Fd, Function): (function_grouding(LastFd, Function) & LastFd \== Fd) | not function_grouding(LastFd, Function)
    <-  .print("Reconfiguring ", Fd);
        reconfigure(Fd);
        .abolish(function_grouding(_, Function));
        +function_grouding(Fd, Function).

+!reconfigure(Fd, Function).
