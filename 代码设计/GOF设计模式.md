

# [参考资料](https://design-patterns.readthedocs.io/zh_CN/latest/creational_patterns/simple_factory.html)

## 创建型

### 抽象工厂

**定义：**抽象工厂模式提供了一个创建一系列相关或者相互依赖对象的接口，无需指定它们具体的类

适用场景：

- 客户端（应用层）不依赖于产品类实例如何被创建、实现等细节
- 强调一系列相关的产品对象（属于同一产品族）一起使用创建对象需要大量的重复代码
- 提供一个产品类的库，所有的产品以同样的接口出现，从而使得客户端不依赖于具体的实现

优点：

- 具体产品在应用层的代码隔离，无需关心创建的细节
- 将一个系列的产品统一到一起创建

缺点：

- 规定了所有可能被创建的产品集合，产品簇中扩展新的产品困难
- 增加了系统的抽象性和理解难度

为了更好理解抽象工厂模式，需要先搞清楚产品等级和产品族的概念，举个粟子：手机有小米手机、华为手机，它们都是手机，这些具体的手机和抽象手机就构成了一个产品等级结构。同样的，路由器有小米路由器，华为路由器，这些具体的路由器和抽象路由器就构成了另外一个产品等级结构，实质上**产品等级结构即产品的继承结构**。小米手机位于手机产品等级结构中，小米路由器位于路由器的产品等级结构中，而小米手机和小米路由器都是小米公司生产的，就构成了一个产品族，同理，华为手机和华为路由器也构成了一个产品族 。划重点就是**产品族中的产品都是由同一个工厂生产的，位于不同的产品等级结构**

````c++
* 抽象产品工厂（定义了同一个产品族的产品生产行为）
 */
public interface IProductFactory {

    /**
     * 生产手机
     * @return
     */
    IPhoneProduct produceTelPhone();

    /**
     * 生产路由器
     * @return
     */
    IRouterProduct produceRouter();
    
    /**
     * 生产笔记本（新增）
     * @return
     */
    IComputerProduct produceComputer();

}
````

**产品族难拓展，产品等级易拓展**。

例如上面的抽象工厂类，新加“生产笔记本”产品时，除了抽象工厂类需要添加，所有的子类，包括小米，华为等都都需要加“笔记本”产品的实现。**所以抽象工厂类只有在产品类型比较稳定，产品等级可以随时变化的情况下使用比较合理。**

### 工厂方法

**定义：**定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

**优点：** 

- 1、一个调用者想创建一个对象，只要知道其名称就可以了。 
- 2、扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。 
- 3、屏蔽产品的具体实现，调用者只关心产品的接口。

**缺点：**

- 每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。

还是以上面的小米，华为为例子：

```
/**
 * 手机产品接口
 */
public interface IPhoneProduct {

    /**
     * 开机
     */
    void start();

    /**
     * 关机
     */
    void shutdown();
    
    /**
     * 拨打电话
     */
    void callUp();
    
    /**
     * 发送短信
     */
    void sendSMS();
}

/**
 * 路由器产品接口
 */
public interface IRouterProduct {

    /**
     * 开机
     */
    void start();

    /**
     * 关机
     */
    void shutdown();

    /**
     * 开启wifi
     */
    void openWifi();

    /**
     * 设置参数
     */
    void setting();
}
```

小米手机和华为手机都继承自手机类，小米路由器和华为路由器都继承自路由器类。**工厂模式适合产品族变化频繁的情况，但如果产品等级太多，需要创建的子类过多会增加系统复杂度。**

### 生成器/创建者模式

**定义：**将一个复杂的对象的**构建**与它的**表示**分离，使得同样的构建过程可以创建不同的表示。隐藏了复杂对象的创建过程，它把复杂对象的创建过程加以抽象，通过子类继承或者重载的方式，动态的创建具有复合属性的对象。

**优点：**

- 使用建造者模式可以使客户端不必知道产品内部组成的细节

- 具体的建造者类之间是相互独立的，这有利于系统的扩展。

- 具体的建造者相互独立，因此可以对建造的过程逐步细化，而不会对其他模块产生任何影响。  

**缺点：**

- 建造者模式所创建的产品一般具有较多的共同点，其组成部分相似；如果产品之间的差异性很大，则不适合使用建造者模式，因此其使用范围受到一定的限制。

- 如果产品的内部变化复杂，可能会导致需要定义很多具体建造者类来实现这种变化，导致系统变得很庞大。

**建造者模式与抽象工厂模式的比较：**

- 与抽象工厂模式相比，建造者模式返回一个组装好的完整产品，而抽象工厂模式返回一系列相关的产品，这些产品位于不同的产品等级结构，构成了一个产品族 。
- 在抽象工厂模式中，客户端实例化工厂类，然后调用工厂方法获取所需产品对象，而在建造者模式中，客户端可以不直接调用建造者的相关方法，而是通过指挥者类来指导如何生成对象，包括对象的组装过程和建造步骤，它侧重于一步步构造一个复杂对象，返回一个完整的对象 。
- 如果将抽象工厂模式看成汽车配件生产工厂，生产一个产品族的产品，那么建造者模式就是一个汽车组装工厂，通过对部件的组装可以返回一辆完整的汽车

### 原型模式

**定义：**即“克隆”，原型二字表明了该模式应该有一个样板实例，用户从这个样板对象中复制一个内部属性一致的对象，这个过程也就是我们称的“克隆”。被复制的实例就是我们所称的“原型”，这个原型是可定制的。

**优点：**

- 逃脱构造函数的约束。
- 性能提高

**缺点：**

- 必须实现 Cloneable 接口。
- 配备克隆方法需要对类的功能进行通盘考虑，这对于全新的类不是很难，但对于已有的类不一定很容易，特别当一个类引用不支持串行化的间接对象，或者引用含有循环结构的时候。

**原型模式适用于需要大量实例化且构造函数消耗较大，如一个对象需要在一个高代价的数据库操作之后被创建。我们可以缓存该对象，在下一个请求时返回它的克隆，在需要的时候更新数据库，以此来减少数据库调用。使用原型模式减小消耗。**

**注意：**原型模式拷贝时有两种方式**浅拷贝**和**深拷贝**。

- **浅拷贝**只是拷贝了基本类型的数据，而引用类型数据，复制后也是会发生引用，换句话说，浅复制仅仅是指向   被复制的内存地址，如果原地址中对象被改变了，那么浅复制出来的对象也会相应改变。
- **深拷贝**是在新申请一块内存来存储拷贝后对象的数据。

### 单例模式

**定义：**一个类仅有一个实例，并提供一个访问它的全局访问点。

**优点：**

- 在内存里只有一个实例，减少了内存的开销，尤其是频繁的创建和销毁实例。
- 避免对资源的多重占用（比如写文件操作）。

**缺点：**

- 没有接口，不能继承，与单一职责原则冲突，一个类应该只关心内部逻辑，而不关心外面怎么样来实例化。

**单例模式构造函数必须是私有成员，且只能有一个实例，同时必须自己创建这个实例，提供给其他对象调用。**

## 结构型

### 适配器

- 将一个类的接口转换成客户希望的另外一个接口。

- 适配器模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
- 适配器不是在详细设计时添加的，而是解决正在服役的项目的问题。
- eg:美国电器 110V，中国 220V，就要有一个适配器将 110V 转化为 220V。

### 桥接

**常用的场景**
1.当一个对象有多个变化因素的时候，考虑依赖于抽象的实现，而不是具体的实现。如上面例子中手机品牌有2种变化因素，一个是品牌，一个是功能。

2.当多个变化因素在多个对象间共享时，考虑将这部分变化的部分抽象出来再聚合/合成进来，如上面例子中的通讯录和游戏，其实是可以共享的。

3.当我们考虑一个对象的多个变化因素可以动态变化的时候，考虑使用桥接模式，如上面例子中的手机品牌是变化的，手机的功能也是变化的，所以将他们分离出来，独立的变化。

**优点**
1.将实现抽离出来，再实现抽象，使得对象的具体实现依赖于抽象，满足了依赖倒转原则。

2.将可以共享的变化部分，抽离出来，减少了代码的重复信息。

3.对象的具体实现可以更加灵活，可以满足多个因素变化的要求。

**缺点**
1.客户必须知道选择哪一种类型的实现。

### 组合

**定义：** 将对象组合成树形结构以表示“部分-整体”的层次结构。组合使得用户对单个对象和组合对象的使用具有一致性。注意两个字“树形”。

这种树形结构在现实生活中随处可见，比如一个集团公司，它有一个母公司，下设很多家子公司。不管是母公司还是子公司，都有各自直属的财务部、人力资源部、销售部等。对于母公司来说，不论是子公司，还是直属的财务部、人力资源部，都是它的部门。整个公司的部门拓扑图就是一个树形结构。

````
 1 class Company  
 2 {
 3 public:
 4     Company(string name) { m_name = name; }
 5     virtual ~Company(){}
 6     virtual void Add(Company *pCom){}
 7     virtual void Show(int depth) {}
 8 protected:
 9     string m_name;
10 };
11 //具体公司
12 class ConcreteCompany : public Company  
13 {
14 public:
15     ConcreteCompany(string name): Company(name) {}
16     virtual ~ConcreteCompany() {}
17     void Add(Company *pCom) { m_listCompany.push_back(pCom); } //位于树的中间，可以增加子树
18     void Show(int depth)
19     {
20         for(int i = 0;i < depth; i++)
21             cout<<"-";
22         cout<<m_name<<endl;
23         list<Company *>::iterator iter=m_listCompany.begin();
24         for(; iter != m_listCompany.end(); iter++) //显示下层结点
25             (*iter)->Show(depth + 2);
26     }
27 private:
28     list<Company *> m_listCompany;
29 };
30 //具体的部门，财务部
31 class FinanceDepartment : public Company 
32 {
33 public:
34     FinanceDepartment(string name):Company(name){}
35     virtual ~FinanceDepartment() {}
36     virtual void Show(int depth) //只需显示，无限添加函数，因为已是叶结点
37     {
38         for(int i = 0; i < depth; i++)
39             cout<<"-";
40         cout<<m_name<<endl;
41     }
42 };
43 //具体的部门，人力资源部
44 class HRDepartment :public Company  
45 {
46 public:
47     HRDepartment(string name):Company(name){}
48     virtual ~HRDepartment() {}
49     virtual void Show(int depth) //只需显示，无限添加函数，因为已是叶结点
50     {
51         for(int i = 0; i < depth; i++)
52             cout<<"-";
53         cout<<m_name<<endl;
54     }
55 };
````

```
 1 int main()
 2 {
 3     Company *root = new ConcreteCompany("总公司");
 4     Company *leaf1=new FinanceDepartment("财务部");
 5     Company *leaf2=new HRDepartment("人力资源部");
 6     root->Add(leaf1);
 7     root->Add(leaf2);
 8 
 9     //分公司A
10     Company *mid1 = new ConcreteCompany("分公司A");
11     Company *leaf3=new FinanceDepartment("财务部");
12     Company *leaf4=new HRDepartment("人力资源部");
13     mid1->Add(leaf3);
14     mid1->Add(leaf4);
15     root->Add(mid1);
16     //分公司B
17     Company *mid2=new ConcreteCompany("分公司B");
18     FinanceDepartment *leaf5=new FinanceDepartment("财务部");
19     HRDepartment *leaf6=new HRDepartment("人力资源部");
20     mid2->Add(leaf5);
21     mid2->Add(leaf6);
22     root->Add(mid2);
23     root->Show(0);
24 
25     delete leaf1; delete leaf2;
26     delete leaf3; delete leaf4;
27     delete leaf5; delete leaf6;    
28     delete mid1; delete mid2;
29     delete root;
30     return 0;
31 }
```

### 装饰

装饰模式能够实现动态的为对象添加功能，是从一个对象外部来给对象添加功能。在不必改变原类文件和使用继承的情况下，动态地扩展一个对象的功能。它是通过创建一个包装对象，也就是装饰来包裹真实的对象。

[参考资料](https://blog.csdn.net/yongh701/article/details/49080311)

### 外观

**定义：**为子系统中的一组接口提供一个一致的界面，外观模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。

**例子：**

电脑整机是 CPU、内存、硬盘的外观。有了外观以后，启动电脑和关闭电脑都简化了。

直接 new 一个电脑。

在 new 电脑的同时把 cpu、内存、硬盘都初始化好并且接好线。

对外暴露方法（启动电脑，关闭电脑）。

启动电脑（按一下电源键）：启动CPU、启动内存、启动硬盘

关闭电脑（按一下电源键）：关闭硬盘、关闭内存、关闭CPU

````
/** * 电脑接口 */
public interface Computer {
    void open();
}

/** * CPU类 */
class Cpu implements Computer {
    @Override
    public void open() {
        System.out.println("启动CPU");
    }
}

/** * 内存类 */
class Ddr implements Computer {
    @Override
    public void open() {
        System.out.println("启动内存");
    }
}

/** * 硬盘类 */
class Ssd implements Computer {
    @Override
    public void open() {
        System.out.println("启动硬盘");
    }
}
/** * 外观类 */
public class Facade {
    private Computer cpu;
    private Computer ddr;
    private Computer ssd;

    /** * 启动cpu */
    public void onCPU() {
        cpu = new Cpu();
        cpu.open();
    }

    /** * 启动内存 */
    public void onDDR() {
        ddr = new Ddr();
        ddr.open();
    }

    /** * 启动硬盘 */
    public void onSSD() {
        ssd = new Ssd();
        ssd.open();
    }
}

public class FacadeTest34 {
    public static void main(String[] args) {
        Facade facade = new Facade();
        facade.onSSD();
    }
}
````

### 享元

**用途：**主要用于减少创建对象的数量，以减少内存占用和提高性能。

在某些对象需要重复创建，且最终只需要得到单一结果的情况下使用。因为此种模式是利用先前创建的已有对象，通过某种规则去判断当前所需对象是否可以利用原有对象做相应修改后得到想要的效果。此模式适用于结果注重单一结果的情况。

[参考资料](https://www.runoob.com/design-pattern/flyweight-pattern.html)

### 代理

**定义：**为其他对象提供一种代理以控制对这个对象的访问。这样实现了业务和核心功能分离。

**优点：** 

- 1、职责清晰。 
- 2、高扩展性。 
- 3、智能化。

**缺点：** 

- 1、由于在客户端和真实主题之间增加了代理对象，因此有些类型的代理模式可能会造成请求的处理速度变慢。

-  2、实现代理模式需要额外的工作，有些代理模式的实现非常复杂。

[参考资料](https://blog.csdn.net/lh844386434/article/details/18045671)

## 行为模式

### 职责链

**定义：**使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系。将这些对象连成一条链，并沿着这条链传递该请求，直到有一个对象处 理它为止。

**举例：**

其思想很简单，考虑员工要求加薪。公司的管理者一共有三级，总经理、总监、经理，如果一个员工要求加薪，应该向主管的经理申请，如果加薪的数量 在经理的职权内，那么经理可以直接批准，否则将申请上交给总监。总监的处理方式也一样，总经理可以处理所有请求。这就是典型的职责链模式，请求的处理形成 了一条链，直到有一个对象处理请求。

[参考资料](https://www.cnblogs.com/onlycxue/p/3503658.html)

### 命令

**定义：**将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤销的操作。

在OOP中，一切都是对象，将请求封装成对象，符合OOP的设计思想，当将客户的单个请求封装成对象以后，我们就可以对这个请求存储更多的信息，使请求拥有更多的能力；命令模式同样能够把请求发送者和接收者解耦，使得命令发送者不用去关心请求将以何种方式被处理。

**举例：**我们去餐厅吃饭，我们是通过服务员来点菜，具体是谁来做这些菜和他们什么时候完成的这些菜，其实我们都不知道。抽象之，我们是“菜单请求者”，厨师是“菜单实现者”，二者之间是松耦合的，我们对这些菜的其他一些请求比如“撤销，重做”等，我们也不知道是谁在做。

[参考资料](https://www.cnblogs.com/lizhanwu/p/4435359.html)

### 解释器

**定义：**给定一门语言，定义他的文法的一种表示，并定义一个解释器，该解释器使用该表示来解释语言中的句子

**优点：**是一个简单的语法分析工具，扩展性良好，修改语法只需要修改相对应的非终结符表达式就可以了，扩展语法只需要增加非终结符类即可

**缺点：**

- 解释器模式引起类膨胀

- 采用递归调用方式

- 效率问题，循环和引用太多

**使用场景：**

- 重复发生的事情可以用解释器模式（日志分析等）
- 一个简单语法需要解释的场景  

**举例：**

````
#pragma once
#include<stack>
#include<iostream>
using namespace std;
class Object;
class Context;
//抽象表达式

//抽象表达式是生成语法集合/语法树的关键，每个语法集合完成指定语法解析任务，通过递归调用方式完成
class Expression
{
public:
    virtual Object* interpreter(Context *ctx) = 0
    {
        cout << "If you Can, you Don't" << endl;
        return NULL;
    };
};
//终结符表达式简单，主要处理场景元素和数据的转换
//终结符表达式
class TerminalExpression :public Expression
{
    Object* interpreter(Context*ctx)
    {
        cout << "TerminalExpression::interpreter" << endl;
        return NULL;
    }
};

//每个非终结符表达式都表示一个文法规则，每个文法规则又只关心周边文法规则的结果，所以就会有递归调用而存在
//非终结符表达式
class NonterminalExpression :public Expression
{
public:
    NonterminalExpression(Expression* x1, ...)
    {
        for (int i = 0; i < 4; ++i)
        {
            _st.push(x1);
        }
    }
    Object *interpreter(Context*ctx)
    {
        //核心支出在于这里。。进行文法处理，并且产生递归调用
        //if(typeid().name() != "TerminalExpression")
        //递归调用
        //文法处理
        while (!_st.empty())
        {
            Expression* tp = _st.top();
            _st.pop();
            cout << "NoterminalExpression::interpreter" << endl;
            tp->interpreter(ctx);
        }
        return NULL;
    }
private:
    stack <Expression*> _st;
};
class Context{
};

class Client
{
public:
    void operator()()
    {
        Context *ctx = new Context();
        stack<Expression*> st;
        for (int i = 0; i < 5; ++i)
        {
            //进行语法判断，并且产生递归调用
            st.push(new TerminalExpression());
            st.push(new NonterminalExpression(new TerminalExpression()));
        }
        //for (int i = 0; i < 5; ++i)
        //{
        //    //进行语法判断，并且产生递归调用
        //    st.push(new NonterminalExpression(new TerminalExpression()));
        //    st.push(new TerminalExpression());
        //}
        //产生一个完整的语法树，由各个具体的语法分析进行解析
        Expression *exp = st.top();
        exp->interpreter(ctx);
    }
};

````

### 迭代器

**定义：**提供一种方法顺序访问一个聚合对象中各个元素, 而又不需暴露该对象的内部表示。

**实现要点：**

- 1．迭代抽象：访问一个聚合对象的内容而无需暴露它的内部表示。

- 2．迭代多态：为遍历不同的集合结构提供一个统一的接口，从而支持同样的算法在不同的集合结构上进行操作。

- 3．迭代器的健壮性考虑：遍历的同时更改迭代器所在的集合结构，会导致问题。

**适用性：**

- 1．访问一个聚合对象的内容而无需暴露它的内部表示。

- 2．支持对聚合对象的多种遍历。

- 3．为遍历不同的聚合结构提供一个统一的接口(即, 支持多态迭代)。

[参考资料](http://qiusuoge.com/13723.html)

### 中介者/调停者

**定义：**用一个中介对象来封装一系列的对象交互。中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互

**优点：**

- 简化了对象之间的关系，将系统的各个对象之间的相互关系进行封装，将各个同事类解耦，使得系统变为松耦合。
- 提供系统的灵活性，使得各个同事对象独立而易于复用。

**缺点：**

- 中介者模式中，中介者角色承担了较多的责任，所以一旦这个中介者对象出现了问题，整个系统将会受到重大的影响。
- 新增加一个同事类时，不得不去修改抽象中介者类和具体中介者类，此时可以使用观察者模式和状态模式来解决这个问题。

**中介者模式的适用场景：**

以下情况下可以考虑使用中介者模式：

- 一组定义良好的对象，现在要进行复杂的相互通信。

- 想通过一个中间类来封装多个类中的行为，而又不想生成太多的子类

[参考资料](https://www.cnblogs.com/ring1992/p/9593451.html)

### 备忘录

**定义：**在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态

**优点：**

- 1、给用户提供了一种可以恢复状态的机制，可以使用户能够比较方便地回到某个历史的状态。 
- 2、实现了信息的封装，使得用户不需要关心状态的保存细节。

**缺点：**

消耗资源。如果类的成员变量过多，势必会占用比较大的资源，而且每一次保存都会消耗一定的内存。

[参考资料](https://blog.csdn.net/wuzhekai1985/article/details/6672906)

### 观察者

**定义：**定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。当一个对象发生了变化，关注它的对象就会得到通知；这种交互也称为发布-订阅(publish-subscribe)。目标是通知的发布者，它发出通知时并不需要知道谁是它的观察者。

**优点：** 

- 1、观察者和被观察者是抽象耦合的。 
- 2、建立一套触发机制。

**缺点：** 

- 1、如果一个被观察者对象有很多的直接和间接的观察者的话，将所有的观察者都通知到会花费很多时间。
- 2、如果在观察者和观察目标之间有循环依赖的话，观察目标会触发它们之间进行循环调用，可能导致系统崩溃。 
- 3、观察者模式没有相应的机制让观察者知道所观察的目标对象是怎么发生变化的，而仅仅只是知道观察目标发生了变化。

[参考资料](https://www.cnblogs.com/carsonzhu/p/5770253.html)

### 状态

**定义：**当一个对象的内在状态改变时允许改变其行为，这个对象看起来像是改变了其类。

  状态模式主要解决的是当控制一个对象状态转换的条件表达式过于复杂时的情况。把状态的判断逻辑转移到表示不同状态的一系列类当中，可以把复杂的判断逻辑简化。将与特点状态相关的行为局部化，并且将不同状态的行为分割开来。

[参考资料](https://www.cnblogs.com/wrbxdj/p/5361004.html)

### 策略

**定义：**定义了算法家族，分别封装起来，让它们之间可以相互替换，此模式让算法变化，不会影响到使用算法的用户。

**使用场景：**用于屏蔽相同功能的不同版本算法接口差异，（比如人脸识别算法的封装）,用户可以任意使用各种算法，无需修改代码中已经调用的接口

[参考资料](https://blog.csdn.net/ysf465639310/article/details/90696773)

### 模板方法

**定义：**定义一个操作中的算法骨架，而将一些步骤延迟到子类中。主要实现就是通过继承、纯虚函数，需要理解的地方主要是有纯虚函数的类，派生类的内存存储。

**举例：**

````
#include "stdafx.h"
#include <process.h>
#include <iostream>
using namespace std;
 
//试卷模板
class TestPaper
{
public:
 void TestQuestion1()
 {
  cout<<"杨过得到玄铁,后来给了郭,炼成倚天剑,请问玄铁可能为() a 球磨矿, b 马口铁 c 高速合金钢, d 碳素纤维"<<endl;
  cout<<endl;
  cout<<"答案是:"<<answer1()<<endl;
  cout<<endl;
 }
 void TestQuestion2()
 {
  cout<<"杨过,程英,陆无双铲除了情花,造成了,() a 这种植物不再害人, b 使一种珍惜植物灭绝 c 破坏了生态平衡, d 造成该地区沙漠化"<<endl;
  cout<<endl;
  cout<<"答案是:"<<answer2()<<endl;
  cout<<endl;
 }
 void TestQuestion3()
 {
  cout<<"蓝凤凰致使华山师徒,桃谷六仙呕吐不止,如果你是医生,请问你要用什么药() a 阿斯匹林, b 牛黄解毒片 c 氲气, d 牛奶"<<endl;
  cout<<endl;
  cout<<"答案是:"<<answer3()<<endl;
  cout<<endl;
 }
 virtual ~TestPaper()
 {
 }
 TestPaper()
 {
 }
public:
 virtual char answer1()=0;
 virtual char answer2()=0;
 virtual char answer3()=0;
};
 
//学生A的试卷

class TestPaperA:public TestPaper
{
public:
 TestPaperA()
 {
 }
 ~TestPaperA()
 {
 }
public:
 char answer1(){return 'C';}
 char answer2(){return 'C';}
 char answer3(){return 'C';}
};
 
 
//学生B的试卷
class TestPaperB:public TestPaper
{
public:
 TestPaperB()
 {
 }
 ~TestPaperB()
 {
 }
public:
 char answer1()
 {
  return 'A';
 }
 char answer2()
 {
  return 'B';
 }
 char answer3()
 {
  return 'A';
 }
};
 
int main()
{
 cout<<"-------------------学生A的试卷-------------------"<<endl<<endl;
 TestPaper *pStuA=new TestPaperA();
 pStuA->TestQuestion1();
 pStuA->TestQuestion2();
 pStuA->TestQuestion3();
 cout<<endl<<endl;
 cout<<"------------------学生B的试卷------------------"<<endl<<endl;
 TestPaper *pStuB=new TestPaperB();
 pStuB->TestQuestion1();
 pStuB->TestQuestion2();
 pStuB->TestQuestion3();
 system("pause");
 return 0;
}
````

- 一个包含虚函数的类，将定义一个虚函数列表，称为**vtbl**。此列表的每一个slot都指向该类的一个虚成员函数。
- 每个对象增加一个指针，指向对应类的虚函数列表。此指针称为**vptr**。这个vptr相当于一个变量。但只由编译器自己管理（在构造、析构和复制函数中设定和重置），用户不能访问。同一个类的不同对象，将包含指向同一个vtbl的vptr，并且，不会随着对象指针类型的变化而变化
- 派生类继承后，在派生类对象的内存中，用重写的函数指针替换虚函数指针

　　这样利用多态，执行时就调用不同派生类的功能函数。

### 访问者

**定义：**表示一个作用于某对象结构中的各元素的操作，它使你可以在不改变各元素类的前提下定义作用于这些元素的新操作。

[参考资料](https://blog.csdn.net/liang19890820/article/details/79364406)

