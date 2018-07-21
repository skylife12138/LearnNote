##网络模型：
  1.select;  
  2.iocp;    --proactor模式  
  3.epoll;   --reactor模式  
  4.kqueue;  --reactor模式   
##开源网络库：  
  1.ACE;  
  2.ASIO;  
  3.Libevent;  

##IOCP:完成端口
1.初始化work线程池,线程数量为cpu数量*2,监听和客户端连接线程都从work线程中分配,并为每个线程创建一个完成端口；  
2.从work线程池中分配一个监听线程,执行基本的绑定监听流程,同时监听128个连接,并将监听端口和监听线程的完成端口绑定，然后投递128个AcceptEx；  
3.当有客户端请求连接服务器时,监听线程执行 **OnAccept**，在OnAccept中创建连接端口,并为其从work线程中分配并绑定一个线程,将连接端口与绑定的线程中的完成端口绑定,并向连接端口投递 **WSARecv**;  
4.然后这个连接的客户端就会在其连接端口分配的线程上与服务器进行通信,包括发送接收消息,消息统一都是完成端口返回,通过switch不同的类型进行不同的操作；  

注:1.完成端口是绑定在监听端口上的;  

##Epoll:
1.初始化work线程池，线程输了为cup数量*2，监听和客户端连接线程都从work线程分配，每个线程调用 **epoll_create(maxscoke)**  函数监听maxscoke数量的端口；  
2.监听端口进行完绑定等操作后会分配到一个工作线程，该线程会调用**epoll_ctl()**添加(EPOLL_CTL_ADD)文件描述符(端口),其中网络事件为EPOLLIN；
3.当有客户端连接或者通讯时, **epoll_wait()**函数会获取内核就绪的文件描述符，并根据其网络事件类型进行不同的处理,处理完后将该端口的网络事件change成初始状态，如EPOLLOUT或EPOLLIN，以便在内核中继续等待网络事件进行处理；

###IOCP为windows特有的网络模型，该模型在通知应用程序网络事件时内核已经完成了消息的拷贝，所以为非阻塞的；
###Epoll为linux特有的网络模型，该模型是在内核中维护着一个红黑树，保存着需要等待消息的文件描述符，并为每个注册的文件描述符添加了一个回调函数，如果有网络事件到来，对应文件描述符调用回调函数通知应用程序，然后应用程序获取网络消息，这块使用了共享内存mmap来保证不用拷贝消息达到高效；
###IOCP和Epoll都适合于高并发的网络环境，而select和poll则因为采用了轮询机制，每次都要将所有等待端口遍历一次来查找已经就绪的网络事件，导致其效率不高；
