# 美赛

[toc]

## 问题分析

### 【原题】

[A题英文及翻译](https://www.notion.so/A-459175181e7e4f2fb7ebc789c7d09f01)

### 【BibTex】

[BibTex](https://www.notion.so/BibTex-c3fe48b4459d41a7953402285bc98bfe)

### 【参数表】

| 参数 | 符号 | 备注 |
| --- | --- | --- |
| 赛道水平总路程 | L |  |
| 起点距离赛道某点的水平路程 | x | 0≤x≤L |
| 坡度角 | ⁍ | 是关于x的函数, 符数表示下坡 |
| 迎风角 | ⁍ | 道路前进方向与风向的夹角，是关于x的函数 |
| 坡道曲率半径 | ⁍ | 关于x的函数 |
| 赛道曲率半径 | ⁍ | 关于x的函数 |
| 滚动摩擦因数 | ⁍ | 关于x的函数 |
| 静摩擦因数 | ⁍ | 关于x的函数 |
| 总质量 | M |  |
| 环境风速 | ⁍ |  |
| 自行车速率 | ⁍ | 关于x的函数 |
| 瞬时功率 | ⁍ | 关于x的函数 |
| 地面支持力 | ⁍ |  |
| 滚动摩擦阻力 | ⁍ |  |
| 重力切向分力 | ⁍ |  |
| 空气密度 | ⁍ |  |
| 正迎风面积 | ⁍ |  |
| 风阻力系数 | ⁍ |  |
| 风阻力 | ⁍ |  |
| 总无氧能量 | ⁍ | 消耗上限 |
| 临界功率 | CP | 开始乳酸堆积对应功率 |
| 最大功率 | ⁍ | 运动员功率上限（对应⁍） |
| 完成赛道总时间 | T |  |
| 弯道速度上限 | ⁍ |  |
| 车速上限 | Vmax |  |
|  |  |  |

### 【总目标】

- 求解P(x)曲线，使得在满足约束条件下，最小化T

### 【求解思路1】

- 思路：先求v(x)曲线，再得到P(x)曲线
- 离散化：在赛道水平路程上作若干取样点, $0 = x_{0}<x_{1}<x_{2}<...<x_{n}=L$, (不一定是等间隔取) $\triangle x_{i} = x_{i}-x_{i-1}$
- 参数构造：令$v_{i}$表示在$x_{i}$处的速率
- $x_{i-1}$至$x_{i}$段，在$\triangle x_{i}$较小时，
  
    该段坡度$\overline{\alpha}_{i}=(\alpha(x_{i-1})+\alpha(x_{i}))/2$ 
    
    速率$\overline{v}_{i}=(v_{i}+v_{i-1})/2$  求解方便可取 $\overline{v}_{i}=v_{i}$
    
    时间$\triangle t_{i}=\triangle x_{i}/(cos(\alpha(x_{i}))*\overline{v}_{i})$
    
    迎风角$\overline{\beta}_{i}=(\beta(x_{i})+\beta(x_{i-1}))/2$
    
    坡道曲率半径$\overline{\rho}_{i}=(\rho(x_{i})+\rho(x_{i-1}))/2$（近似圆弧：$\triangle x_{i} / \triangle \alpha_{i}$）
    
    弯道曲率半径 $\overline{r}_{i}=(r(x_{i})+r(x_{i-1}))/2$（近似圆弧：$\triangle x_{i} / \triangle \theta_{i}$）
    
    摩擦因数 $\overline{\mu}_{i}=(\mu(x_{i-1})+\mu(x_{i}))/2$
    
    摩擦做功 $WF_{i}=-(m*g*cos(\overline{\alpha}_{i})+m*\overline{v}_{i}^2/\overline{\rho}(x_{i}))*\overline{\mu}_{i}*\triangle x_{i}/cos(\overline{\alpha}_{i})$
    
    重力做功 $WG_{i}=-m*g*sin(\overline{\alpha}_{i})*\triangle x_{i}/cos(\overline{\alpha}_{i})$
    
    风阻力做功 $WW_{i=}-K*(\overline{v}_{i}+v_{w}*cos(\overline{\beta}_{i}))^{2}*\triangle x_{i}/cos(\overline{\alpha}_{i})$
    
    动能定理⇒ 该段能量消耗  $E_{i}=\frac{1}{2}*m*(v_{i}^{2}-v_{i-1}^2)-WF_{i}-WG_{i}-WW_{i}$
    
    无氧能量消耗 $EN_{i} = Max(0,E_{i}-CP*\triangle t_{i})$  
    
    只有v为未知量，其他参数均为已知量
    
- 约束条件：
  
    $\sum_{i=1}^{n} EN_{i}<=W$
    
    $0<=v_{i}<=min(v_{max},\sqrt{\mu(x_{i})*g*r(x_{i})})$   (1≤i≤n)   $v_{max}$为一常数
    
- 最优化目标:
  
    找到一组符合约束条件的$v_{i}$
    
    s.t.  $min \sum_{i=1}^{n}\triangle t_{i}$     
    
- 优化求解过程：
    - 使用matlab fmincon函数求解非线性规划
    - 最优化目标函数以及约束条件均是关于$v_{i}$的多元函数
    - 可假设在$\alpha(x)或\beta(x)$变化不大的路段速度保持一致（如直道，坡角稳定的长坡道，没有和横向风速的情况），可在该区域减少取样点（同时也就减少了约束条件个数）。
      
        （YRB：看注释！）
        
        理论依据：论文  [“there is no benefit to varying power in response to changes”](https://link.springer.com/content/pdf/10.1007/BF02844006.pdf)
        
    - 粒子群
- 还原P(x):
  
    $F_{s}(x_{i})-(mg*cos(α)+\displaystyle\frac{mv^2}{ρ(x_{i})})*\mu(x_{i})-mg*sin(\alpha(x_{i}))-K*(v_{i}+v_{w}*sin(\beta(x_{i})))^2=m*a(x_{i})= m*(v_{i}-v_{i-1})/\triangle t_{i}$
    
    $P(x_{i}) = F_{s}(x_{i})*v_{i}/\eta$
    

### 【代码】

[基本代码](https://www.notion.so/3c61b7db0adc4a0d855bbab7944e1d9f)

[](https://gitee.com/beatrix/MCM_2022_a_bicycle/blob/exertion/main.m#)

### 【图像】

[MATLAB绘图汇总](https://www.notion.so/MATLAB-f5bb394ea7d24202a0e2f250fa4abd2f)

### 【大纲】

[论文大纲](https://www.notion.so/2aa8096e6a9644979fa8cf2340360b06)

### 【恢复非线性】

论文：[《**A 3-parameter critical power model**》](https://www.tandfonline.com/doi/pdf/10.1080/00140139608964484?needAccess=true)

$\displaystyle\frac{dE}{dt}=\frac{(P-CP)(P_{max}-CP)}{P_{max}-P}$

数据：论文[《Optimising distribution of power during a cycling time trial》](https://link.springer.com/content/pdf/10.1007/BF02844006.pdf)

> Data in Broker et al. (1999) indicates
that the British cyclist Chris Boardman maintained a
power output of 520 W for 251 s in a record-setting
4000 m time trial and, based on data for team pursuits
in the same article, it will be assumed that Boardman is
capable of generating 700 W for 60 s. Boardman’s
power output in a record-setting hour ride (3600 s)
was measured by Keen (1994) at 442 W. These values
represent three pairs of coordinates (P, D) that, if
assumed to satisfy eqn. 6, yield three equations for the
three unknown parameters.
> 

$$
\begin{aligned} &P = power output (W)\\
&CP = critical power (W) = 435W\\
&P_m = maximum power (W) = 1234W\\
&A = anaerobic work capacity (J) = 12430 J = 12.43KJ \end{aligned}
$$

### 【骑手功率曲线数据】

- [https://www.cyclinganalytics.com/blog/2013/06/comparative-statistics](https://www.cyclinganalytics.com/blog/2013/06/comparative-statistics)
- [https://cyklopedia.cc/cycling-tips/power-profile/](https://cyklopedia.cc/cycling-tips/power-profile/)

## 工作-恢复功率

### 《自行车不同骑速能量消耗特征研究》

[Untitled](%E7%BE%8E%E8%B5%9B%2063dec73d978649008f16be9e0f9e7c02/Untitled.pdf)

- 有关于男女不同性别的数据：

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled.png)

- 提出了一个回归方程，用于估算耗氧量（即功率）和速度，体重，性别的关系。

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%201.png)

### 《公路个人计时赛运动员竞技能力特征研究》

[Untitled](%E7%BE%8E%E8%B5%9B%2063dec73d978649008f16be9e0f9e7c02/Untitled%201.pdf)

- 关于骑行姿势，提出了“有氧位”的概念
- 在比赛节奏方面，提出加速要快，但是不要超过有氧范围，避免造成乳酸堆积。最好的策略是前半段略低于无氧阀速度，后半段略高于无氧阀速度
- 关于转弯，需要减速，考虑达到一个半径与速度的平衡点。

### 《**浅析自行车公路计时赛项目的技术特点**》

[Untitled](%E7%BE%8E%E8%B5%9B%2063dec73d978649008f16be9e0f9e7c02/Untitled%202.pdf)

- 路面宽度不可以少于6米，起点和终点的宽度不可以少于8米
- 在终点前设计至少不短于500m的直道
- 加强对终点线后面缓冲段的控制，不可使其短于100m
- 可将起点和终点设置在同一地点，保证安全性
- 环形赛道一圈不可以短于12km

### CP模型综述

[The "Critical Power" Concept and High-Intensity Exercise Performance](https://www.gssiweb.org/sports-science-exchange/article/the-critical-power-concept-and-high-intensity-exercise-performance)

- CP 可以在功能上定义为在不逐渐消耗 W' 的情况下可以维持的最高功率输出
- 功率-时间关系的曲率（所谓的 W'）表示在高于 CP 的运动期间可以完成的工作量，它是恒定的，并且根据运动功率输出的接近程度以不同的速率使用CP
- 无论采用何种运动方案或起搏策略，高强度运动期间的耐受极限与达到相同的o 2 max 和完成相同数量的高于 CP 的工作量一致
- 间歇性运动耐量是四个自变量的函数：工作间隔功率输出 (P W )、工作间隔持续时间 (D W )、恢复间隔功率输出 (P R ) 和恢复间隔持续时间 (D R )
- W' BAL模型：应用连续方程来模拟间歇运动期间的 W' 重建动力学，当 P R较小时，W' 重构得更快

### 《A 3-parameter critical power model》

我们最终采用的

[](https://www.tandfonline.com/doi/pdf/10.1080/00140139608964484?needAccess=true)

## 最优化问题

### 《自行车计时赛的最优功率分配问题》

- BibTex:
- $W=(P-PC)*t$
- $W=(P-PC)*(t+j)$      $j = W/(P_{max}-PC)$  改进
- 转弯有最大速率限制，$v_{max} = \sqrt{\mu*g*r}$

### 《论公路自行车配速策略的优化**》**

- BibTex：`sundstrom2013optimization`

[On Optimization of Pacing Strategy in Road Cycling](https://pdf.sciencedirectassets.com/278653/1-s2.0-S1877705813X00116/1-s2.0-S1877705813011132/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJGMEQCIDNMcuXv%2B8pqOBNTsZ5GDjt6bkRVMi2yi3IvBlIMk9DRAiB8Y2C9vWDjMYeoyjFEgL%2BPpDY7%2F07ZWEKcppU8RxhINCqDBAjj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAQaDDA1OTAwMzU0Njg2NSIMvtc8sm1xeOomTH%2BWKtcD%2FaHgtWF8S%2FhiOhCWWa04Vun0foYIZD4XvtxM24Eag5USKuZzhb36qcs3N9zbsSgStSG1ii8OS%2BAawQXEckSeFTWPhAcoFvSXv%2BcULD9g2adKm58U%2F3SGnDmVaFXdECfe%2B2bKQQ4trK2b5lRyO%2ByL3MudYYtCIoWo%2FE%2BtId%2FQnFj0sK6X3fITd8zqUt2OulqUDivo0t6OP5mLHi4CRvUEsD%2FMQ8mY%2BIbQ8JF%2BNUTrPm%2F67Lqc%2B98L4VR%2BF%2FzOWpjB4fcp%2F8zMwLUJwx8%2Bxv8oShLhtigDVdLhNAtuIAAWpVJjv00qc0vvR3T3N3HbFScAmT7rhcj2LDCWYAlHgU0YW%2BGOzYC2b2E2rh7VALhDgU2H6ZZyW7BDO%2F3Y5hNwkeIkGeRi2Em%2Bv7gWWXCfGjJ9A831n7JBYNwYFSmNXY4T2%2FKaJ3H65cFCNYrs2dKwQTq4qmn%2FEllksVlReguy8ecvTM2MRM34gkk1iIqc12HZt8FKE9lNE8VKyzpwPdiwhf%2F8GoINAW%2BMHlE8sAOnsLYi%2BxJUaYD5jP%2FK9P9Zj8gR12maRsALYW8DMQpWYwwosE7e%2Bjp%2FsUboulfA89iLqwS65lGDUI5zwv4ga41L7N5iGgbkge8%2B%2FJJ3MNr6u5AGOqYBUoyR1WVa%2BdjtvvxnycA2xxoLaEmzuDLbt%2FcHjInPT7bIRJBTor6RdlWFRMlwAjll77%2FFq714i1zXYC2eMFSv8WPFLCs15gGLlLdyMCVGVGq6tdahGZhgsH08rIzEUnDiYd%2FsRV8z8oNP9s8U10YoounjVdZiXl7fyE0nMXgqdFD7cpwDFW6SffzSMHcpC4kiS71P3tzRSPtIL7ey6hpk9pwL6awSBQ%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220218T021332Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTY7O6NVKDV%2F20220218%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=d0a82a246edcd88672f9baca4a3d56271a095fe2168cf31206cfe0a5da6d499f&hash=4ce8e0f53dc6c37922ca1b853928c77aacf4c7ef2827caa2e499df4b1ba9d02e&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S1877705813011132&tid=spdf-a073636f-1b8d-4eec-afec-aa5c98357e72&sid=4e0b8d5832fda243c458b8a8d10134c5a119gxrqa&type=client&ua=570500510d03580a05&rr=6df3bc9eeb63250c)

- **前置研究**：《[Numerical optimization of pacing strategy in cross-country skiing](https://link-springer-com-s.vpn.buaa.edu.cn:8118/content/pdf/10.1007%2Fs00158-012-0856-7.pdf)》
- **关键词**：Numerical optimization
- **假设1**: 每条赛道由多个立方样条曲线组成，每个样条曲线可简化为只在x(道路方向延申距离) y（高度）两维方向延伸的曲线，表示为$y = f(x)$，受力分析如下：

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%202.png)

- 参数：
  
    $m_{tot}$: 总质量
    
    $I_{w}$: 两轮的质量惯性矩【total mass moment of inertia】 
    
    $r_{w}$: 车轮半径
    
    $m_{s} = m_{tot}+ I_{r}/r_{w}^2$: 系统在运动方向上的总惯量???【The total inertia of the system in the direction of travel】
    
    $v$：速度
    
    $P_{p}$：人作用于脚踏板的功率
    
    $\eta_{tr}$: 机械传动效率【mechanical transmission efficiency】
    
    $F_{s}=\displaystyle\frac{P_{p}*\eta_{tr}}{v}$ : 推进力
    
    $\ddot{s}$：切向加速度
    
    $\ddot{n}$:  法向加速度
    
    $\ddot{x}:$ 水平加速度
    
    $\ddot{y}$：垂直加速度
    
    $\alpha$: 坡度
    
    $F_{RR}=C_{RR}*N$ ：滚动摩擦力
    
    $F_{BR}=b_{2}+b_{1}*v$: 车轮轴承摩擦【wheel bearing friction】参考《**Frictional resistance in bicycle wheel bearings》**
    
    $F_{D}=\frac{1}{2}*C_{D}*A*\rho*v^2$: 空气阻力    A：正投影面积    $C_{D}$: 阻力系数   $\rho$:空气密度
    
    N：法向力
    
- 公式（矩阵形式）：
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%203.png)
    
- **最终微分方程**：（$t't''$为时间t对x的一阶二阶导）推导过程在前置论文《[Numerical optimization of pacing strategy in cross-country skiing](https://link-springer-com-s.vpn.buaa.edu.cn:8118/content/pdf/10.1007%2Fs00158-012-0856-7.pdf)》
  
    利用$t'=\displaystyle\frac{dt}{dx}=\displaystyle\frac{1}{\displaystyle\frac{dx}{dt}}=\displaystyle\frac{1}{v~ cos\alpha}$ 和 $\ddot{x} = \displaystyle\frac{d(\displaystyle\frac{dx}{dt})}{dt} = \displaystyle\frac{d(\displaystyle\frac{1}{t'})}{dt} = - \displaystyle\frac{1}{(t')^3} t''$，代入上述值得到
    
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%204.png)
    
    方程解析解难以求得，要求离散解
    
- **MMA优化过程**, 参数与公式:
  
    ${\triangle t_{i}}$: 时间差序列，$\triangle t_{q}$表示第q时刻和第q-1时刻的时间差（时刻的划分按照水平距离x等距原则，即第n与第n+1两个时刻自行车的水平距离之差保持恒定（不随n变化）论文采用81个取样点，即将赛道某一段按照水平距离80等分取样）
    
    T = $\sum_{i=1}^K\triangle t_{i}$ ：需要最小化的总时间参数
    
    ${P_{i}}$: 功率参数序列（一系列在不同时刻的输出功率值 $P_{q}$为q时刻的功率输出值）
    
    $AAW_{i}$: 当前可用的无氧能量【Available Anaerobic Work】序列（$AAW_{q}$可看作q时刻的剩余无氧能量, 初始$AAW_{1}$=AWC, 后续逐渐减少但不能小于0）
    
    $AAW_{q} = AAW_{q-1} - (CP - (P_{q}+P_{q-1})/2)*\triangle t_{q}$    CP: 临界功率
    
- 优化目标与约束条件
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%205.png)
    
- 论文写的思维有点跳跃（许多结论直接引用了其他论文，没有详细推导）以下为个人理解：对每个样条曲线$y=f(x)$ （或者说赛道每一路段），都有以上推导的微分方程成立，目的是在不同阶段合理分配输出功率Pi，使得完成赛道后的T最小（）。所以对赛道水平距离等距取样（如对水平距离100m赛道每1m取样，就有101个取样点），现定义参数$P_{i} (i=1,2,101)$, 代表自行车运行到每个取样位置的瞬时功率，对每一组输入$P_{i}$可用Runge-Kutta-Fehlberg法求解微分方程的数值解（即解出函数t（x）在x=0，1，2，...100的数值，t(q)-t(q-1)就是$\triangle t_{q}$, 这样就可以求出T）
  
    暴力求解??之后不断变动序列P使得T最小??
    
- 求解效果图（横轴为x，在某一段道路方向的位移，power output为最终得到的P序列曲线）

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%206.png)

### 《在计时赛中确定自行车最佳功率分配的变分方法》

- BibTex：`de2016variational`

[A Variational Approach to Determine the Optimal Power Distribution for Cycling in a Time Trial](https://www.sciencedirect.com/science/article/pii/S1877705816307275)

- **关键词**：pacing strategy、Pontryagin's maximum principle、 singular control
- **假设1**：$F_{p}-F_{a}-F_{s}-F_{r}-F_{b}=m*a$
  
    Fp:推进力 propulsive force
    
    Fa:空气阻力 air resistance                                  = $K_{A}*(v+v_{wind})^2$
    
    Fs:坡面阻力 slope resistance                             = $mg*sin\omega$
    
    Fr:滚动阻力（滑动摩擦？） rolling resistance  = $mg*cos\omega*\mu$
    
    Fb: bump resistance(忽略不计)
    
    a:加速度 
    
- **推论1**：$P(t) = F_{p}*v(t) = (K_{A}(v+v_{w})^2+mg(sin\omega+C_{B})+m*dv(t)/dt)*v(t)$
  
    P(t):瞬时功率 v(t)：瞬时速度
    
- **推论1‘**：$v_{w}=0 =>P(t)=(c_{1}*v(t)^2+c_{2}+c_{3}*v'(t))*v(t)$

- **假设2**：骑手能量来源：有氧能量【aerobic energy】（可持续获得，能维持骑手临界功率CP【critical power】）、无氧能量【anaerobic energy】(在一次比赛中不可再生，即存在上限W)
- **推论2**：$CP<=P(t)<=P_{max}$ 超额部分$[P(t)-CP]$由无氧能量提供满足约束条件
  
    $\int_{0}^{T}[P(t)-CP]dt<=W$        T：总时间
    
- **变分法求解**：
  
    

### 《****作为最优控制问题的个人计时试验》****

[](https://journals.sagepub.com/doi/full/10.1177/1754337117705057)

证明了一些引理

力学分析积分证明

[Optimising distribution of power during a cycling time trial - Sports Engineering](https://link.springer.com/content/pdf/10.1007/BF02844006.pdf)

### 仿真：《公路自行车最佳配速策略的自适应反馈系统》

[Adaptive feedback system for optimal pacing strategies in road cycling - Sports Engineering](https://link.springer.com/article/10.1007/s12283-019-0294-5)

我们就是用的“方程式的速度的前向积分”

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%207.png)

## 空气阻力

### 《空气动力学对场地自行车运动的影响》

[Untitled](%E7%BE%8E%E8%B5%9B%2063dec73d978649008f16be9e0f9e7c02/Untitled%203.pdf)

- **提供了较为完整的关于空气阻力的数据**

### 《侧风对骑车人的影响：一项实验研究》

- BibTex：`fintelman2014effect`

[The Effect of Crosswinds on Cyclists: An Experimental Study](https://www.sciencedirect.com/science/article/pii/S1877705814006389)

- 侧重点：风的**方向**对受力影响
- 假设：不考虑湍流，逆风骑行
- 参数：
  
    > CdA气动阻力系数
    CsA气动侧力系数
    ClA气动升力系数
    CpA气动俯仰力矩系数
    CrA气动侧倾力矩系数
    CyA气动横摆力矩系数
- 受力分析：
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%208.png)
    
    其中逆风风向与自行车水平前进方向夹角（偏航角yaw angle）为 $\beta$。
    
- 风速$U_{\infin}$恒定，改变角度 $\beta$：
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%209.png)
    

### 《**骑行中的牵伸效果：风洞试验调查》**

- BibTex：`BELLOLI201638`

[Drafting Effect in Cycling: Investigation by Wind Tunnel Tests](https://www.sciencedirect.com/science/article/pii/S1877705816306336)

- 侧重点：**团队中后者风阻低**
- Drafting Effect：后面的骑行者由于前面骑行者的屏蔽作用，风阻显着降低，而消耗的能量更少
- 当侧向风存在时，对于轻风，牵伸效应也显着降低
- 风洞固定了自行车，因此：模拟在静止空气中骑自行车时，风洞风速对应于自行车的实际速度
- 计算阻力面积：$drag~area = \displaystyle \frac{drag~force}{\Delta p}=\frac{D}{\frac{1}{2}\rho V^2}$，其中V为纵向风速，侧向风速为U
- 前后两人风阻之差占百分比 与两人间距离、风向夹角关系：
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2010.png)
    
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2011.png)
    

### 《**最佳自行车计时赛位置模型：空气动力学与功率输出和代谢能量》**

[Optimal cycling time trial position models: Aerodynamics versus power output and metabolic energy](https://www.sciencedirect.com/science/article/pii/S0021929014001407)

- 实验数据
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2012.png)
    
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2013.png)
    
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2014.png)
    

### 《**两名骑车人的气动阻力的 CFD 模拟》**

[CFD simulations of the aerodynamic drag of two drafting cyclists](https://www.sciencedirect.com/science/article/pii/S0045793012004446#t0025)

### 《**自行车队计时赛中的空气阻力**》

[https://www.sciencedirect.com/science/article/pii/S0167610518306755](https://www.sciencedirect.com/science/article/pii/S0167610518306755)

多个人相互作用：

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2015.png)

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2016.png)

## 路线路况

### 转弯：《**在具有最佳控制的自行车个人计时赛中预测起搏和转弯策略》**

[Prediction of pacing and cornering strategies during cycling individual time trials with optimal control - Sports Engineering](https://link.springer.com/article/10.1007/s12283-020-00326-x)

- 在弯道上，最大速度由轮胎和道路之间的摩擦系数决定
- 转弯策略：
    - 缺乏动力输出能力的骑手：在整个弯道中保持高速，走尽量大曲率半径
    - 最佳策略：尽早提供动力输出 以获得更快的出口速度，并走尽量笔直的轨迹
      
        进入速度较低但退出速度较快，需要一个较晚的制动点、良好的制动能力
    
- 参数：
  
    ![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2017.png)
    

### 题设路线

### 【东京奥运会个人计时赛】

成绩：

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled.jpeg" alt="Untitled" style="zoom: 33%;" />

**ROUTE：**

[Men's Olympic Road Race 2021: Route, predictions and contenders](https://www.rouleur.cc/blogs/the-rouleur-journal/men-s-olympic-road-race-2021-route-predictions-and-contenders)

[Summer Olympics 2021 Tokyo: Route ITT - men](https://www.cyclingstage.com/summer-olympics-2021/route-itt-tokyo-2021/)

[https://www.sohu.com/a/246840290_115730](https://www.sohu.com/a/246840290_115730)

该路线从东京调布市的武藏野森林公园开始，经过从神奈川县通往山梨县的道志路，首先驶向山中湖。其后，驶向路线中海拔最高的富士山山脚，最后到达终点——富士山山脚下的一条高速公路。

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2018.png" alt="Untitled" style="zoom:50%;" />

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2019.png" alt="Untitled" style="zoom: 67%;" />

在2020年7月24号举办的比赛，选取的是山梨县大月市的天气预报，如果选用下午一点的数据来看，为北东方向2.7m/s，即-45度方向2.7m/s

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2020.png" alt="Untitled" style="zoom:50%;" />

查询网站为

[過去の天気(気象衛星・2021年07月) - tenki.jp](https://tenki.jp/past/2021/07/satellite/)

【UCI世界锦标赛个人计时赛成年男子组】

[彩虹衫花落谁家？2021年公路自行车UCI世锦赛前瞻 - 野途网](https://www.wildto.com/news/52976.html)

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2021.png" alt="Untitled" style="zoom:50%;" />

The start of the time trials is situated on the North Sea beach, near the casino. During the first 1.5 km the riders will ride along the sea, followed by a passage in the centre of Knokke-Heist. After that it goes inland. The scenery of this time trial? Channels and canals with typical trees that, marked by the wind, have grown diagonally. After 5 almost straight kilometres in Dudzele and a passage in the picturesque town of Damme, it heads towards the city of art Bruges and the finish on 't Zand.

### 【UCI世界锦标赛个人计时赛成年女子组】

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2022.png" alt="Untitled" style="zoom:50%;" />

The start of the time trials is situated on the North Sea beach, near the casino. During the first 1.5 km the riders will ride along the sea, followed by a passage in the centre of Knokke-Heist. After that it goes inland. The scenery of this time trial? Channels and canals with typical trees that, marked by the wind, have grown diagonally. After a passage in the picturesque town of Damme, it heads towards the city of art Bruges and the finish on 't Zand.

[布鲁日9月份天气,2021年9月份布鲁日的天气怎么样_国外天气](https://www.guowaitianqi.com/h/bruges-202109.html)

男子赛是2021.9.19，按照终点布鲁日的天气，为二级东南风，即-135度2.5m/s

女子赛是2021.9.20，按照终点布鲁日的天气，为二级东风，级-90度2.5m/s

### 路况信息

空气阻力系数：在上面的一篇文献中

滚动摩擦系数：（应该是BMX）

<img src="https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2023.png" alt="Untitled" style="zoom:67%;" />

## 词汇表

### VT1 第一通气阈值

是一种强度的标志，可以在人的呼吸中听到乳酸开始在血液中积聚的点。随着运动强度开始增加，可以在呼吸频率开始增加的点识别出 VT1。处于 VT1 的人在锻炼时不能再舒服地说话。

### VT2 第二通气阈值

是强度较高的标志，也可以在人的呼吸中听到。在 VT2 时，乳酸迅速积聚在血液中，人需要呼吸沉重，不能再以这种强度说话。此时，运动持续时间也会因强度级别而减少。该标记也可以称为无氧阈值或乳酸阈值。

### VO2 max 最大耗氧量

运动时人体输送和利用氧气的最大能力，反映了一个人的身体素质。测量 VO2 max 是一项实验室程序，需要设备来测量消耗的氧气量和排出的二氧化碳量。该测试将使个人达到他或她可以达到的绝对最大运动强度；此时也可以测量最大心率。0

### **Criterium**

在封闭赛道上进行的自行车比赛。长度可以通过固定的圈数或预定时间段内的最多圈数来指定。

### **Directeur Sportif**

车队主管，负责管理车手和工作人员，制定比赛决策，并决定特定比赛的车队组成。

### **Individual Time Trial**个人计时赛

骑手一次穿越预定路线的赛事。不允许骑手一起工作或彼此靠近。 记录每位骑手穿越赛道所需的时间。时间越短，骑手的最终排名越好。

### **Power Curve**功率曲线

是骑手在特定时间内可以保持的最大功率的直观表示。

- 骑手产生的功率越大，骑手在必须降低功率以恢复精力之前 保持该概率的时间就越短
- 超过超过功率曲线上限之后需要保持较低功率恢复
- 随着比赛的进行，骑手越来越疲劳
- 骑手在整个过程中可以消耗的总能量有限制
- 过去的超过功率曲线上限的累加有限制

[自行车功率训练中的临界功率的概念与应用](https://zhuanlan.zhihu.com/p/448008831)

[Untitled](%E7%BE%8E%E8%B5%9B%2063dec73d978649008f16be9e0f9e7c02/Untitled%204.pdf)

![Untitled](https://umeta.oss-cn-beijing.aliyuncs.com/blog/Untitled%2024.png)

### 运动员类型

### 【time trialist】

公路自行车赛车手，专门从事个人计时赛的骑手

可以长时间保持高速，以在个人或团队计时赛中最大限度地发挥性能，必须能够在整个赛事中保持稳定的努力，
衡量标准被认为是骑手在乳酸阈值(LT) 或有氧阈值(AT) 时的力量
具有出色的空气动力学姿势并能够吸收大量氧气
能够参加除最陡坡以外的所有比赛，因为他们具有良好的功率重量比
在团队合作中work as domestiques for their team leaders, or participate in breakaways

[Time trialist - Wikipedia](https://en.wikipedia.org/wiki/Time_trialist#:~:text=A%20time%20trialist%20is%20a,individual%20or%20team%20time%20trials)

### 【climber】

专门从事多次长距离攀爬比赛的骑手，也称为grimpeur ，是公路自行车赛车手，可以在高度倾斜的道路上骑行特别好，例如在丘陵或山区发现的道路
具有很强的耐力，并且特别发达的肌肉可以进行长时间的艰苦攀登。他们也往往拥有苗条、轻盈的体格
团队部署中作为 Super-domestiques，通过在山地赛段设置强节奏来阻止对手的攻击，保护具有全方位能力的团队领导者，'train'战术

[Climbing specialist - Wikipedia](https://en.wikipedia.org/wiki/Climbing_specialist#:~:text=A%20climbing%20specialist%20or%20climber,found%20among%20hills%20or%20mountains)

### 【sprinter】

专门在短时间内产生极高功率的骑手。这些骑手通常专注于在比赛结束时获胜或在中间冲刺期间（如果比赛有中间冲刺）

是公路自行车赛车手或田径赛车手，他们可以通过快速加速到高速来以极具爆发力的方式完成比赛，[1]通常在战术上使用另一个骑自行车的人或一群骑自行车的人的滑流来节省能量
通常较重，将他们的速度优势限制在相对平坦的部分
可能会等到最后几百米，然后再加快速度以赢得比赛
团队中需要“领跑者”（即保持高速度并保护短跑运动员）

[Sprinter (cycling) - Wikipedia](https://en.wikipedia.org/wiki/Sprinter_(cycling)#:~:text=A%20sprinter%20is%20a%20road,cyclists%20tactically%20to%20conserve%20energy)

### 【rouleur】

优秀的多面手的赛车手
可以很好地驾驭大多数类型赢得赛段的最佳机会是在比赛期间脱离主力群，从不包含短跑专家的一小群车手中获胜
突破最有可能在多阶段公路比赛的起伏过渡阶段取得成功，既不是山地也不是平坦的。
团队中work as a domestique in support of their team leader, a sprinter or a climber on their team

[Rouleur - Wikipedia](https://en.wikipedia.org/wiki/Rouleur#:~:text=A%20rouleur%20is%20a%20type,considered%20a%20good%20all-rounder)

### 【puncheur】

专门从事包括许多短而陡峭的攀爬或许多急剧加速的比赛的骑手公路自行车赛车手

专门研究具有短而陡峭爬坡的起伏地形，擅长多座山丘，坡度为 10-20%，长 1-2 公里，能够冲刺较短的爬坡，较低的耐力是在爬坡通常较长（5-20 公里）的阶段比赛中的劣势，尽管坡度较低（5-10%）
团队中work as domestiques for team leaders, reeling in breakaways, or go on the attack to force rival teams to expend energy to close them down