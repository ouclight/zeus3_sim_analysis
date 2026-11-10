from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
r=Path(__file__).resolve().parent
plt.rcParams.update({'font.family':'SimHei','axes.unicode_minus':False,'svg.fonttype':'path'})
x=np.geomspace(.125,16,500); P=6.5536; B=3.2768
fig,ax=plt.subplots(figsize=(11,7))
for l,c in [(1,'#777777'),(2,'#8862ad'),(4,'#2767a5')]:
 ax.loglog(x,np.minimum(P*min(1,l/4),B*x),color=c,lw=2,label=f'L={l}：接口容量与OL1长归约约束共同作用')
ax.loglog(x,np.minimum(P,B*15/23*x),'--',color='#d77816',label='当前行内credit供数参考（尚未加入OL1限制）')
for name,i,t,f,col,offset in [('M1 local/k4，L=4',1,871,4194304,'#c53636',(15,12)),('M4 normal/w4，L=4',4,1177,16777216,'#25834d',(12,-35))]:
 y=f/t*.0004
 ax.scatter(i,y,color=col,zorder=4)
 ax.annotate(name+f'\n{y:.3f} TFLOP/s',xy=(i,y),xytext=offset,textcoords='offset points',color=col)
ax.set(xlim=(.125,16),ylim=(.3,10),xlabel='权重算术强度 Iw（FLOP/B）',ylabel='单核吞吐（TFLOP/s，400 MHz）',title='OL1反馈也是屋顶：必须同时指定权重强度 Iw 与独立累加链数 L')
ax.grid(which='both',alpha=.2)
ax.legend(loc='lower right',fontsize=9)
fig.text(.12,.03,'OL1参考采用 D≈4 拍、长归约和均匀交错条件；首轮绕过、尾部及生产交接需单独处理。\nL=4不代表权重复用4次：M1/k4的Iw仍为1；M4/w4的Iw为4。',fontsize=10)
fig.subplots_adjust(bottom=.19)
fig.savefig(r/'roofline_ol1_context.png',dpi=160)
fig.savefig(r/'roofline_ol1_context.svg')
