FROM quay.io/fedora/fedora:41 as builder

ARG LLAMA_CPP_VER=b4984

COPY one-api.repo /etc/yum.repos.d/

RUN dnf install -y procps-ng g++ \
      cmake git libcurl-devel intel-oneapi-mkl-sycl-devel intel-oneapi-dnnl-devel \
      intel-oneapi-compiler-dpcpp-cpp intel-level-zero oneapi-level-zero \
      oneapi-level-zero-devel intel-compute-runtime && \

RUN source /opt/intel/oneapi/setvars.sh && \
      git clone https://github.com/ggerganov/llama.cpp.git -b "${LLAMA_CPP_VER}" ; \
      cd llama.cpp ; \
      mkdir -p build ; \
      cd build ; \
        cmake .. -DGGML_SYCL=ON -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DLLAMA_CURL=ON -DGGML_CCACHE=OFF -DGGML_NATIVE=OFF -DGGML_CPU_AARCH64=OFF ; \
        cmake --build . --config Release -j -v ; \
        cmake --install . --prefix /llama-cpp

FROM quay.io/fedora/fedora:41

COPY --from=builder /llama-cpp/bin/ /usr/bin/
COPY --from=builder /llama-cpp/lib64/ /usr/lib64/
COPY --from=builder /llama-cpp/include/ /usr/include/
COPY oneapi.repo /etc/yum.repos.d/
COPY --chown=0:0 entrypoint.sh /usr/local/bin/

RUN dnf install -y procps-ng \
      python3 python3-pip python3-devel \
      intel-level-zero oneapi-level-zero intel-compute-runtime \
      intel-oneapi-runtime-compilers intel-oneapi-mkl-core intel-oneapi-mkl-sycl-blas \
      intel-oneapi-runtime-dnnl intel-gpu-tools \
      libcurl lspci clinfo wget && \
    chown 0:0 /etc/passwd ; \
    chown 0:0 /etc/group ; \
    chmod g=u /etc/passwd /etc/group /home ; \
    pip install ramalama ; \
    chmod +x /entrypoint.sh

ENV HOME=/

USER 1001

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]