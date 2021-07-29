export CUDA_VISIBLE_DEVICES=1
cwd=$(pwd)

fps=6
sequences=long
dataset_dir=../../data/validation_videos/all/${sequences}_segments_${fps}fps/videos
external_detections_path=../../data/external_detections/FairMOT/${sequences}_segments_${fps}fps
cd ${dataset_dir}
output_dir_name=results/${sequences}_segments_${fps}fps

for f in *.mp4; do
    cd $cwd
    base_name="${f%.*}"
    echo $base_name
    dir_for_video=$output_dir_name/${base_name}

    python src/demo.py mot \
        --load_model exp/mot/surfrider_1070_images_290_epochs/model_290.pth \
        --conf_thres 0.4 \
        --input-video ${dataset_dir}/$f \
        --output-root ./${dir_for_video} \
        --not_reg_offset

    clean=0
    python remap_ids.py --input_file  ./${dir_for_video}/results.txt --min_len_tracklet $clean --output_name $f
    mv $base_name.txt ${dir_for_video}/results_tau_$clean.txt

    clean=1
    python remap_ids.py --input_file  ./${dir_for_video}/results.txt --min_len_tracklet $clean --output_name $f
    mv $base_name.txt ${dir_for_video}/results_tau_$clean.txt

    rm ./${dir_for_video}/results.txt
    rm -rf ${dir_for_video}/frame

    external_detections_path_for_video=${external_detections_path}/${base_name}
    mkdir ${external_detections_path_for_video}
    
    mv saved_detections.pickle ${external_detections_path_for_video}/saved_detections.pickle
    mv saved_frames.pickle ${external_detections_path_for_video}/saved_frames.pickle
    
done
