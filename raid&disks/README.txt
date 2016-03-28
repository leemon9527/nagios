# nagios
这个是个人用于监控服务器的RAID卡状态与物理硬盘状态写的nagios nrpe的脚本

分为ESXI,linux与windows服务器

ESXI：

    由于无法自定义命令行写脚本，借用https://github.com/Napsty/check_esxi_hardware

公司所有服务器的RAID卡分别为 Dell PERC H510 Mini，Dell PERC H710 Mini，Dell SAS 6/iR

其中H710,H510可使用MegaCli来管理，SAS 6/iR使用lsiutil来进行管理

Linux：

    所有的监控脚本都是基于RAID卡管理工具获取的结果来分析并得出监控结果返回
    
    注意事项：由于linux上面的nrpe使用普通用户nagios来运行的，而raid卡管理工具命令行需要管理员权限运行，所以需要配置sudo权限
    
Windows:

    使用python作为监控脚本编写语言，为避免安装python语言环境，脚本直接打包成.exe
    
    windows服务器的nrpe运行在system用户下，不需要特殊的权限配置
    
    windows服务器上面的思路是使用bat脚本调用RAID卡管理工具将结果生成到文件，然后通过python分析并返回结果
    
