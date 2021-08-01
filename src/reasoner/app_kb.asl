/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+diagnostics([[[Key, Value]]])
    <-  .abolish(qa(Key, _));
        +qa(Key, Value);
        !try_reconfigure.

+!try_reconfigure : qa(safety, S) & qa(energy, E) & S> 0.5 & E>0.5
    <-  !reconfigure("f1_v1_r1").

+!try_reconfigure : qa(safety, S) & qa(energy, E) & S> 0.3 & E>0.4
    <-  !reconfigure("f2_v1_r1").

+!try_reconfigure
    <-  !reconfigure("f3_v1_r1").

+!reconfigure(R): (last_config(LC) & LC \== R) | not last_config(LC)
    <-  .print("Reconfiguring ", R);
        reconfigure(R);
        .abolish(last_config(_));
        +last_config(R).

+!reconfigure(R).
