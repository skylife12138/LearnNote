本文将libevent,zeromq,和muduo三个网络库进行对比分析:

libevent:
1.数组定义TAILQ_HEAD和TAILQ_ENTRY：

    #define TAILQ_HEAD(name, type)						\
    struct name {								\
        struct type *tqh_first;	/* first element */			\
        struct type **tqh_last;	/* 二级指针指向最后一个type的tqe_prev变量 */		\
    }
     
    //和前面的TAILQ_HEAD不同，这里的结构体并没有name.即没有结构体名。
    //所以该结构体只能作为一个匿名结构体。所以，它一般都是另外一个结构体
    //或者共用体的成员
    #define TAILQ_ENTRY(type)						\
    struct {								\
        struct type *tqe_next;	/* next element */			\
        struct type **tqe_prev;	/* address of previous next element */	\
	}
2.信号event的处理
  采用统一事件源的方式来处理信号event,即将信号转换成IO来处理。
  
  统一事件源的工作原理如下：假如用户要监听SIGINT信号，那么在实现的内部就对SIGINT这个信号设置捕抓函数。此外，在实现的内部还要建立一条管道(pipe)，
  并把这个管道加入到多路IO复用函数中。当SIGINT这个信号发生后，捕抓函数将会被调用。而这个捕抓函数的工作就是往管道写入一个字符(这个字符往往等于所捕抓到信号的信号值)。
  此时，这个管道就变成是可读的了，多路IO复用函数能检测到这个管道变成可读的了。换言之，多路IO复用函数检测到SIGINT信号的发生，也就完成了对信号的监听工作。
  
  具体实现细节：
  1.创建一个管道(实际上使用socketpair);
  2.为这个socketpair的一个读端创建一个event,并将之加入到多路IO复用函数的监听中；
    说明:以上2条都是在选定一个多路IO复用函数后，就会调用:
	         base->evbase = base->evsel->init(base);
		  选定的IO复用Init函数会创建一个socketpair,并将其读端与ev_signal这个event相关联，用于监听信号；
  3.设置信号抓捕函数;
  4.有信号发生，往socketpair写入一个字节;
    说明:函数event_add会将信号event加入到event_base中,其中会调用到信号event的add函数evsig_add,此函数中会设置libevent的信号抓捕函数，并将ev_signal作为信号监听的时间来通知
	     event_base有信号发生了。只需一个event即可完成工作，即使用户要监听多个不同的信号，因为这个event已经和socketpair的读端相关联了。如果要监听多个信号，
		 那么就在信号处理函数中往这个socketpair写入不同的值即可。event_base能监听到可读，并可以从读到的内容可以判断是哪个信号发生了。
		 
		 注意：当我们对某个信号进行event_new和event_add后，就不应该再次设置该信号的信号捕抓函数。否则event_base将无法监听到信号的发生。
	
3.bufferevent:用于管理和调度IO事件，托管客户端连接上的读事件，写时间，和事件处理。
  主要函数包括：
      //创建一个Bufferevent  
      struct bufferevent *bufferevent_socket_new(struct event_base *base, evutil_socket_t fd, enum bufferevent_options options); 
	  
	  //释放Bufferevent
      void bufferevent_free(struct bufferevent *bev); 
	  
	  //设置回调函数
	  void bufferevent_setcb(struct bufferevent *bufev,bufferevent_data_cb readcb,bufferevent_data_cb writecb,bufferevent_event_cb eventcb,void *cbarg);
	  
	  //设置buffer时间类型
	  bufferevent_enable(bev, EV_READ|EV_WRITE|EV_PERSIST);
	  
	  //设置水位
	  void bufferevent_setwatermark(struct bufferevent *bufev, short events,size_t lowmark, size_t highmark);
	  
	  //写入  
      int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size);
	  
      //输出  
      size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size);
	  
  水位设置说明：
   低水位:表示当evbuffer缓冲区的数据少于该水位时，不会触发用户设定的读回调函数；
   高水位:表示当evbuffer缓冲区的数据大于该水位时，将不会从socket的缓冲区继续读取数据，避免了因socket缓冲区有数据而一直触发监听读的event形成的死循环。当水位低于该水位时将继续从socket缓冲区读取数据；
  读监听和写监听的区别：
   读监听:当监听读事件的event检测到socket读缓冲区有数据时即认为可读，触发读回调函数；
   写监听:当监听写事件的event检测到socket写缓冲区可写时认为可写，调用写回调函数,因为socket写缓冲区大部分时间都是空的，所以这样判断会导致event一直触发写回调函数，造成死循环。实际libevent只用在调用写入函数bufferevent_write时
         才会将监听写的事件event添加(event_add)到event_base中进行监听，当所有数据都写入到socket缓冲区后就从event_base删除event,避免形成死循环；
4.evbuffer:
  
   //evbuffer-internal.h文件
   struct evbuffer_chain;
   struct evbuffer {
   	   struct evbuffer_chain *first;
   	   struct evbuffer_chain *last;
   	     //这是一个二级指针。使用*last_with_datap时，指向的是链表中最后一个有数据的evbuffer_chain。
   	     //所以last_with_datap存储的是倒数第二个evbuffer_chain的next成员地址。
   	     //一开始buffer->last_with_datap = &buffer->first;此时first为NULL。所以当链表没有节点时
   	     //*last_with_datap为NULL。当只有一个节点时*last_with_datap就是first。	
   	   struct evbuffer_chain **last_with_datap;
       
   	   size_t total_len;//链表中所有chain的总字节数
       
   	   ...
   };
    
   
   struct evbuffer_chain {
   	   struct evbuffer_chain *next;
   	   size_t buffer_len;//buffer的大小
       
   	   //错开不使用的空间。该成员的值一般等于0
   	   ev_off_t misalign;
       
   	   //evbuffer_chain已存数据的字节数
   	   //所以要从buffer + misalign + off的位置开始写入数据
   	   size_t off;
       
   	   ...
   	   
   	   unsigned char *buffer;
	};
	
	
   