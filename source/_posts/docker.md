---
title: ASP.NET Core 3 Docker
comments: true
passage_end: true
copyright: true
date: 2019-10-24 16:05:10
tags: 
- .netcore
- Docker
categories: ASP.NET Core 3
---

对于一个 .NET Core开发人员，你可能没有使用过Docker，但是你不可能没有听说过Docker。Docker是Github上最受欢迎的开源项目之一，它号称要成为所有云应用的基石，并把互联网升级到下一代。Docker是dotCloud公司开源的一款产品，从其诞生那一刻算起，在短短两三年时间里就成为了开源社区最火爆的项目。对于完全拥抱开源的.NET Core来说，它自然应该对Docker提供完美的支持。对于接下来的内容，我们假设你已经对Docker有了基本的了解，并且在你的机器上已经安装了Docker。

### 一、创建一个ASP.NET Core应用
我们将演示如何创建一个ASP.NET Core程序并将其编译成Docker镜像，并Docker环境针对该镜像创建一个容器来启动一个应用实例。简单起见，我们还是直接采用脚手架命令行的形式来创建这个ASP.NET Core应用。如下图1所示，我们执行dotnet new web命令在"d:\projects\helloworld"目录下创建一个空的ASP.NET Core应用。

 ![img](https://ask.qcloudimg.com/http-save/yehe-1161266/q716abhgtb.png?imageView2/2/w/1620) 


### 二、定义Dokerfile
我们现在需要将这个ASP.NET Core应用制作成一个Docker镜像，为此我们需要在项目根目录下创建一个Dockerfile文件（文件名就是Dokerfile，没有扩展名），并在该文件中定义如下的内容。如果我们对Dockerfile具有基本的了解，对于这个文件的内容应该不难理解。

```
# 1. 指定编译和发布应用的镜像
FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build

# 2. 指定（编译和发布）工作目录
WORKDIR /app

# 3. 拷贝.csproj到工作目录/app，然后执行dotnet restore恢复所有安装的NuGet包
COPY *.csproj ./
RUN dotnet restore

# 4. 拷贝所有文件到工作目录(/app)，然后执行dotnet publish命令将应用发布到/app/out目录下
COPY . ./
RUN dotnet publish -c Release -o out

# 5. 编译生成Docker镜像
# 5.1.设置基础镜像
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime

# 5.2. 设置（运行）工作目录，并将发布文件拷贝到out子目录下
WORKDIR /app
COPY --from= build /app/out .

# 5.3. 利用环境变量设置ASP.NET Core应用的监听地址
ENV ASPNETCORE_URLS http://0.0.0.0:3721

# 5.4. 执行dotnet命令启动ASP.NET Core应用
ENTRYPOINT ["dotnet", "helloworld.dll"]
```

这个Dockerfile采用了一个中间层（build）来暂存ASP.NET Core MVC应用发布后的资源，其工作目录为"/app"。具体来说，这个层采用"microsoft/aspnetcore-build:2"作为基础镜像，我们先将定义项目的.csproj文件（helloworld.csproj）拷贝到当前工作目录，然后运行"dotnet restore"命令恢复所有注册在这个项目文件中的NuGet包。接下来我们将当前项目的所有文件拷贝到当前工作目录，并执行dotnet publish对整个项目进行编译发布（针对Release模式），发布后的资源被保存到目录"/app/out"中。

在真正将编译生成Docker镜像的时候，我们采用"mcr.microsoft.com/dotnet/core/aspnet:3.0"作为基础镜像，由于应用在上面进行了预先发布，所以我们只需要将发布后的所有文件拷贝到当前工作目录就可以了。接下来我们通过环境变量设置了ASP.NET Core应用的监听地址 "http://0.0.0.0:3721" 。 针对ENTRYPOINT的定义（ENTRYPOINT ["dotnet", "helloworld.dll"]），我们知道当容器被启动的时候，"dotnet helloworld.dll"命令会被执行以启动这个ASP.NET Core应用。

### 三、生成镜像
Dockerfile文件定义好之后，我们打开CMD命令行并切换到项目所在根目录（也就是Dockerfile文件所在的目录），然后执行"docker build -t helloworldapp ."命令，该命令会利用这个Dockerfile文件生成一个命名为helloworldapp"的Docker镜像。

 ![img](https://ask.qcloudimg.com/http-save/yehe-1161266/jr931k59gi.png?imageView2/2/w/1620) 


### 四、启动容器
既然Docker镜像已经被成功创建出来了，那么余下的工作就很简单了，我们只需要针对这个镜像创建对应的容器，最终的ASP.NET Core应用的启动就可以直接通过启动该容器来完成。如下图所示，我们执行"docker run -d -p 8080:3721 --name myapp helloworldapp"命令针对前面生成的Docker镜像（helloworldapp）创建并启动了一个命名为myapp（--name myapp）的容器。由于我们从外面访问这个应用，所以我们通过端口映射（-p 8080:3721）将内部监听端口3721映射为当前宿主机器的端口8080，所以我们利用地址 "http://localhost:8080" 访问这个通过Docker容器承载的ASP.NET Core应用。

 ![img](https://ask.qcloudimg.com/http-save/yehe-1161266/slmtqdeeen.png?imageView2/2/w/1620) 