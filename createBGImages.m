function createBGImages(F,nf)

outfolder=fullfile('d:','prml','irtracking','data','img');

maxx=7000;
maxy=14000;

imH=round(maxy/nf);
imW=round(maxx/nf);

for t=1:F
%     im=ones(imH,imW);
    im=imread('d:\prml\irtracking\data\layout.png');
    im=imresize(im,[14000/nf,8620/nf]);
    imwrite(im,[outfolder filesep sprintf('frame_%05d.jpg',t)]);
end



end