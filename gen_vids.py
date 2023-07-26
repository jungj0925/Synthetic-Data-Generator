import os
import random

base_command = "python /reenact_avatar_next3d.py --drive_root=/data/demo --network=/pretrained_models/next3d_ffhq_512.pkl --grid=2x1 --seeds={seed} --outdir=/out/{seed} --fname=reenact{seed}.mp4 --trunc=0.7 --lms_cond=1 --num_frames=3000"

# Iterate 40 times with random seeds
for _ in range(40):
    # Generate a random seed between 100 and 999
    seed = random.randint(100, 999)

    output_directory = "/out/{seed}"
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    command = base_command.format(seed=seed)

    os.system(command)
