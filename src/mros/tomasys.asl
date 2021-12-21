// Event triggered when new objective is set
+objective(Objective): function(Function, Objective) // what if there are more than 1 Function mapping to objective?
  <-  .findall(Fd, function_design(Fd, Function), Fd_list);
      !!select_function_design(Fd_list, Function).

// Event triggered when new objective is removed
-objective(Objective): function(Function, Objective) & function_grouding(Fd, Function)
  <-  stop_configuration(Fd);
      -function_grouding(Fd, Function).

// Event triggered when function_grouding is removed
// Remove all objectives that were added by this function_grouding
-function_grouding(Fd, Function): objective(Objective)[Fd]
  <-  .findall(objective(Obj)[Fd], objective(Obj)[Fd], LObj);
      for (.member(O, LObj)) {
          .abolish(O);
      }.

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
          CurrentValue >= QAValue;
      }.

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective) & objective(Objective) & function(Function, Objective) & function_grouding(Fd, Function).

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective) & function(Function, Objective)
  <-  +objective(Objective)[Fd];
      .wait(function_grouding(_, Function)). //TODO: Add timeout (i think the plan fails when a timeout occurs)

+!test_function_design_requirements(Fd): function_design_requires(Fd, Objective)
  <-  .print("There is no Function that solves the objective: ", Objective).

+!test_function_design_requirements(Fd).

+diagnostics(KeyValuesVector)
  <-  !update_qas(KeyValuesVector).

+!update_qas([H | T]): .list(H) & not H=[Key, Value]
  <-  !update_qas(H);
      !update_qas(T).

+!update_qas([H | T])
  <-  H=[Key, Value];
      !update_single_qa(Key, Value);
      !update_qas(T).

+!update_qas([]).

//Should be atomic?
@update_single_qa[atomic]
+!update_single_qa(Key, Value): .string(Key) & not qa(Key, Value)
  <-  .abolish(qa(Key,_));
      +qa(Key, Value).

@update_single_qa2[atomic]
+!update_single_qa(Key, Value): not .string(Key) & .term2string(Key, KeyString) & not qa(KeyString, Value)
  <-  .abolish(qa(KeyString,_));
      +qa(KeyString, Value).

+!update_single_qa(Key, Value).

+qa(Key, Value)
  <-  .findall(Fd, function_design_qa(Fd, Key,_) & function_grouding(Fd, _), Fd_list); // Find all function groundings that have a QA with Key
      !reevaluate_function_groudings(Fd_list).

// Check if FG conditions still stands
+!reevaluate_function_groudings([H|T])
  <-  !test_function_grouding(H);
      !reevaluate_function_groudings(T).

+!reevaluate_function_groudings([]).

//TODO: use jason3 features? is this a sub-goal?
+!test_function_grouding(Fg)
  <-  !test_function_design(Fg).
      // !test_function_design_requirements(H); //TODO: is this necessary here?

// TODO: should the function grounding be removed here?
// TODO: this plan seems weird, should it only remove the fg and the rest is triggered by the event?
-!test_function_grouding(Fg)
  <-  ?function_grouding(Fg, Function);
      .findall(Fd, function_design(Fd, Function), Fd_list);
      !!select_function_design(Fd_list, Function).

//Reconfiguration plans
+!reconfigure(Fd, Function): (function_grouding(LastFd, Function) & LastFd \== Fd) | not function_grouding(LastFd, Function)
  <-  .print("Reconfiguring ", Fd);
      reconfigure(Fd);
      .abolish(function_grouding(_, Function));
      +function_grouding(Fd, Function).

+!reconfigure(Fd, Function).
