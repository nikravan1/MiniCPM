formatted_time=$(date +"%Y%m%d%H%M%S")
echo $formatted_time


deepspeed --include localhost:0,1,2,3 finetune.py \
    --model_name_or_path openbmb/MiniCPM-2B-dpo-fp16 \
    --output_dir output/$formatted_time/ \
    --train_data_path data/train.json \
    --eval_data_path data/val.json \
    --learning_rate 1e-3 --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 4 --bf16 \
    --gradient_accumulation_steps 8 --warmup_steps 100 \
    --max_steps 3000 --weight_decay 0.01 \
    --evaluation_strategy steps --eval_steps 500 \
    --save_strategy steps --save_steps 500 --seed 42 \
    --log_level info --logging_strategy steps --logging_steps 10 \
    --deepspeed configs/ds_config_zero3_offload.json
