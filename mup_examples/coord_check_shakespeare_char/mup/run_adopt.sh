for width in 256 512 1024 2048 4096
do
    for seed in 1 2 3 4 5
    do
    head_size=64
    n_heads=$((width / head_size))
    mup_base_width=256
    mup_base_head=$((mup_base_width/head_size))
    mup_width_multiplier=$(echo "scale=8; $width/$mup_base_width" | bc -l)
    out_dir="mup_examples/coord_check_shakespeare_char/mup/out/adopt/width${width}_depth2_seed${seed}"
    python train_adopt.py \
        --out_dir=$out_dir \
        --eval_interval=1 \
        --log_interval=1 \
        --eval_iters=1 \
        --eval_only=False \
        --always_save_checkpoint=False \
        --never_save_checkpoint=True \
        --init_from='scratch' \
        --wandb_log=False \
        --csv_log=True \
        --dataset='shakespeare_char' \
        --gradient_accumulation_steps=4 \
        --batch_size=2 \
        --block_size=1024 \
        --n_layer=2 \
        --n_head=$n_heads \
        --n_embd=$width \
        --dropout=0.0 \
        --bias=False \
        --init_std=0.02 \
        --learning_rate=1e-2 \
        --max_iters=10 \
        --weight_decay=1e-1 \
        --beta1=0.9 \
        --beta2=0.999 \
        --grad_clip=1.0 \
        --decay_lr=False \
        --mup_enabled=True \
        --mup_width_multiplier=$mup_width_multiplier \
        --mup_input_alpha=1.0 \
        --mup_output_alpha=1.0 \
        --mup_enable_coord_check_logging=True \
	--mup_base_head=$mup_base_head \
        --seed=$seed \
        --backend='nccl' \
        --device='cuda' \
        --dtype='float32' \
        --compile=False
    done
done
