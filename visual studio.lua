vs引入lib库时,在链接时如果出现LNK2001等，而且有警告 “LINK : warning LNK4098: 默认库“LIBCMT”与其他库的使用冲突；请使用 /NODEFAULTLIB:library”
  解决方法：
    项目->c/c++->代码生成->运行库 选择 “多线程调试(/MTd)”
  注意：项目->c/c++->常规->附加包含目录 中必须添加相对路径 用$(ProjectDir)后面加文件路径，例如$(ProjectDir)gflags_win。$(ProjectDir)表示当前项目路径