// Event triggered when new objective is set
+objective(Objective): function(Function, Objective) // what if there are more than 1 Function mapping to objective?
    <-  .findall(Fd, function_design(Fd, Function), Fd_list);
        !!select_function_design(Fd_list, Function).

-objective(Objective): function(Function, Objective) & function_grouding(Fd, Function)
    <-  -function_grouding(Fd, Function);
        stop_configuration(Fd).

// Select a FD that satisfies the QA values, it chooses in the order defined in the BB
+!select_function_design([Head|Tail], Function)
    <-  !test_function_design(Head);
        !test_function_design_requirements(Head);
        !reconfigure(Head, Function).

+!select_function_design([], Function) <- .print("No function design available").

-!select_function_design([Head|Tail], Function) <- !select_function_design(Tail, Function).

+!test_function_design(Fd)
    <-  for(function_design_qa(Fd, QA, QAValue)){
            ?qa(QA, CurrentValue); // TODO: What if there is no QA yet? Initialize with a default value?
            CurrentValue >= QAValue; // TODO: Is it greater or lower? Need to check in the paper
            // .print(CurrentValue >= QAValue);
        }.

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective) & objective(Objective) & function(Function, Objective) & function_grouding(Fd, Function).

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective) & function(Function, Objective)
    <-  +objective(Objective)[Fd];
        .wait(function_grouding(_, Function)). //TODO: Add timeout (i think the plan fails when a timeout occurs)
    // TODO: objective must be removed when FD is removed

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective)
  <-  .print("There is no Function that solves the objective: ", Objective).

+!test_function_design_requirements(Fd).

// Event Triggered when new diagnostic is percepted
+diagnostics([[[Key, Value]]]) : not qa(Key, Value)
    <-  .abolish(qa(Key, _));
        +qa(Key, Value).

+diagnostics([[[Key, Value]]]).

+qa(Key, Value)
  <- !reevaluate_function_groudings.

// Check if FG conditions still stands
+!reevaluate_function_groudings
    <-  for(function_grouding(Fg, Function)){
            !test_function_grouding(Fg, Function);
        }.

+!test_function_grouding(Fg, Function) <- !test_function_design(Fg).

-!test_function_grouding(Fg, Function)
    <-  .findall(Fd, function_design(Fd, Function), Fd_list);
        !!select_function_design(Fd_list, Function).

//Reconfiguration plans
+!reconfigure(Fd, Function): (function_grouding(LastFd, Function) & LastFd \== Fd) | not function_grouding(LastFd, Function)
    <-  .print("Reconfiguring ", Fd);
        reconfigure(Fd);
        .abolish(function_grouding(_, Function));
        +function_grouding(Fd, Function).

+!reconfigure(Fd, Function).
