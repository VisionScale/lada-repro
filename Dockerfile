# LADA reproduction environment
# Based on svtter/dialbench:mrlm-cu126 which provides PyTorch 2.5.1 + CUDA 12.4
FROM docker.io/svtter/dialbench:mrlm-cu126

WORKDIR /workspace

# Install additional Python dependencies required by LADA but not in base image
RUN pip install --no-cache-dir \
    yacs \
    scikit-learn \
    scipy

# Remove a conflicting `utils` directory from the base image so LADA's utils/ is used
RUN rm -rf /usr/local/lib/python3.10/dist-packages/utils \
    /usr/local/lib/python3.10/dist-packages/utils-*.dist-info

# Copy the LADA project
COPY . /workspace/LADA

WORKDIR /workspace/LADA

ENV PYTHONPATH=/workspace/LADA:$PYTHONPATH

CMD ["bash"]
