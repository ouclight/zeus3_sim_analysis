"""Conditional roof families; no new simulation or fitted bandwidth."""
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
r=Path(__file__).resolve().parent
plt.rcParams.update({'font.family':'SimHei','axes.unicode_minus':False,'svg.fonttype':'path','font.size':11})
P=6.5536; B=3.2768; C=B*15/23
x=np.geomspace(.25,16,500)
fig,ax=plt.subplots(figsize=(14,9))
ax.loglog(x,np.minimum(P,B*x),color='#2767a5',lw=2.5,label='接口容量：min(P峰值, B接口 × Iw)')
for l,col,ls in [(4,'#d77816','--'),(2,'#8351ac','-.'),(1,'#606060',':')]:
 ax.loglog(x,np.minimum(P*min(1,l/4),C*x),color=col,lw=2.5,ls=ls,label=f'联合条件参考 L={l}：min(P峰值 × {l}/4, Bcredit × Iw)')
ax.fill_between(x,np.minimum(P,C*x),np.minimum(P,B*x),color='#f2c890',alpha=.23)
for ridge,col in [(2,'#2767a5'),(46/15,'#d77816')]:
 ax.scatter(ridge,P,marker='D',s=42,color=col)
ax.annotate('接口转折 Iw=2',xy=(2,P),xytext=(.85,8.3),arrowprops={'arrowstyle':'->','color':'#2767a5'},color='#2767a5')
ax.annotate('L=4窗口参考转折 Iw≈3.067',xy=(46/15,P),xytext=(3.7,8.3),arrowprops={'arrowstyle':'->','color':'#d77816'},color='#b96910')
for name,i,t,f,col,offset in [
 ('M1 local/k4，L=4\n871拍；1.926 TFLOP/s',1,871,4194304,'#c53636',(24,15)),
 ('M4 normal/w4，L=4\n1177拍；5.702 TFLOP/s',4,1177,16777216,'#25834d',(15,-38)),
 ('历史 M1 normal/k1，L=1\n1015拍；1.653 TFLOP/s',1,1015,4194304,'#606060',(24,-50))]:
 y=f/t*.0004
 ax.scatter(i,y,c=col,s=65,zorder=5,marker='o' if t!=1015 else 'x')
 ax.annotate(name,xy=(i,y),xytext=offset,textcoords='offset points',color=col,fontsize=10,arrowprops={'arrowstyle':'-','color':col})
ax.text(7,1.76,'L=1：OL1约束平台\n1.6384 TFLOP/s',fontsize=10,color='#606060')
ax.text(7,3.55,'L=2：OL1约束平台\n3.2768 TFLOP/s',fontsize=10,color='#8351ac')
ax.text(.29,.52,'k4增加独立输出链，不增加权重复用：M1的Iw仍为1。\nM4同一权重服务四行：Iw=4；L与Iw是两个不同变量。',fontsize=11)
ax.set(xlim=(.25,16),ylim=(.45,11),xlabel='权重算术强度 Iw（FLOP / 有效权重字节）',ylabel='单核有效算术吞吐（TFLOP/s，400 MHz）',title='综合 Roofline：算术峰值、供数窗口与 OL1 反馈约束')
ax.set_xticks([.25,.5,1,2,4,8,16],labels=['0.25','0.5','1','2','4','8','16'])
ax.set_yticks([.5,1,1.6384,3.2768,6.5536,10],labels=['0.5','1','1.6384','3.2768','6.5536','10'])
ax.grid(which='both',alpha=.16)
ax.legend(loc='upper left',bbox_to_anchor=(0,-.15),frameon=False,fontsize=10,ncol=2)
fig.subplots_adjust(bottom=.29,top=.90,left=.09,right=.97)
fig.text(.10,.035,'条件模型：P峰值=6.5536 TFLOP/s；B接口=3.2768 TB/s；Bcredit=B接口×15/23；OL1长归约反馈D≈4拍。\nL=1/2联合线是同一供数参考下的模型曲线，不代表已验证normal/k1具有相同credit轨迹。\n历史1015拍略高于L=1渐近平台，涉及首轮绕过等有限长度效应；不是本轮同配置对照。\n跨行、激活和块间交接尚未计入屋顶；本地871不能等同历史861或完整SoC结果。',fontsize=10,color='#555')
fig.savefig(r/'roofline_layered_current.svg');fig.savefig(r/'roofline_layered_current.png',dpi=170)
