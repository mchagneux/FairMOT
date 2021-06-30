import shutil
import os 
results_dir = 'surfrider_T1_epoch_290_short_segments_equal_length'
target_dir = '/home/infres/chagneux/repos/TrackEval/data/trackers/surfrider_T1_segmented/surfrider-test/fairmot_keep_all/data'
sequence_names = [sequence_name for sequence_name in next(os.walk(results_dir))[1]]

for sequence_name in sequence_names:
    shutil.copy(os.path.join(results_dir,sequence_name,'results_clean_0.txt'), os.path.join(target_dir,sequence_name+'.txt'))
