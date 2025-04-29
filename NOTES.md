# Additional Notes

```sh
which butane

butane  < deploy/components/enable-intel-gpu/99-enable-intel-gpu-butane.yaml \
  > deploy/components/enable-intel-gpu/99-enable-intel-gpu.yaml
```

Run podman

```sh
# setup path
[ -d scratch ] || mkdir -p scratch
chmod 775 scratch

# run podman
podman run -it --rm \
  --name llama-cpp \
  -p 8080:8080 \
  --device /dev/dri/renderD128 \
  --entrypoint /bin/bash \
  -v $(pwd)/scratch:/model-dir:Z \
    ghcr.io/ggml-org/llama.cpp:full-intel
```

```sh
source /opt/intel/oneapi/setvars.sh
export RAMALAMA_STORE=/model-dir

ramalama pull ollama://granite3.1-moe:3b
llama-run --ngl 999 --jinja ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b hello
llama-server --model ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b --host 0.0.0.0 --n-gpu-layers 999 --flash-attn --ctx-size 32768 --jinja
```
