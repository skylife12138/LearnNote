vs引入lib库时,在链接时如果出现LNK2001等，而且有警告 “LINK : warning LNK4098: 默认库“LIBCMT”与其他库的使用冲突；请使用 /NODEFAULTLIB:library”
  解决方法：
    项目->c/c++->代码生成->运行库 选择 “多线程调试(/MTd)”