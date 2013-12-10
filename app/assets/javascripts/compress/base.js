/*
 * 十佳网站 by tian and dong
 * ==========================================================================================================
*/
var sj = {
    redirect: function(url,delay) {
        setTimeout(function(){
            window.location = url;
        },delay);
    },
    show_error_note: function(msg,delay) {
        if(!delay){
            delay=3000;
        }
        var icon = '<img src="/assets/jbar_error_new.gif" width="31" height="31" />';
        sj.show_notify_bar(icon+msg,'error',delay,"bar_error");
    },
    show_ok_note:function(msg,delay) {
        if(!delay){
            delay=2000;
        }
        var icon = '<img src="/assets/jbar_ok_new.gif" width="31" height="31" />';
        sj.show_notify_bar(icon+msg,'ok',delay,"bar_ok");
    },
    show_notice_note:function(msg,delay) {
        if(!delay){
            delay=3000;
        }
        var icon = '<img src="/assets/jbar_notice_new.gif" width="31" height="31" />';
        sj.show_notify_bar(icon+msg,'notice',delay,"bar_notice");
    },
    show_notify_bar: function(msg,type,delay) {
        var bgcolor ,fntcolor;
        if(!type || type == 'ok'){
            type = 'ok';
            bgcolor =  '#fff' ;
            fntcolor = '#222';
            className = 'jbar-ok';
        }else if(!type || type == 'error'){
            type = 'error';
            bgcolor =  '#fff';
            fntcolor = '#222';
            className = 'jbar-error';
        }else{
            type = 'notice';
            bgcolor =  '#fff';
            fntcolor = '#222';
            className = 'jbar-notice';
        }
        $.show_notify_bar({
            color 			 : fntcolor,
            background_color : bgcolor,
            position		 : 'top',
            removebutton     : true,
            message			 : msg,
            time			 : delay,
            container: '#doc',
            className : className
        });
    }
};

//初始化常用功能
sj.initial = function()
{
    /* 此类为hash链接 */
    $('a.ajax-hash').on('click',function(){
        var hash = this.hash && this.hash.substr(1);
        if (hash != ""){
            eval(hash + '.call(this);');
        }
        return false;
    });

    /* 此类为确认后执行的ajax操作 */
    $('a.confirm-request').on('click',function(){
        if(confirm('确认执行这个操作吗?')){
            $.get($(this).attr('href'));
        }
        return false;
    });

};

/**
 * 允许多附件上传
 */
sj.record_asset_ids = function(id,block_id){
    var ids = $(block_id).val();
    if (ids.length == 0){
        ids = id;
    }else{
        if (ids.indexOf(id) == -1){
            ids += ','+id;
        }
    }
    $(block_id).val(ids);
};

//移除附件id
sj.remove_asset_id = function(id,block_id){
    var ids = $(block_id).val();
    var ids_arr = ids.split(',');
    var is_index_key = sj.in_array(ids_arr,id);
    ids_arr.splice(is_index_key,1);
    ids = ids_arr.join(',');
    $(block_id).val(ids);
};

//查看字符串是否在数组中存在
sj.in_array = function(arr, val) {
    var i;
    for (i = 0; i < arr.length; i++) {
        if (val === arr[i]) {
            return i;
        }
    }
    return -1;
}; // 返回-1表示没找到，返回其他值表示找到的索引
