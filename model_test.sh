# the enrolled data dir
data_dir="./data/enrollment_evalution"

# save result dir
save_dir="./results/features"

# model output features dir
features_dir="./results/features"

# the checkpoint model path
checkpoint_path=$1
model_postfix=${checkpoint_path#m*/}
model_name=${model_postfix%.h5}

# model weight dir
weight_path="./model/"

# save caculate score txt path
score_dir="./results/scores"

# the polt image save dir
save_plot_dir="./results/plots"

# the enroll sentence nums
enroll_sentence_nums=15

# the validate sentence nums
val_sentence_nums=100

# the stranger sentence nums
stranger_sentence_nums=100

python -u ./code/utils/sep_model_weight.py --checkpoint_path=$checkpoint_path --model_save_dir=$weight_path
echo "模型权重导出完成"

model_save_path=$weight_path$model_name"_notop.h5"

python -u ./code/2-enrollment/enrollment.py --data_dir=$data_dir --save_dir=$save_dir -weight_path=$model_save_path \
                                      --category="dev" --enroll_sentence_nums=$enroll_sentence_nums \
                                      --val_sentence_nums=$val_sentence_nums
echo "注册人提取特征完成"

python -u ./code/3-evalution/evalution.py --data_dir=$data_dir --save_dir=$save_dir -weight_path=$model_save_path \
                                      --category="test" --stranger_sentence_nums=$stranger_sentence_nums \
echo "陌生人提取特征完成"

python -u ./code/4-roc_curve/caculate_score.py --features_dir=$features_dir --score_dir=$score_dir
echo "score 计算完成"

python -u ./code/4-roc_curve/plot_roc.py --save_plot_dir=$save_plot_dir --score_dir=$score_dir --plot_name=$model_name

echo "roc 图绘制完成"

read -p "按回车键退出"