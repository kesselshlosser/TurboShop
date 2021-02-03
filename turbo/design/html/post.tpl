{if $post->id}
    {$meta_title = $post->name scope=global}
{else}
    {$meta_title = $btr->post_new scope=global}
{/if}

<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$post->id}
                    {$btr->post_add|escape}
                {else}
                    {$post->name|escape}
                {/if}
            </div>
            {if $post->id}
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info add" target="_blank" href="../{$lang_link}blog/{$post->url}">
                    {include file='svg_icon.tpl' svgId='icon_desktop'}
                    <span>{$btr->general_open|escape}</span>
                </a>
            </div>
            {/if}
			</div>
    </div>
    <div class="col-md-12 col-lg-12 col-sm-12 float-xs-right"></div>
</div>

{if $message_success}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_success">
            <div class="heading_box">
                {if $message_success == 'added'}
                    {$btr->post_added|escape}
                {elseif $message_success == 'updated'}
                    {$btr->post_updated|escape}
                {/if}
                {if $smarty.get.return}
                <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                    {include file='svg_icon.tpl' svgId='return'}
                    <span>{$btr->general_back|escape}</span>
                </a>
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

{if $message_error}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_warning">
            <div class="heading_box">
                {if $message_error == 'url_exists'}
                    {$btr->post_exists|escape}
                {elseif $message_error=='empty_name'}
                    {$btr->general_enter_title|escape}
                {elseif $message_error == 'empty_url'}
                    {$btr->general_enter_url|escape}
                {elseif $message_error == 'url_wrong'}
                    {$btr->general_not_underscore|escape}
                {else}
                    {$message_error|escape}
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

<form method=post enctype="multipart/form-data" class="fn_fast_button">
    <input type="hidden" name="session_id" value="{$smarty.session.id}" />
    
	<div class="row">
        <div class="col-xs-12 ">
            <div class="boxed match_matchHeight_true">
                <div class="row d_flex">
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->general_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control" name="name" type="text" value="{$post->name|escape}"/>
                            <input name="id" type="hidden" value="{$post->id|escape}"/>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-lg-6 col-md-10">
                                <div class="">
                                    <div class="input-group">
                                        <span class="input-group-addon">URL</span>
                                        <input name="url" class="fn_meta_field form-control fn_url {if $post->id}fn_disabled{/if}" {if $post->id}readonly=""{/if} type="text" value="{$post->url|escape}" />
                                        <input type="checkbox" id="block_translit" class="hidden" value="1" {if $post->id}checked=""{/if}>
                                        <span class="input-group-addon fn_disable_url">
                                            {if $post->id}
                                            <i class="fa fa-lock"></i>
                                            {else}
                                            <i class="fa fa-lock fa-unlock"></i>
                                            {/if}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item">
                                <div class="turbo_switch clearfix">
                                    <label class="switch_label">{$btr->general_enable|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="visible" value='1' type="checkbox" id="visible_checkbox" {if $post->visible}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-3 col-md-12 pr-0">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->general_image|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <ul class="brand_images_list">
                        <li class="brand_image_item">
                            {if $post->image}
                            <input type="hidden" class="fn_accept_delete" name="delete_image" value="">
                            <div class="fn_parent_image2">
                                <div class="category_image image_wrapper fn_image_wrapper2 text-xs-center">
                                    <a href="javascript:;" class="fn_delete_item remove_image"></a>
                                    <img src="{$post->image|resize_posts:300:120}" alt="" />
                                </div>
                            </div>
                            {else}
                            <div class="fn_parent_image2"></div>
                            {/if}
                            <div class="fn_upload_image2 dropzone_block_image {if $post->image} hidden{/if}">
                                <i class="fa fa-plus font-5xl" aria-hidden="true"></i>
                                <input class="dropzone_image2" name="image" type="file" />
                            </div>
                            <div class="category_image image_wrapper fn_image_wrapper2 fn_new_image2 text-xs-center">
                                <a href="javascript:;" class="fn_delete_item remove_image"></a>
                                <img src="" alt="" />
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-12 pr-0">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->general_image|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 toggle_body_wrap on fn_card">
                        <div class="row">
                            <div class="col-lg-12">
                                <div>
                                    <div class="heading_label">{$btr->general_date|escape}</div>
                                    <div class="">
                                        <input name="date" class="form-control" type="text" value="{$post->date|date}" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-12">
            <div class="boxed match fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->general_metatags|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card row">
                    <div class="col-lg-6 col-md-6">
                        <div class="heading_label">Meta-title <span id="fn_meta_title_counter"></span></div>
                        <input name="meta_title" class="form-control fn_meta_field mb-h" type="text" value="{$post->meta_title|escape}" />
                        <div class="heading_label">Meta-keywords</div>
                        <input name="meta_keywords" class="form-control fn_meta_field mb-h" type="text" value="{$post->meta_keywords|escape}" />
                    </div>
                    
                    <div class="col-lg-6 col-md-6 pl-0">
                        <div class="heading_label">Meta-description <span id="fn_meta_description_counter"></span></div>
                        <textarea name="meta_description" class="form-control turbo_textarea fn_meta_field">{$post->meta_description|escape}</textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed match fn_toggle_wrap tabs">
                <div class="heading_tabs">
                    <div class="tab_navigation">
                        <a href="#tab1" class="heading_box tab_navigation_link">{$btr->general_short_description|escape}</a>
                        <a href="#tab2" class="heading_box tab_navigation_link">{$btr->general_full_description|escape}</a>
                    </div>
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="tab_container">
                        <div id="tab1" class="tab">
                            <textarea name="annotation" id="annotation" class="editor_small">{$post->annotation|escape}</textarea>
                        </div>
                        <div id="tab2" class="tab">
                            <textarea id="fn_editor" name="body" class="editor_large fn_editor_class">{$post->text|escape}</textarea>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 col-md-12 mt-1">
                        <button type="submit" class="btn btn_small btn_green float-md-right">
                            {include file='svg_icon.tpl' svgId='checked'}
                            <span>{$btr->general_apply|escape}</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<!-- Основная форма (The End) -->

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-{$settings->lang}.js"></script>
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
{literal}
<script>
    $(window).on("load", function() {
        
        $('input[name="date"]').datepicker({
            regional:'{/literal}{$settings->lang}{literal}'
        });
        
    });
</script>
{/literal}