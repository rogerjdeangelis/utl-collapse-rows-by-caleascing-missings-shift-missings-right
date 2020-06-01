Collapse rows by coalescing missings shift missings right                                                        
                                                                                                                 
github                                                                                                           
https://tinyurl.com/ycen9v8v                                                                                     
https://github.com/rogerjdeangelis/utl-collapse-rows-by-coalescing-missings-shift-missings-right                 
                                                                                                                 
You can solve this with coalesce and very complex logic or exhastive (if) logic.                                 
I could not see a easy way to do that?                                                                           
                                                                                                                 
After creating meta data, you only need 6 lines of code for general solution.                                    
                                                                                                                 
For a lot of SAS problems the solution becomes simple if you have good meta data and                             
normalized data structures.                                                                                      
                                                                                                                 
macros                                                                                                           
https://tinyurl.com/y9nfugth                                                                                     
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                       
                                                                                                                 
                _   _               _                                                                            
 _ __ ___   ___| |_| |__   ___   __| |                                                                           
| '_ ` _ \ / _ \ __| '_ \ / _ \ / _` |                                                                           
| | | | | |  __/ |_| | | | (_) | (_| |                                                                           
|_| |_| |_|\___|\__|_| |_|\___/ \__,_|                                                                           
                                                                                                                 
                                                                                                                 
     1. create macro array vs of input column names  (one macro call)                                            
                                                                                                                 
        VS1=V1                                                                                                   
        VS2=V2                                                                                                   
        VS3=V3                                                                                                   
                                                                                                                 
        VSN=3                                                                                                    
                                                                                                                 
     2. create macro array with row values shifted left (one macro call)                                         
                                                                                                                 
        tmps1=NV1                                                                                                
        tmps2=NV2                                                                                                
        tmps3=NV3                                                                                                
                                                                                                                 
        tmpsN=3                                                                                                  
                                                                                                                 
     3. Create macro strings (one macro call each)                                                               
                                                                                                                 
        VARS=V1 V2 V3                                                                                            
        TMPS=NV1 NV2 NV3                                                                                         
                                                                                                                 
     4. Use peek to create a character string with back to back IEE 754 floats (24 bytes)                        
                                                                                                                 
     5  Compress out IEE 754 floats with missing values                                                          
                                                                                                                 
     6. Poke then reduced string into the output numeric array                                                   
                                                                                                                 
     7. Renane the out array to the original variable names                                                      
                                                                                                                 
*_                   _                                                                                           
(_)_ __  _ __  _   _| |_                                                                                         
| | '_ \| '_ \| | | | __|                                                                                        
| | | | | |_) | |_| | |_                                                                                         
|_|_| |_| .__/ \__,_|\__|                                                                                        
        |_|                                                                                                      
;                                                                                                                
                                                                                                                 
options validvarname=upcase;                                                                                     
data have;                                                                                                       
  input v1 v2 v3;                                                                                                
cards4;                                                                                                          
. . 3                                                                                                            
. 2 .                                                                                                            
. 2 3                                                                                                            
1 . .                                                                                                            
1 . 3                                                                                                            
1 2 .                                                                                                            
1 2 3                                                                                                            
;;;;                                                                                                             
run;quit;                                                                                                        
                                                                                                                 
Up to 40 obs SD1.HAVE total obs=7                                                                                
                                                                                                                 
                 | RULE                                                                                          
                 |                                                                                               
 V1    V2    V3  |                                                                                               
                 |                                                                                               
  .     .     3  | Move 3 into v1                                                                                
  .     2     .  |                                                                                               
  .     2     3  |                                                                                               
  1     .     .  |                                                                                               
  1     .     3  |                                                                                               
  1     2     .  |                                                                                               
  1     2     3  |                                                                                               
                                                                                                                 
*            _               _                                                                                   
  ___  _   _| |_ _ __  _   _| |_                                                                                 
 / _ \| | | | __| '_ \| | | | __|                                                                                
| (_) | |_| | |_| |_) | |_| | |_                                                                                 
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                
                |_|                                                                                              
;                                                                                                                
                                                                                                                 
Up to 40 obs WORK.WANT total obs=7                                                                               
                                                                                                                 
                                                                                                                 
 V1    V2    V3                                                                                                  
                                                                                                                 
  3     .     .                                                                                                  
  2     .     .                                                                                                  
  2     3     .                                                                                                  
  1     3     .                                                                                                  
  1     3     .                                                                                                  
  1     2     .                                                                                                  
  1     2     3                                                                                                  
                                                                                                                 
*                                                                                                                
 _ __  _ __ ___   ___ ___  ___ ___                                                                               
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                              
| |_) | | | (_) | (_|  __/\__ \__ \                                                                              
| .__/|_|  \___/ \___\___||___/___/                                                                              
|_|                                                                                                              
;                                                                                                                
                                                                                                                 
%array(vs,values=%utl_varlist(sd1.have));                                                                        
/*                                                                                                               
VS1=V1                                                                                                           
VS2=V2                                                                                                           
VS3=V3                                                                                                           
VSN=3                                                                                                            
*/                                                                                                               
                                                                                                                 
%let vars=%do_over(vs,phrase=?);                                                                                 
%let tmps=%do_over(vs,phrase=n?);                                                                                
                                                                                                                 
/*                                                                                                               
VARS=V1 V2 V3                                                                                                    
TMPS=NV1 NV2 NV3                                                                                                 
*/                                                                                                               
                                                                                                                 
data want (rename=(%utl_renamel(old=&tmps,new=&vars)));                                                          
                                                                                                                 
 length bin chrBin $%eval(&vsn * 8);  /* 8 byte floats */                                                        
                                                                                                                 
 set sd1.have;                                                                                                   
                                                                                                                 
 array nums[&vsn] &vars;     /* v1 v2 v3    */                                                                   
 array cuts[&vsn] &tmp (&vsn*.) ;     /* nv1 nv2 nv3 */                                                          
                                                                                                                 
 * get array as character ;                                                                                      
 chrBin=peekclong(addrlong(nums[1]),dim(nums)*8);                                                                
                                                                                                                 
 * collapse  missings code by Paul Dorfman saslhole@gmail.com  ;                                                 
 Bin=transtrn(chrBin,put(.,rb8.),trimn(''));                                                                     
 call pokelong(substr(bin,1,binLen),addrlong(cuts[1]));                                                          
                                                                                                                 
 keep &tmps;                                                                                                     
                                                                                                                 
run;quit;                                                                                                        
                                                                                                                 
                                                                                                                 
* delete macro arrays and macro strings;                                                                         
%symdel vars tmps;                                                                                               
%arraydelete(vs);                                                                                                
                                                                                                                 
