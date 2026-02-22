FROM python:3.10-slim

RUN apt-get update -y && apt-get install -y --fix-missing git bash ffmpeg libsm6 libxext6 libxrender-dev unzip wget \
    && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /MultiPassDedup && cd /MultiPassDedup

WORKDIR /MultiPassDedup

COPY requirements.txt requirements.txt

RUN pip install --timeout=3600 --no-cache-dir -r requirements.txt \
    && pip install --timeout=3600 --no-cache-dir --no-cache torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124

COPY . .

RUN chmod +x /MultiPassDedup/entrypoint.sh

ENTRYPOINT ["/MultiPassDedup/entrypoint.sh"]
