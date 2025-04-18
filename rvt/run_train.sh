# export CUDA_VISIBLE_DEVICES=0

python train.py \
    --exp_cfg_path configs/rvt.yaml \
    --device 1
    # --mvt_cfg_path mvt/configs/rvt2.yaml \