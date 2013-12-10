## 基本信息
  * web: 十佳网站
  * auther_by: shijue developer

  * Ruby 2.0.0+, Rails 4.0.0
  * 数据库: mysql 5.5.32


##启动前准备工作
  *生产环境数据名为：shijia
  *给mongodb创建索引：rake db:mongoid:create_indexes
　*初次使用可以导入数据库模版，包括已经创建好的分类和栏目位信息(该站点下所有的二级分类均从数据库读取)，模版位于db目录下……
　*如发布到生产环境需要压缩js、css、img文件，命令：rake assets:precompile,  反之，清理压缩后的命令:rake assets:clean
  *需要更改生产环境下的配置文件路径: /config/site_config/production.yml

 *如发布生产环境，静态文件如果由前端服务器处理（如：nginx），需要更改/config/environments/production.rb :   config.serve_static_assets = false

 *注册第一个用户后需要手动进入mongodb，把权限改为超级管理员（只有超级管理员才可以给其它用户更改权限）：role_id=8
 *改完后在首页导航可以进入后台页面
 *现在注册登录地址均为隐藏，可手动输入网址进入：注册页：/signup;  登录页：/signin


##启动
 *rails s　

##网站逻辑：
 *网站导航的七个菜单：首页、学院概况、学院新闻、艺术教学、学院丛书、招生详情、学生工作
 * 
 *学院新闻、学院丛书、作品　出自Post表，Category分类表
 *学院概况、艺术教学、招生详情、学生工作　出自Static表，Position分类表
 *Block BlockSpace表用于栏目位管理


