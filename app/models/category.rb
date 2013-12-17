class Category < ActiveRecord::Base

  ##关系
  has_many    :posts

  ##常量
  #状态
  STATE = {
  	no: 0,
	ok: 1
  }

  #类型
  KIND = {
  	#新闻
	news: 1,
	#奖项
	prize: 2
  }

  ##验证
  validates_presence_of :name,                message: "请输入名称"
  validates_presence_of :kind,                message: "请选择分类"
  validates_numericality_of :sort,            only_integer: true, message: "必须是整数"

  ##过滤
  #排序
  scope :recent,      	-> { order(id: :desc) }
  scope :order_b,		-> { order(sort: :desc) }
  #父分类
  scope :parent_level,	-> { where(pid: 0) }
  #通过父类ID查看子类
  scope :child_level,	lambda{ |id| where(pid: id) }
  #开启的
  scope :available,		-> { where(state: STATE[:ok]) }
  #关闭的
  scope :unavailable,	-> { where(state: STATE[:no]) }
  #文章
  scope :news,			-> { where(kind: KIND[:news]) }
  #未定义类型
  scope :prize,			-> { where(kind: KIND[:prize]) }

  ##方法
  #
  #通过类型查看分类，用于下拉选项
  def self.kind_options(kind=1)
	self.where(kind: kind).available.collect{ |x| [x.name, x.id] }
  end

  #父类级
  def self.parent_options(kind=1)
	case kind
	when 1
	  self.parent_level.news.available.collect{ |x| [x.name, x.id] }
	when 2
	  self.parent_level.undefault.available.collect{ |x| [x.name, x.id] }
	else
	  [ [] ]
	end
  end

  #通过父类id查看子分类
  def self.child_options(pid, kind=1)
	self.available.child_level(pid).order_b.collect{ |x| [x.name, x.id] }
  end

  #类型说明
  def kind_str
	case self.kind
	when 1 then '新闻'
	when 2 then '奖项'
	else
	  '未定义'
	end
  end

  #类型下拉选项
  def self.static_options
	[ ['新闻', 1], [ '奖项', 2 ], [ '未定义', 3 ] ]
  end


end
