
import SimpleITK
import numpy as np
import os

import preprocessing, UNet_zones, utils
from evalutils import SegmentationAlgorithm
from evalutils.validators import (
    UniquePathIndicesValidator,
    UniqueImagesValidator,
)


class Am_zonal_zegmentation_gca(SegmentationAlgorithm):
    def __init__(self):
        super().__init__(
            validators=dict(
                input_image=(
                    UniqueImagesValidator(),
                    UniquePathIndicesValidator(),
                )
            ),
        )

    def predict(self, *, input_image: SimpleITK.Image) -> SimpleITK.Image:
        print('RUNNING THE SEGMENTATION MODEL...')
        # input directory that contains three orthogonal images (tra, sag, cor), which are needed for preprocessing
        inputDir = '/input/images/'
        outputDir = '/output/images/prostate-zonal-segmentation/'
        arr = preprocessing.preprocessImage(inputDir)
        pred_arr = UNet_zones.predict(arr, modelName = 'model/model.h5')
        pred_arr = np.asarray(pred_arr)

        roi_tra = SimpleITK.ReadImage(os.path.join(inputDir, 'roi_tra.nii.gz'))

        # removes isolated segments from prediction
        pred_arr = utils.removeIslands(pred_arr[:,0,:,:,:])
        # convert to SimpleITK image. Zone affiliation is marked by intensity value (pz=1, cz=2, us=3, afs=4)
        pred_img = utils.convertArrayToMuliLabelImage(pred_arr, templateImg = roi_tra)

        SimpleITK.WriteImage(pred_img, os.path.join(outputDir, 'predicted_roi.mha'))
        
        print('RUNNING THE SEGMENTATION MODEL HAS FINISHED')

        return pred_img


if __name__ == "__main__":
    Am_zonal_zegmentation_gca().process()

