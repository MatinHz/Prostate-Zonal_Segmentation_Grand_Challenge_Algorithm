FROM python:3.7-slim



RUN groupadd -r algorithm && useradd -m --no-log-init -r -g algorithm algorithm

RUN mkdir -p /opt/algorithm /opt/algorithm/model /input /output/images/prostate-zonal-segmentation \
    && chown algorithm:algorithm /opt/algorithm /opt/algorithm/model /input /output /output/images /output/images/prostate-zonal-segmentation

USER algorithm

WORKDIR /opt/algorithm

ENV PATH="/home/algorithm/.local/bin:${PATH}"

RUN python -m pip install --user -U pip



COPY --chown=algorithm:algorithm requirements.txt /opt/algorithm/
RUN python -m pip install --user -rrequirements.txt

COPY --chown=algorithm:algorithm process.py /opt/algorithm/
COPY --chown=algorithm:algorithm zonesegmentation/preprocessing.py /opt/algorithm/
COPY --chown=algorithm:algorithm zonesegmentation/UNet_zones.py /opt/algorithm/
COPY --chown=algorithm:algorithm zonesegmentation/utils.py /opt/algorithm/
COPY --chown=algorithm:algorithm zonesegmentation/model/model.h5 /opt/algorithm/model/model.h5
COPY --chown=algorithm:algorithm test/images/coronal-t2-prostate-mri/3_cor.mha /input/images/coronal-t2-prostate-mri/3_cor.mha
COPY --chown=algorithm:algorithm test/images/sagittal-t2-prostate-mri/2_sag.mha /input/images/sagittal-t2-prostate-mri/2_sag.mha
COPY --chown=algorithm:algorithm test/images/transverse-t2-prostate-mri/1_tra.mha /input/images/transverse-t2-prostate-mri/1_tra.mha


ENTRYPOINT python -m process $0 $@

## ALGORITHM LABELS ##

# These labels are required
LABEL nl.diagnijmegen.rse.algorithm.name=AM_Zonal_Zegmentation_GCA

# These labels are required and describe what kind of hardware your algorithm requires to run.
LABEL nl.diagnijmegen.rse.algorithm.hardware.cpu.count=3
LABEL nl.diagnijmegen.rse.algorithm.hardware.cpu.capabilities=()
LABEL nl.diagnijmegen.rse.algorithm.hardware.memory=8G
LABEL nl.diagnijmegen.rse.algorithm.hardware.gpu.count=0
LABEL nl.diagnijmegen.rse.algorithm.hardware.gpu.cuda_compute_capability=
LABEL nl.diagnijmegen.rse.algorithm.hardware.gpu.memory=


