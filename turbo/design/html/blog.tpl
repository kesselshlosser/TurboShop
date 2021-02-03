{* Title *}
{$meta_title= $btr->blog_blog scope=global}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if $keyword && $posts_count}
                   {$btr->blog_blog|escape} - {$posts_count}
                {elseif $posts_count}
                    {$btr->blog_blog|escape} - {$posts_count}
                {/if}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=PostAdmin return=$smarty.server.REQUEST_URI}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->blog_add|escape}</span>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-12 col-lg-5 col-xs-12 float-xs-right">
        <div class="boxed_search">
            <form class="search" method="get">
                <input type="hidden" name="module" value="BlogAdmin">
                <div class="input-group">
                    <input name="keyword" class="form-control" placeholder="{$btr->blog_search|escape}" type="text" value="{$keyword|escape}" >
                    <span class="input-group-btn">
                        <button type="submit" class="btn btn_green"><i class="fa fa-search"></i> <span class="hidden-md-down"></span></button>
                    </span>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="boxed fn_toggle_wrap">
    {if $posts}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <form class="fn_form_list" method="post">
                <input type="hidden" name="session_id" value="{$smarty.session.id}">
                <div class="post_wrap turbo_list">
                    <div class="turbo_list_head">
                        <div class="turbo_list_heading turbo_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                            <label class="turbo_ckeckbox" for="check_all_1"></label>
                        </div>
                        <div class="turbo_list_heading turbo_list_photo">{$btr->general_photo|escape}</div>
                        <div class="turbo_list_heading turbo_list_blog_name">{$btr->blog_name|escape}</div>
                        <div class="turbo_list_heading turbo_list_status">{$btr->general_enable|escape}</div>
                        <div class="turbo_list_heading turbo_list_setting turbo_list_blog_setting">{$btr->general_activities|escape}</div>
                        <div class="turbo_list_heading turbo_list_close"></div>
                    </div>
                    <div class="turbo_list_body">
                        {foreach $posts as $post}
                        <div class="fn_row turbo_list_body_item">
                            <div class="turbo_list_row">
                                <div class="turbo_list_boding turbo_list_check">
                                    <input class="hidden_check" type="checkbox" id="id_{$post->id}" name="check[]" value="{$post->id}"/>
                                    <label class="turbo_ckeckbox" for="id_{$post->id}"></label>
                                </div>
                                <div class="turbo_list_boding turbo_list_photo">
                                    {if $post->image}
                                    <a href="{url module=PostAdmin id=$post->id return=$smarty.server.REQUEST_URI}">
                                        <img src="{$post->image|resize_posts:55:55}"/>
                                    </a>
                                    {else}
                                    <a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">
                                        <i class="fa fa-picture-o fa-3-3x mt-h4" aria-hidden="true"></i>
                                    </a>  
                                    {/if}
                                </div>
                                <div class="turbo_list_boding turbo_list_blog_name">
                                    <a class="link" href="{url module=PostAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$post->name|escape}</a>
                                    <span class="text_grey">{$post->date|date}</span>
                                </div>
                                <div class="turbo_list_boding turbo_list_status">
                                    <label class="switch switch-default ">
                                        <input class="switch-input fn_ajax_action {if $post->visible}fn_active_class{/if}" data-module="blog" data-action="visible" data-id="{$post->id}" name="visible" value="1" type="checkbox"  {if $post->visible}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                                <div class="turbo_list_setting turbo_list_blog_setting">
                                    {*open*}
                                    <a href="../blog/{$post->url}" target="_blank" data-hint="{$btr->general_view|escape}" class="setting_icon setting_icon_open hint-bottom-middle-t-info-s-small-mobile  hint-anim">
                                        {include file='svg_icon.tpl' svgId='icon_desktop'}
                                    </a>
                                </div>
                                <div class="turbo_list_boding turbo_list_close">
                                    {*delete*}
                                    <button data-hint="{$btr->blog_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                        {include file='svg_icon.tpl' svgId='delete'}
                                    </button>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                    <div class="turbo_list_footer fn_action_block">
                        <div class="turbo_list_foot_left">
                            <div class="turbo_list_heading turbo_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                <label class="turbo_ckeckbox" for="check_all_2"></label>
                            </div>
                            <div class="turbo_list_option">
                                <select name="action" class="selectpicker">
                                    <option value="enable">{$btr->general_do_enable|escape}</option>
                                    <option value="disable">{$btr->general_do_disable|escape}</option>
                                    <option value="delete">{$btr->general_delete|escape}</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn_small btn_green">
                            {include file='svg_icon.tpl' svgId='checked'}
                            <span>{$btr->general_apply|escape}</span>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
	<div class="row">
        <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
            {include file='pagination.tpl'}
        </div>
    </div>
    {else}
    <div class="heading_box mt-1">
        <div class="text_grey">{$btr->blog_no_post|escape}</div>
    </div>
    {/if}
</div>