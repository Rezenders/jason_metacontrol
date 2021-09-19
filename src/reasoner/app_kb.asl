/* Initial beliefs and rules */
function(f_navigate, navigate).

function_design(f1_v1_r1, f_navigate).
function_design_qa(f1_v1_r1, safety, 0.5).
function_design_qa(f1_v1_r1, energy, 0.5).

function_design(f2_v1_r1, f_navigate).
function_design_qa(f2_v1_r1, safety, 0.3).
function_design_qa(f2_v1_r1, energy, 0.4).

function_design(f3_v1_r1, f_navigate).
function_design_qa(f3_v1_r1, safety, 0.0).
function_design_qa(f3_v1_r1, energy, 0.0).
//FIX:bugando qnd energy é 6.10e-10 como se n fosse maior q 0

qa(safety, 1). // Should the qa be initialized? 1? 0?
qa(energy, 1). // Should the qa be initialized? 1? 0?

objective(navigate).

/* Initial goals */
!stop_navigating.
/* Plans */

+!stop_navigating
    <-  .wait(15000);
        .print("Stoping navigation!!!!!");
        -objective(navigate).

{ include("tomasys.asl") }
