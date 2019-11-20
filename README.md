# UAV 跟踪工具包

本工具包主要用于目标跟踪中使用UAV拍摄的数据集的运行和评估，包括UAV123、UAV123_20L、UAV123_10fps、DTB70、UAVDT以及VisDrone2018-SOT-test-dev共6个数据集。

以下为6个数据集的主要属性：

| Dataset                   | Overall frames | Average frames | Sequences number | Paper                                                        |
| ------------------------- | -------------- | -------------- | ---------------- | ------------------------------------------------------------ |
| UAV123                    | 112,578        | 915.27         | 123              | "A Benchmark and Simulator for UAV Tracking." ECCV (2016)    |
| DTB70                     | 15,777         | 225.39         | 70               | "Visual Object Tracking for Unmanned Aerial Vehicles: A Benchmark and New Motion Models." AAAI (2017) |
| UAVDT                     | 37,084         | 741.68         | 50               | "The Unmanned Aerial Vehicle Benchmark: Object Detection and Tracking." ECCV (2018) |
| UAV123_10fps              | 37,607         | 305.75         | 123              | "A Benchmark and Simulator for UAV Tracking." ECCV (2016)    |
| UAV123_20L                | 58,670         | 2933.5         | 20               | "A Benchmark and Simulator for UAV Tracking." ECCV (2016)    |
| VisDrone2018-SOT-test-dev | 29,365         | 839            | 35               | "Vision Meets Drones: A Challenge."arXiv(2018)               |

## RunUAVTrackers

该模块用于单次运行所有的trackers，使用方法如下：

1. 将trackers放入tracker_set。

2. 打开run_all_trackers_"name of dataset", 更改函数文件中的数据集的图片与groundtruth地址。

3. 打开trackers_info，添加需要跑的trackers。

4. 点击“运行”，开始运行程序。

   注意：该模块是一个接口，输入到跟踪方法的只有seq这一个结构体

   跟踪的结果会按照数据集保存到all_trk_results文件夹中。

## RunUAVLoops

该模块用于遍历新的tracker进行调参，找到最好的参数组匹配，使用方法如下：

1. 将tracker放入tracker_set。

2. 打开LoopsOn"name of dataset", 更改函数文件中的数据集的图片与groundtruth地址

3. 在LoopsOn"name of dataset"中修改tracker的运行结构体。

4. 手动输入需要遍历的参数的名称以及需要遍历的值。

5. 在需要遍历的tracker的接口函数run_tracker中添加与LoopsOn“name of dataset"相同的输入变量，并赋值给需要用的变量。

   注意：该遍历是序列优先的原则，即遍历完一个序列后，再跑下一个。如果暂停的话，可以修改起始的序列号继续跑。

   跟踪的结果会按照数据集保存到loop_results当中，每次遍历的名称是由tracker的名称加上参数名、参数值组成。

## RunUAVGroup

该模块用于跑trakcer的多组参数，相比遍历跑的次数要少，使用方法如下：

1. 将tracker放入tracker_set。
2. 打开run_group_"name of dataset", 更改函数文件中的数据集的图片与groundtruth地址
3. 在run_group_"name of dataset"中修改tracker的运行结构体。

4. 手动输入需要运行的多组参数值及参数名称。

5. 在需要运行的tracker的接口函数run_tracker中添加与run_group_"name of dataset"相同的输入变量，并赋值给需要用的变量。

   注意：该运行是序列优先的原则，即运行完一个序列后，再跑下一个。如果暂停的话，可以修改起始的序列号继续跑。

   跟踪的结果会按照数据集保存到group_results当中，每次遍历的名称是由tracker的名称加上参数名、参数值组成。

   

## Benchmarks

用于数据集运行的6个benchmarks主要借鉴lfl大神的程序，跟踪性能图及跟踪结果请请参考他的https://github.com/zerolfl/V4R-Evaluation。

使用事项：

1. 将以上所说的运行结果以tracker为单位复制到benchmarks里的results/results_OPE中，打开perfPlot修改dataset后，点击运行即可画出性能图。
2. 针对不同属性、不同视频序列绘图使用AboutAllRes以及AboutAtt，生成FPS结果请使用AboutFPS，绘制每一帧的所有trackers的跟踪可视化图请使用drawResultBB，制作视频请使用makeVideo，以上内容会保存到dataAnaly中。

### 如有问题请及时指出，最新的一些tracker，如ARCF，ASRCF的结果我们还在跑，不久将会更新。