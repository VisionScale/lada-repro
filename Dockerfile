# LADA reproduction environment
# Based on svtter/dialbench:mrlm-cu126 which provides PyTorch 2.5.1 + CUDA 12.4
FROM docker.io/svtter/dialbench:mrlm-cu126

WORKDIR /workspace

# Install additional Python dependencies required by LADA but not in base image
RUN pip install --no-cache-dir \
    yacs \
    scikit-learn \
    scipy

# Copy the LADA project
COPY . /workspace/LADA

WORKDIR /workspace/LADA

ENV PYTHONPATH=/workspace/LADA:$PYTHONPATH

CMD ["bash"]
