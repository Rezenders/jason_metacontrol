/* Initial beliefs and rules */
function(f_pick_place, pick_place).

function_design(fd_pick_place_2_arms, f_pick_place).
function_design_qa(fd_pick_place_2_arms, left_arm_safe, 1).
function_design_qa(fd_pick_place_2_arms, right_arm_safe, 1).

function_design(fd_pick_place_left_arm, f_pick_place).
function_design_requires(fd_pick_place_left_arm, move_position).
function_design_qa(fd_pick_place_left_arm, left_arm_safe, 1).
function_design_qa(fd_pick_place_left_arm, right_arm_safe, 0).

function_design(fd_pick_place_right_arm, f_pick_place).
function_design_requires(fd_pick_place_right_arm, move_position).
function_design_qa(fd_pick_place_right_arm, left_arm_safe, 0).
function_design_qa(fd_pick_place_right_arm, right_arm_safe, 1).

function(f_move_position, move_position).
function_design(fd_move_relative_workcell, f_move_position).
function_design_requires(fd_move_relative_workcell, calibrate_position).

function(f_calibrate_position, calibrate_position).
function_design(fd_localize_tag, f_calibrate_position).
function_design_requires(fd_localize_tag, detect_tag).

function(f_detect_tag, detect_tag).
function_design(fd_tag_detection_1, f_detect_tag).
function_design(fd_tag_detection_2, f_detect_tag).

qa(left_arm_safe, 1). // Should the qa be initialized? 1? 0?
qa(right_arm_safe, 0). // Should the qa be initialized? 1? 0?

objective(pick_place).

/* Initial goals */
!pick.

/* Plans */
+!pick
  <-  .wait(7000);
      -qa(left_arm_safe, 1);
      -qa(right_arm_safe, 0);
      +qa(left_arm_safe, 0);
      +qa(right_arm_safe, 1).

{include("tomasys.asl")}
