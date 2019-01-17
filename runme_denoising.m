%% (Higher-order) Total directional variation for image denoising
%
% Companion software to
% Simone Parisotto, Simon Masnou and Carola-Bibiane Schoenlieb.
% "(Higher-order) Total directional variation. Part I: Imaging Application"
% ArXiv: https://arxiv.org/abs/1812.05023
%
% Authors:
% 1) Simone Parisotto          (email: sp751 at cam dot ac dot uk)
% 2) Jan Lellmann              (email: jan lellmann at mic dot uni-luebeck dot de)
% 3) Simon Masnou              (email: masnou at math dot univ-lyon1 dot fr)
% 4) Carola-Bibiane Schoenlieb (email: cbs31 at cam dot ac dot uk)
%
% Address of Authors 1) and 4):
% Cambridge Image Analysis
% Centre for Mathematical Sciences
% Wilberforce Road
% CB3 0WA, Cambridge, United Kingdom
%  
% Date:
% January, 2019
%
% Licence: BSD-3-Clause (https://opensource.org/licenses/BSD-3-Clause)
%

clear
close all
clc

addpath ./dataset

addpath ./lib
addpath ./lib/TDV
addpath ./lib/structure_tensor
addpath ./lib/operators
addpath ./lib/BM3D
addpath ./lib/plots/export_fig-master/
addpath ./lib/plots

%% SELECT CLEAN IMAGE for the paper results
fileimage = 'Supernumerary_Rainbows.jpg';
%fileimage = 'bamboo.png';
%fileimage = 'dune.jpg';

%% GET PARAMETERS (also for multiple tests)
[params,lambda,b,eta,s,r,pn] = get_parameters(fileimage);

%% LOAD CLEAN IMAGE
u = im2double(imread(fileimage));

%% ADD NOISE
seed   = 1405; rng(seed); % same seed as in DTV paper
unoise = u + pn/100*randn(size(u));
imwrite(unoise,['./results/',num2str(pn),'noisy.png'])

%% MULTIPLE TESTS
PSNR = zeros(numel(lambda),numel(eta),numel(b),numel(s),numel(r));

for ee = 1:numel(eta)
    for ll = 1:numel(lambda)
        for bb=1:numel(b)
            
            % SELECT EXPERIMENT
            params.b      = b{bb};
            params.lambda = lambda(ll);
            params.eta    = eta(ee);
            
            for ss = 1:numel(s)
                for rr=1:numel(r)
                    
                    switch params.update_v_iter
                        case 1
                            params.sigma = s(ss);
                            params.rho   = r(rr);
                        otherwise
                            params.sigma = [s(ss), 1];
                            params.rho   = [r(rr), 1];
                    end
                    
                    %% CORE DENOISING
                    [udenoise, v, TDVtime, PSNR(ll,ee,bb,ss,rr)] = tdv_denoising(unoise,params,u);

                    % SAVE RESULT
                    imwrite(udenoise,['./results/',num2str(pn),'noisy','_eta',num2str(params.eta),'_b',num2str(params.b),'_a',num2str(params.lambda{1}(1)),'-',num2str(params.lambda{1}(2)),'-',num2str(params.lambda{1}(3)),'_sigma',num2str(params.sigma(1)),'_rho',num2str(params.rho(1)),'_iter',num2str(params.update_v_iter),'_PSNR',num2str(PSNR(ll,ee,bb,ss,rr)),'.png'])
                    
                end
            end
        end
    end
end

%% SAVE GLOBAL PSNR
save('./results/PSNR.mat','PSNR','b','lambda','eta','params','s','r')

%% COMPARE WITH BM3D
if size(u,3)>1
    [bm3d_psnr, y_est] = CBM3D(u, unoise, pn*255/100,'np');
else
    [bm3d_psnr, y_est] = BM3D(u, unoise, pn*255/100,'np');
end
imwrite(y_est,['./results/bm3d_image_PSNR',num2str(psnr(u,y_est)),'.png']);

%% GET THE BEST RESULT OVERALL
[i_ll,i_ee,i_bb,i_ss,i_rr] = ind2sub(size(PSNR),find(PSNR==max(reshape(PSNR(:,:,:,:,:),[],1))));

fprintf('\nTotal directional variation:\n')
fprintf('Image: External image (%dx%dx%d), sigma = %0.1f\nFINAL ESTIMATE (total time: %2.2f sec), PSNR: %2.2f dB\nParameters: lambda = [%d %d %d]: eta=%2.2f, b=(%2.2f,%2.2f), ST_sigma=%2.2f, ST_rho=%2.2f\n',...
    size(u,1),size(u,2), size(u,3),255*pn/100,TDVtime,...
    PSNR(i_ll,i_ee,i_bb,i_ss,i_rr),...
    lambda{i_ll}(1),lambda{i_ll}(2),lambda{i_ll}(3),...
    eta(i_ee),b{1}(1),b{1}(2),s(i_ss),r(i_rr));

% only when b = 0:0.01:0.05;
% show_psnr_imagesc(PSNR,1,1:numel(eta),[1,3,5,7],PSNR,lambda,eta,b,s,r,'rho','sigma')