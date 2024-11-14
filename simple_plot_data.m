% Program to plot the data from [1].
%
%
% References:
%
% [1] M. Ganesh and S. C. Hawkins, T-matrix computations for light
% scattering by penetrable particles with large aspect ratios.
%
% Stuart C. Hawkins - 12 November 2024

function simple_plot_data(fname,opts1,opts2)

% set default plot options for S11 plot
if nargin<2
    opts1 = 'b-';
end

% set default plot options for S22 plot
if nargin<3
    opts2 = 'r-';
end

% check the file exists
if ~exist(fname,'file')
    error('File %s does not exist',fname)
end

% check the index, if it exists, for the metadata
if exist('index.csv','file')

    % load the index file into a table
    T = readtable('index.csv');
    
    % find matches
    j = find(strcmp(T.('filename'),fname));
    
    % check for more than one match... shouldn't happen
    if length(j) > 1
        warning('index.csv appears to contain multiple matches to %s',fname);
    end
    
    % check for the file not being in the index... if that happens we carry
    % on but we won't be able to add labels
    if length(j) == 0
        have_metadata = 0;
    else
        have_metadata = 1;
    end
    
end
    
% load the data file
D = readtable(fname);

% get theta
theta = D.('theta');

% get S11
% Note: note Matlab mangles (S11) into _S11_
S11 = D.('real_S11_') + 1i * D.('imag_S11_');

% get S22
% Note: note Matlab mangles (S11) into _S11_
S22 = D.('real_S22_') + 1i * D.('imag_S22_');

% plot the graph
semilogy(theta,abs(S11).^2,opts1,theta,abs(S22).^2,opts2)
legend('S11','S22')
xlabel('theta')
ylabel('scattering amplitude')

% add title if we have data
if have_metadata
    str = sprintf('%s aspect ratio %0.1f, size parameter x=%0.1f, xs=%0.1f',...
        T.('geometry'){j(1)},...
        T.('aspectRatio')(j(1)),...
        T.('equivalentAreaSphereSizeParameter')(j(1)),...
        T.('sizeParameter')(j(1))...
        );
    title(str)
end