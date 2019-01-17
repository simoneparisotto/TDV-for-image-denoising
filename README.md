# (High-order) Total directional variation for Image Denoising

**Author**: S. Parisotto

**Other authors** J. Lellmann, S. Masnou and C.-B. Schönlieb

**Version 1.0**

**Date**: January 2019

This is a companion software for the [submission](https://arxiv.org/abs/1812.05023)
```
S. Parisotto, J. Lellmann, S. Masnou and C.-B. Schönlieb 
"(Higher-Order) Total Directional Variation. Part I: Imaging Applications"
arXiv:1812.05023, 2018.
```
Please use the following entry to cite this code:
```
@article{ParLelMasSch2018,
  author = {{Parisotto}, S. and {Lellmann}, J. and {Masnou}, S. and {Sch{\"o}nlieb}, C.-B.},
  title = "{Higher-Order Total Directional Variation. Part I: Imaging Applications}",
  journal = {arXiv e-prints},
  year = 2018,
  month = Dec,
  eid = {arXiv:1812.05023},
  pages = {arXiv:1812.05023},
  archivePrefix = {arXiv},
  eprint = {1812.05023},
  }
```

#### Example
Image with Gaussian noise  (std=51/255) vs. BM3D reconstruction vs. TDV reconstruction

<img src="https://raw.githubusercontent.com/simoneparisotto/TDV-for-image-denoising/master/results/rainbow/20percent_gauss_noisy.png"  width=32%> 
<img src="https://raw.githubusercontent.com/simoneparisotto/TDV-for-image-denoising/master/results/rainbow/u_bm3d_image_PSNR34.5294.png" width=32%> 
<img src="https://raw.githubusercontent.com/simoneparisotto/TDV-for-image-denoising/master/results/rainbow/u_eta3.5_bvary_a1-0-1_sigma2_rho30_iter1_PSNR35.9083.png" width=32%>

######  Software acknowledgements
* [Primal-dual proximal splitting](http://www.numerical-tours.com/matlab/optim_5_primal_dual/)
* [BM3D](http://www.cs.tut.fi/~foi/GCF-BM3D/index.html)
* [export_fig](https://uk.mathworks.com/matlabcentral/fileexchange/23629-export_fig)
* [Diverging Color Maps](https://link.springer.com/chapter/10.1007/978-3-642-10520-3_9)
  
#### LICENSE
[BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause)
