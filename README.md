# 📖MultiPassDedup

### Efficient Deduplicate for Anime Video Frame Interpolation
> When performing frame interpolation on anime footage, conventional deduplication methods often rely on identification, which has many drawbacks, such as losing background textures and failing to correctly handle multiple characters drawn with different cadences in the same scene.
> 
> Through observation and summarization of patterns in anime videos, we found that repeatedly updating the original frames provides an easier and more effective solution to these issues.
Therefore, we developed this project to implement this approach. Combined with the powerful GMFSS interpolation algorithm, we can achieve excellent results in most anime scenarios.

![result](assert/result.gif)

<a href="https://colab.research.google.com/drive/1nEvKPGeM02rKlOn_MiNXWXwb2X9r5FrE?usp=sharing"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="google colab logo"></a>

## 👀Demos Videos(BiliBili)
### [Jujutsu Kaisen S2 NCOP](https://www.bilibili.com/video/BV16W421N7s5/?share_source=copy_web&vd_source=8a8926eb0f1d5f0f1cab7529c8f51282)
### [Houseki no Kuni NCOP](https://www.bilibili.com/video/BV1py4y1A7qj/?share_source=copy_web&vd_source=8a8926eb0f1d5f0f1cab7529c8f51282)

## 🔧Installation
```bash
git clone https://github.com/routineLife1/MultiPassDedup.git
cd DRBA
pip3 install -r requirements.txt
```
download weights from [Google Drive](https://drive.google.com/file/d/1gXyqRiLgZ0sQEuDl4vbbxIgbUvg3k50x/view?usp=sharing) and unzip it, put them to ./weights/


The cupy package is included in the requirements, but its installation is optional. It is used to accelerate computation. If you encounter difficulties while installing this package, you can skip it.


## ⚡Usage 
- normalize the source video to 24000/1001 fps by following command using ffmpeg **(If the INPUT video framerate is around 23.976, skip this step.)**
  ```bash
  ffmpeg -i INPUT -crf 16 -r 24000/1001 -preset slow -c:v libx265 -x265-params profile=main10 -c:a copy OUTPUT
  ```
- open the video and check out it's max consistent deduplication counts, (3 -> on Three, 2 -> on Two, 0 -> AUTO) **(If the INPUT video framerate is around 23.976, skip this step.)**
- run the follwing command to finish interpolation
  (N_PASS = max_consistent_deduplication_counts) **(Under the most circumstances, -np 0 can automatically determine an appropriate n_pass value)**
  ```bash
  python infer.py -i [VIDEO] -o [VIDEO_OUTPUT] -np [N_PASS] -t [TIMES] -m [MODEL_TYPE] -s -st 0.3 -scale [SCALE]
  # or use the following command to export video at any frame rate
  python infer.py -i [VIDEO] -o [VIDEO_OUTPUT] -np [N_PASS] -fps [OUTPUT_FPS] -m [MODEL_TYPE] -s -st 0.3 -scale [SCALE]
  ```
  
 **example(smooth a 23.976fps video with on three and interpolate it to 60fps):**

  ```bash
  ffmpeg -i E:/Myvideo/01_src.mkv -crf 16 -r 24000/1001 -preset slow -c:v libx265 -x265-params profile=main10 -c:a copy E:/Myvideo/01.mkv

  python infer.py -i E:/MyVideo/01.mkv -o E:/MyVideo/out.mkv -np 3 -fps 60 -m gmfss -s -st 0.3 -scale 1.0
  ```

**Full Usage**
```bash
Usage: python infer.py -i in_video -o out_video [options]...
       
  -h                   show this help
  -i input             input video path (absolute path of output video)
  -o output            output video path (absolute path of output video)
  -fps dst_fps         target frame rate (default=60)
  -s enable_scdet      enable scene change detection (default Enable)
  -st scdet_threshold  ssim scene detection threshold (default=0.3)
  -hw hwaccel          enable hardware acceleration encode (default Enable) (require nvidia graph card)
  -s scale             flow scale factor (default=1.0), generally use 1.0 with 1080P and 0.5 with 4K resolution
  -m model_type        model type (default=gmfss)
  -np n_pass           max consistent deduplication counts (default=3)
```

- input accept absolute video file path. Example: E:/input.mp4
- output accept absolute video file path. Example: E:/output.mp4
- dst_fps = target interpolated video frame rate. Example: 60
- enable_scdet = enable scene change detection.
- scdet_threshold = scene change detection threshold. The larger the value, the more sensitive the detection.
- hwaccel = enable hardware acceleration during encoding output video.
- scale = flow scale factor. Decrease this value to reduce the computational difficulty of the model at higher resolutions. Generally, use 1.0 for 1080P and 0.5 for 4K resolution.
- model_type = model type. Currently, gmfss, rife and gimm is supported.
- n_pass = max consistent deduplication counts.

## 🐳 Docker

### Build
```bash
docker build . -t multipassdedup
```

### Run (Windows)
```powershell
docker run --rm -it --gpus all -v .\weights:/MultiPassDedup/weights -v .\workdir:/MultiPassDedup/workdir multipassdedup
```

### Run (Linux)
```bash
docker run --rm -it --gpus all -v ./weights:/MultiPassDedup/weights -v ./workdir:/MultiPassDedup/workdir multipassdedup
```

### Batch script
Search for .mp4, .mov, .mkv files in the `workdir/` store the output in `workdir/out/` (Edit the batch.sh file to change the parameters)
```bash
docker run --rm -it --gpus all -v ./weights:/MultiPassDedup/weights -v ./workdir:/MultiPassDedup/workdir multipassdedup bash /MultiPassDedup/workdir/batch.sh

# OR (after executing the docker, inside the terminal)
./workdir/batch.sh
```

> On first run, if the `weights/` folder is empty or missing `rife48.pkl`, the weights will be downloaded automatically.
> Place your input videos inside the `workdir/` folder to access them from within the container.

## 🤗 Acknowledgement
This project is supported by [SVFI](https://doc.svfi.group/) Development Team.

Thanks for [Q8sh2ing](https://github.com/Q8sh2ing) implement the Online Colab Demo.

## Reference
[GMFSS](https://github.com/98mxr/GMFSS_Fortuna) [Practical-RIFE](https://github.com/hzwer/Practical-RIFE) [GIMM-VFI](https://github.com/GSeanCDAT/GIMM-VFI)
