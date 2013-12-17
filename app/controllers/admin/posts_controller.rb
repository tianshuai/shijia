# encoding: utf-8
class Admin::PostsController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_posts = true
  end

  #分类列表
  def index
    @css_post_list = true
    @posts = Post.news.undeleted.order_b.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #回收站
  def recycle
	@css_recycle_list = true
    @posts = Post.news.deleted.order_b.recent.paginate(:page => params[:page], :per_page => 10)
  end

  #新的
  def new
    @post = Post.new
    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
	  if @post.present?
        format.html
        #format.json { render json: @post }
	  else
        format.html { redirect_to admin_posts_path, notice: '内容不存在!'}
	  end
	end
  end

  def create
    @post = Post.new(params.require(:post).permit!)
    respond_to do |format|
      if @post.save
        #保存封面图
        if params[:asset_id]
          #获得文件/格式
		  file = params[:asset_id]
          file_temp = file.tempfile
		  file_name = file.original_filename
		  user_id = params[:user_id].to_i
          #上传
          result = ImageUnit::Upload.save_asset(file_temp,4, { user_id: user_id, filename: file_name, img_kind: ['o','s'] })
		  if result[:result]
            result[:name] = file_name
            result[:relateable_id] = @post.id
            result[:relateable_type] = 'Post'
	  	    result[:kind] = 2
            hash = collect_asset(result)
            asset = Asset.new(hash)
            if asset.save
              @post.update(cover_id: asset.id )
            end
		  end
        end
        #保存编辑器图片
        if params[:asset_ids]
          params[:asset_ids].split(',').each do |id|
            asset = Asset.find(id)
            asset.update(relateable_id: @post.id, relateable_type: @post.class.to_s) if asset.present?
          end
        end
        format.html { redirect_to admin_posts_path, notice: '创建成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '创建失败!'
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update(params.require(:post).permit!)
        #保存封面图
        if params[:asset_id]
          #获得文件/格式
		  file = params[:asset_id]
          file_temp = file.tempfile
		  file_name = file.original_filename
		  user_id = params[:user_id].to_i
          #上传
          result = ImageUnit::Upload.save_asset(file_temp,4, { user_id: user_id, filename: file_name, img_kind: ['o','s'] })
		  if result[:result]
            result[:name] = file_name
            result[:relateable_id] = @post.id
            result[:relateable_type] = 'Post'
	  	    result[:kind] = 2
            hash = collect_asset(result)
            asset = Asset.new(hash)
            if asset.save
              @post.update(cover_id: asset.id )
            end
		  end
        end
        format.html { redirect_to admin_posts_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  #非物理删除
  def destroy
    @post = Post.find(params[:id])
	if @post.present?
	  @post.mark_delete
	  @success = true
	  @notice = "删除成功!"
    else
	  @success = false
	  @notice = ' 删除失败!'
	end

    respond_to do |format|
      format.html
      format.js { render :destroy }
    end
  end

  #删除
  def destroy_true
    @post = Post.find(params[:id])
	if @post.present?
	  @post.destroy
	  @success = true
	  @notice = "删除成功!"
    else
	  @success = false
	  @notice = ' 删除失败!'
	end

    respond_to do |format|
      format.html
      format.js { render :destroy }
    end
  end

  def restore
    @post = Post.find(params[:id])
	if @post.present?
	  @post.mark_restore
	  @success = true
	  @notice = "恢复成功!"
    else
	  @success = false
	  @notice = ' 恢复失败!'
	end

    respond_to do |format|
      format.html
      format.js { render :destroy }
    end
  end

  #批量非物理删除
  def destroy_more
	arr = params[:ids]
	arr.split(',').each do |id|
      post = Post.find(id)
	  if post.present?
	    post.mark_delete
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #批量删除
  def destroy_true_more
	arr = params[:ids]
	arr.split(',').each do |id|
      post = Post.find(id)
	  if post.present?
	    post.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #批量还原
  def restore_more
	arr = params[:ids]
	arr.split(',').each do |id|
      post = Post.find(id)
	  if post.present?
	    post.mark_restore
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update(state: params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_state }
    end
  end

  #ajax 设置推荐
  def ajax_set_stick
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update(stick: params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_stick }
    end
  end

  #ajax 设置发布
  def ajax_set_publish
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update(publish: params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_publish }
    end
  end


end
