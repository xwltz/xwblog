---
title: .NetCore3.0 DDD驱动设计
comments: true
passage_end: true
copyright: true
date: 2019-09-25 11:53:20
tags: 
- .netcore
- DDD设计
categories: ASP.NET CORE
---

#### 基础设施层
> 基础设施层使用的相关知识：Code First ，EF Core，Autofac依赖注入，仓储模式的实现接口，领域服务的实现接口，缓存，以及各种基础工具类
1. Code First：使用Code First 数据迁移到数据库。
常用的数据库迁移命令： 
Add-Migration 迁移名 —— 添加本次迁移 
Update-Database——将本次迁移到数据库 
Add-Migration InitialCreate -IgnoreChanges -—— 创建一次空的数据迁移：已现在版本为起始点
2. EF Core ：软删除 ——全局过滤删除的状态，AsNoTracking() ——不持久化到数据库时的查询使用 Any——查询判断使用Any ,Z.EntityFramework.Plus-——批量修改，删除，增删改查，简单封装异步 Anysnc Await 方法
3. 工具类，例如MD5，AutoMapperHelper，LamdaHelper，RedisHelper简单应用，读取配置文件,统一返回参数等。
4. Redis缓存，多种数据类型，查询，插入效率高，Redis与数据库同步策略，先更新数据库在删除缓存，延时双删，（延时，根据数据查询的数据来判断延时的时间），使用StackExchange.Redis

#### 应用层
> 应用层使用的相关知识：AutoMapper，Dto，Autofac依赖注入
1. Dto：数据传输对象，主要是展现层和应用层传输数据
2. AutoMapper：对象之间传输数据，先使用仓储查询出数据，然后通过AutoMapper转换成前端需要的数据返回

#### 领域层
> 领域层使用的相关知识：实体，值对象，领域服务接口，仓储接口，聚合，Autofac依赖注入
1. 实体：有唯一的标识（唯一，不可变），包含业务逻辑，以及自身的验证，构造函数实例化，实体的Set应设置为私有的
2. 值对象：没有唯一的标识，用来描述一个东西的特征，代表是什么
3. 聚合：聚合根是实体，聚合是对象的组合，由聚合本身维护自身的一致性，封装业务逻辑，聚合尽量小，聚合之间通过唯一标识引用
4. 仓储：仓储是针对聚合的，封装领域逻辑，明确查询的意图，仓储中只维护聚合的状态，不进行持久化，仓储可以方便单元测试，更换ORM
5. 领域服务：，领域服务是无状态的，有些业务逻辑不好放在聚合里面的可以使用领域服务，多个聚合根协调，领域服务中可以使用仓储
6. Autofac依赖注入：有利于项目层与层之间的解耦，方便单元测试，构造函数注入，依赖倒置，通过约定进行程序集的注入

#### 展现层
1. 展现层使用的相关知识：.Net Core WebApi ,MVC,JWT Swagger,日志异常的捕捉，模型的验证，Log4Net，Autofac依赖注入，过滤器
2. JWT：JWT包含了使用.分隔的三部分： Header 头部 Payload 负载 Signature 签名，在前端每次请求加上JWT 签发的Token 来替代Session，进行访问页面的验证
3. Swagger：可以使用Swagger来请求WebApi ，以及查看WebApi 接口，Swagger可以做接口文档
4. Log4Net：日志异常的全局捕捉，记录日志到TXT中
5. 过滤器：使用过滤器来进行模型的验证 ，Log4Net的日志异常的全局捕捉，以及权限的访问