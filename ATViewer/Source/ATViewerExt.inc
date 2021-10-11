// Supported file extensions for all view modes:

var
  ffViewerExtText: string =
    'txt,rtf,c,cpp,h,hpp,pas,dpr,inc,rc,asm,'+
    'ini,log,bat,cmd,inf,url';
    //'def,dsp,dsw,dpk,dpkw,bpg,bpr,mak,bas,tex,'
    //'css,js,pm,awk,cla,clw,for,prg,spr,mpr,java,cgi,cls,sty,v,wrl,sh,sql,'
    //'cfg,ctl,ion,diz,nfo,bbs,cnt,md5,sfv,manifest,uue,xxe,'

  ffViewerExtImages: string =
    'bmp,ico,wmf,emf,jpg,jpeg,jpe,jfif,rle,dib,win,vst,vda,tga,icb,tif,tiff,fax,eps,'+
    'pcx,pcc,rpf,rla,sgi,rgba,rgb,bw,psd,pdd,ppm,pgm,pbm,cel,pic,pcd,gif,cut,pal,psp,png';

  ffViewerExtMedia: string =
    'avi,mpg,mpeg,mpe,mpv,mp2,mp1,m1v,m2v,mpv2,mp2v,mpa,m1a,m2a,asf,lsf,lsx,ivf,'+
    'wav,mid,midi,rmi,mp3,aif,aifc,aiff,au,snd,'+
    'mov,qt,3gp,3gp2,3g2,3gpp,'+
    'ra,rm,ram,rmvb,rpm,rt,rp,smi,smil,roq,'+
    'asx,m3u,pls,wvx,wax,wmx,'+
    'wmv,wma,wmp,wm,cda,ac3,dts,vob,ifo,d2v,fli,flc,flic,mka,mkv,ts,tp,tpr,pva,aac,mp4,'+
    'ogm,ogg,divx,vp6,m4a,m4b,vqf,ape,mpc,flac';

  ffViewerExtWeb: string =
    //MSIE:
    'htm,html,htx,shtml,xhtml,shtm,stm,xml,xsl,php,php2,php3,asp,pl,vrml,plg,mht,htt,'+
    //MSO:
    'doc,dot,xls,xlt,pot,pps,ppz,ppt,'+
    //MSO additional:
    'wbk,wps,csv,'+
    //MSO databases:
    //'odb,obt,mdb,mdw,mda,mde,mpp,mpd,mpt,adp,'+
    //OOo 2.x:
    'odt,ods,odp,odg,odf,odb,odm,ott,oth,ots,otg,otp,'+
    //OOo 1.x:
    'sxw,sxc,sxg,sxi,sxd,sxm,stw,stc,std,sti,'+
    //Quick View Plus:
    //'vsd,asp,drw,lwp,prz,wpd,qpw,uue,zip,123,gz,tar,'+
    //VoloView or other AutoCAD viewer:
    //'dwg,dxf,dwf,rml,ipt,iam,idw,'+
    //DejaVu:
    //'djvu,djv,';
    //Acrobat:
    'pdf,'+
    //Flash:
    'swf';
