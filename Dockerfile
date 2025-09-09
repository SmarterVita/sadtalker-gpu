# SadTalker GPU Dockerfile
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Install basic tools
RUN apt-get update && apt-get install -y \
    git wget curl ffmpeg libsm6 libxext6 libgl1 python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
RUN pip3 install --upgrade pip
RUN pip3 install torch==2.2.2+cu121 torchvision==0.17.2+cu121 torchaudio==2.2.2+cu121 \
    -f https://download.pytorch.org/whl/torch_stable.html

# Clone SadTalker
WORKDIR /app
RUN git clone https://github.com/OpenTalker/SadTalker.git . 

# Install SadTalker dependencies
RUN pip3 install -r requirements.txt
RUN pip3 install fastapi uvicorn onnxruntime-gpu gfpgan

# Create model directory (RunPod will mount this)
ENV MODELS_DIR=/models
RUN mkdir -p $MODELS_DIR

# Copy in server app
COPY server.py /app/server.py

# Expose port
EXPOSE 8080

# Start FastAPI
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
