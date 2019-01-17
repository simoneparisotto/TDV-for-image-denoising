function [params,lambda,b,eta,s,r,pn] = get_parameters(fileimage)

%% PARAMETERS
% GENERAL PARAMETERS
params.verbose_text      = 1;
params.verbose_print_v   = 1;

% PARAMETERS FOR PRIMAL DUAL
params.maxiter           = 500; % was 1000 in the paper;
params.acceleration      = 1;
params.compute_PDGAP     = 0;

% PARAMETERS OF THE MODEL
params.order       = [1 2 3]; % order of derivatives associated to lambda
params.anisotropy  = 1;       % order of anisotropy

%% MULTI PARAMETER TEST
% order of derivatives involved, possible options:
% lambda = {[1,0,0],[0,1,0],[0,0,1],...
%           [1,1,0],[1,0,1],[0,1,1],...
%           [1,1,1]};
lambda = {[1,0,0],[0,1,0],[0,0,1],[1,0,1]};

% fidelity term
eta           = 2.5:0.5:5;

% minor-axis of ellipses
b             = 0:0.01:0.05;

% PARAMETERS STRUCTURE TENSOR
% sigma   : The standard deviation for the pre-smoothing in the modified
%           Structure Tensor, it is the local scale (or noise scale) and
%           makes the structure tensor insensitive to noise (irrelevant
%           details of scales smaller than O(sigma) )
% rho     : The standard deviation for the post-smoothing in the modified
%           Structure Tensor, it is the integration scale and should
%           reflect the characteristic window size over which the
%           orientation is to be analysed
s = 1.5:0.1:3.5;
r = 1.5:0.1:3.5;

%% SINGLE TEST
switch fileimage
    case 'Supernumerary_Rainbows.jpg'
        params.update_v_iter    = 1;
        params.compute_field    = 'v2';
        params.regularize       = NaN;
        params.caseweight       = NaN;
        params.gamma_regularize = NaN;
        params.bvary            = 1;
        params.c                = 1;
        lambda = {[1 0 1]};
        b      = {[1,NaN]};
        eta    = 3.5;
        s      = 2;  % 2
        r      = 30; % 20
        pn     = 20; % noise-level in percent
        
    case 'bamboo.png'
        params.update_v_iter    = 2;
        params.compute_field    = 'v2';
        params.regularize       = 1;
        params.caseweight       = 2; %1
        params.gamma_regularize = 2; %2
        params.bvary            = NaN; %0
        params.c                = NaN;
        lambda = {[1 0 1]};
        b      = {[1,0.02]};
        eta    = 3.5;
        s      = 1.8;
        r      = 2.8;
        pn     = 20; % noise-level in percent
        
    case 'dune.jpg'
        params.update_v_iter    = 1;
        params.compute_field    = 'v2';
        params.regularize       = 1;
        params.gamma_regularize = 0.1;
        params.bvary            = 1;
        params.c                = 1;
        params.caseweight       = 2;
        lambda = {[1 0 1]};
        b      = {[1,NaN]};
        eta    = 3.5;
        s      = 3;
        r      = 2;
        pn     = 20; % noise-level in percent
        
    case 'fingerprint_weickert.png'
        params.update_v_iter    = 1;
        params.compute_field    = 'v2';
        params.regularize       = NaN;
        params.gamma_regularize = NaN;
        params.bvary            = NaN;
        params.caseweight       = NaN;
        lambda = {[1 0 1]};
        b      = {[1,0]};
        eta    = 3.5;
        s      = 0.5;
        r      = 4;
        pn     = 0; % noise-level in percent
        
    case 'fingerprint_carola.png'
        params.update_v_iter    = 1;
        params.compute_field    = 'v2';
        params.regularize       = NaN;
        params.gamma_regularize = NaN;
        params.bvary            = NaN;
        params.caseweight       = NaN;
        lambda = {[1 0 1]};
        b      = {[1,0]};
        eta    = 3.5;
        s      = 0.25;
        r      = 40;
        pn     = 0; % noise-level in percent
        
end