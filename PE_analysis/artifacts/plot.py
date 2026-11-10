from pathlib import Path
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
r=Path(__file__).resolve().parent
P=16384;B=8192;Bc=B*15/23
x=np.geomspace(.125,16,300)
fig,ax=plt.subplots(figsize=(9,5.5))
ax.loglog(x,np.minimum(P,B*x),label='Interface-capacity roof (conditional)',lw=2)
ax.loglog(x,np.minimum(P,Bc*x),'--',label='Current in-row credit model: 15 / 23',lw=2)
for label,I,F,T,col in [('M1 local/k4 (local)',1,4194304,871,'tab:red'),('M4 normal/w4 (local)',4,16777216,1177,'tab:green'),('M1 normal/k1 (historical VCS)',1,4194304,1015,'tab:gray')]:
 y=F/T;ax.scatter(I,y,c=col,s=55);ax.annotate(label+'\n'+str(T)+' cycles',(I,y),xytext=(10,-32 if T in [1015,1177] else 8),textcoords='offset points',fontsize=9)
ax.set(xlabel='Weight arithmetic intensity Iw [FLOP / byte]',ylabel='Useful throughput [FLOP / PE cycle]',xlim=(.125,16),ylim=(512,22000))
ax.grid(True,which='both',alpha=.25);ax.legend(loc='upper left',fontsize=9)
fig.tight_layout();fig.savefig(r/'roofline.svg');fig.savefig(r/'roofline.png',dpi=160);plt.close(fig)
fig,ax=plt.subplots(figsize=(10,4.8))
seen=set()
for row,segments in enumerate([[(511,'M1: ideal overlapped window',0),(256,'M1: credit gap increment',1),(40,'M1: row-boundary increment',2),(64,'Between-window gap',3)],[(1024,'M4: effective MAC issue cycles',5),(133,'M4: activation-invalid cycles',4),(20,'Between-window gap',3)]]):
 left=0
 for v,label,color in segments:
  ax.barh(row,v,left=left,color=plt.get_cmap('tab10')(color),label=label if label not in seen else None)
  seen.add(label)
  ax.text(left+v/2,row,str(v),ha='center',va='center',fontsize=9,color='white')
  left+=v
ax.set(yticks=[0,1],yticklabels=['M1 local/k4: 871','M4 normal/w4: 1177'],xlabel='PE cycles',xlim=(0,1250),ylim=(-.6,1.6))
ax.legend(loc='upper center',bbox_to_anchor=(.5,-.22),ncol=2,fontsize=8)
fig.subplots_adjust(left=.19,bottom=.34);fig.savefig(r/'cycle_accounting.svg');fig.savefig(r/'cycle_accounting.png',dpi=150);plt.close(fig)
(r/'numbers.json').write_text(json.dumps({'compute_flops_cycle':P,'interface_bytes_cycle':B,'credit_model_bytes_cycle':Bc,'ridge_interface':P/B,'ridge_credit':P/Bc,'M1':{'cycles':871,'bytes_cycle':4194304/871,'compute_util':256/871},'M4':{'cycles':1177,'bytes_cycle':4194304/1177,'compute_util':1024/1177}},indent=2))
