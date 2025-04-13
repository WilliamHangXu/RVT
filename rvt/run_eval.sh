# export CUDA_VISIBLE_DEVICES=1
export DEMO_PATH=/home/hangxu/RVT/rvt/data/test_256
export eval_episodes=25
export eval_dir=1
export DISPLAY=:99

trap "echo 'Script interrupted'; exit" SIGINT SIGQUIT

# python eval.py \
#     --model-folder runs/rvt2  \
#     --eval-datafolder $DEMO_PATH \
#     --tasks all \
#     --eval-episodes 25 \
#     --log-name test/1 \
#     --device 0 \
#     --headless \
#     --model-name model_99.pth \
#     --add-mask

# Define your task lists
box_tasks=("close_box_1" "close_box_2" "close_box_6" "close_box_8" "close_box_9" "close_box_10" "close_box_11" "close_box_12" "close_box_13" "close_box_14" "close_box_15" "close_box_16" "close_box_17")
slide_tasks=("slide_block_to_target_0" "slide_block_to_target_1" "slide_block_to_target_2" "slide_block_to_target_4" "slide_block_to_target_8" "slide_block_to_target_9" "slide_block_to_target_10" "slide_block_to_target_11" "slide_block_to_target_12" "slide_block_to_target_13" "slide_block_to_target_14" "slide_block_to_target_15" "slide_block_to_target_16" "slide_block_to_target_17")
wine_tasks=("place_wine_at_rack_location_0" "place_wine_at_rack_location_1" "place_wine_at_rack_location_2" "place_wine_at_rack_location_3" "place_wine_at_rack_location_5" "place_wine_at_rack_location_6" "place_wine_at_rack_location_7" "place_wine_at_rack_location_8" "place_wine_at_rack_location_9" "place_wine_at_rack_location_10" "place_wine_at_rack_location_11" "place_wine_at_rack_location_12" "place_wine_at_rack_location_13" "place_wine_at_rack_location_14" "place_wine_at_rack_location_15" "place_wine_at_rack_location_16" "place_wine_at_rack_location_17")
rope_tasks=("straighten_rope_0" "straighten_rope_1" "straighten_rope_2" "straighten_rope_4" "straighten_rope_8" "straighten_rope_9" "straighten_rope_10" "straighten_rope_11" "straighten_rope_12" "straighten_rope_13" "straighten_rope_14" "straighten_rope_15" "straighten_rope_16" "straighten_rope_17")
scoop_tasks=("scoop_with_spatula_1" "scoop_with_spatula_2" "scoop_with_spatula_3" "scoop_with_spatula_4" "scoop_with_spatula_5" "scoop_with_spatula_6" "scoop_with_spatula_7" "scoop_with_spatula_8" "scoop_with_spatula_9" "scoop_with_spatula_10" "scoop_with_spatula_11" "scoop_with_spatula_12" "scoop_with_spatula_13" "scoop_with_spatula_14" "scoop_with_spatula_15" "scoop_with_spatula_16" "scoop_with_spatula_17")
cups_tasks=("stack_cups_0" "stack_cups_1" "stack_cups_2" "stack_cups_4" "stack_cups_6" "stack_cups_8" "stack_cups_9" "stack_cups_10" "stack_cups_12" "stack_cups_13" "stack_cups_14" "stack_cups_15" "stack_cups_16" "stack_cups_17")
laptop_tasks=("close_laptop_lid_0" "close_laptop_lid_1" "close_laptop_lid_2" "close_laptop_lid_6" "close_laptop_lid_8" "close_laptop_lid_9" "close_laptop_lid_10" "close_laptop_lid_11" "close_laptop_lid_12" "close_laptop_lid_13" "close_laptop_lid_14" "close_laptop_lid_15" "close_laptop_lid_16" "close_laptop_lid_17")
reach_tasks=("reach_and_drag_0" "reach_and_drag_1" "reach_and_drag_2" "reach_and_drag_3" "reach_and_drag_4" "reach_and_drag_5" "reach_and_drag_6" "reach_and_drag_7" "reach_and_drag_8" "reach_and_drag_9" "reach_and_drag_10" "reach_and_drag_11" "reach_and_drag_12" "reach_and_drag_13" "reach_and_drag_14" "reach_and_drag_15" "reach_and_drag_16" "reach_and_drag_17")

# Array containing the names of each task list
# task_list_names=("box_tasks" "slide_tasks" "wine_tasks" "rope_tasks" "scoop_tasks" "cups_tasks" "laptop_tasks" "reach_tasks")
task_list_names=("box_tasks")
# Optionally, if each task list requires a specific model folder, you can map them
declare -A model_folders=(
  [box_tasks]="runs/close_box_base_10"
  [slide_tasks]="runs/slide_block_base_15"
  [wine_tasks]="runs/place_wine_base_15"
  [rope_tasks]="runs/rope_base_15"
  [scoop_tasks]="runs/scoop_base_15"
  [cups_tasks]="runs/stack_cups_base_15"
  [laptop_tasks]="runs/close_laptop_base_15"
  [reach_tasks]="runs/reach_base_15"
)

# Outer loop: iterate over each task list name
for list_name in "${task_list_names[@]}"; do
  # Create a nameref (a reference) to the array using its name
  declare -n current_tasks="$list_name"
  echo "Processing tasks for $list_name"
  
  # Inner loop: iterate over each task in the current task list
  for task in "${current_tasks[@]}"; do
    python eval_var.py \
      --model-folder "${model_folders[$list_name]}" \
      --eval-datafolder "$DEMO_PATH" \
      --tasks "$task" \
      --eval-episodes "$eval_episodes" \
      --log-name test/"$eval_dir" \
      --device 1 \
      --headless \
      --model-name model_0.pth \
      --save-video
  done
done