##一.git clone git@skylife12138/LearnRep.git时遇到报错：
  **ssh_exchange_identification: read: Software caused connection abort**   
  **报错原因：**  
     主要可能是防火墙导致连接git服务器失败；  
  **解决方法：**  
     使用http连接:git clone https://github.com/skylife12138/LearnRep  
  **参考文档：**  
    https://stackoverflow.com/questions/46274017/git-ssh-exchange-identification-read-software-caused-connection-abort
	
##二.从githun或gitee上clone项目修改提交步骤：  
1.在本地新建文件夹，不需要git init;  
2.进入文件夹中用git clone http://xxxxxx;  
3.进入克隆下的文件中，次文件已经被init了,在此文件中可以push,pull等操作,且这个文件的分支名与github或gitee上的分支名一样；  
3.提交时用第一次用git push -u origin learn(这个就是远程仓库上的分支名),以后用git push  

##三.连接github时可能因为墙的原因导致速度很慢，clone等操作超时，提示fatal: The remote end hung up unexpectedly
  **解决方案：** ubuntu修改/etc/hosts(windows下C:\Windows\System32\drivers\etc\HOST)文件添加如下ip隐射   
             ***192.30.253.113 github.com***  
  **参考文档：**https://blog.csdn.net/ITleaks/article/details/80351680