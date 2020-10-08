/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global interface smdgDataProvider {
    smdgResult getData(smdg coresmdg, smdgRequest request);
    smdg Loadsmdg(smdg coresmdg);
}